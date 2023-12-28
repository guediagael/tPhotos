import 'dart:io';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mime/mime.dart';
import 'package:tphotos/data/data_manager_impl.dart';
import 'package:tphotos/data/models/media.dart';
import 'package:tphotos/main.dart';
import 'package:tphotos/utils/permissions.dart';

const String _notificationChannelId = "tPhotos";
const String _notificationChannelTitle = "MEDIA SYNC";

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    _notificationChannelId, // id
    _notificationChannelTitle, // title
    description:
        'This channel is used for to notify about media sync with telegram.',
    // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: _notificationChannelId,
      // initialNotificationTitle: _notificationChannelTitle,
      // initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  await MyApp.appInitSettings();
  DartPluginRegistrant.ensureInitialized();

  bool storagePermissionGranted = await checkStoragePermission(null);
  if (!storagePermissionGranted) {
    return false;
  }
  List<String> rootPaths =
      DataManagerImpl.getInstance().preferencesSettingsApi.getSyncedFolders();
  if (rootPaths.isEmpty) {
    return false;
  }

  bool syncedLocally = await _localSync(rootPaths);
  bool uploadedToCloud = await _uploadQueue(service);

  return syncedLocally && uploadedToCloud;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  await MyApp.appInitSettings();
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  bool storagePermissionGranted = await checkStoragePermission(null);
  if (!storagePermissionGranted) {
    return;
  }
  List<String> rootPaths =
      DataManagerImpl.getInstance().preferencesSettingsApi.getSyncedFolders();
  if (rootPaths.isEmpty) {
    return;
  }

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  if (service is AndroidServiceInstance) {
    if (await service.isForegroundService()) {
      /// OPTIONAL for use custom notification
      /// the notification id must be equals with AndroidConfiguration when you call configure() method.
      flutterLocalNotificationsPlugin.show(
        888,
        _notificationChannelTitle,
        'Syncing  ${rootPaths.length} folders from your device',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _notificationChannelId,
            _notificationChannelTitle,
            icon: 'ic_bg_service_small',
            ongoing: true,
          ),
        ),
      );

      // if you don't using custom notification, uncomment this
      // service.setForegroundNotificationInfo(
      //   title: "My App Service",
      //   content: "Updated at ${DateTime.now()}",
      // );
    }
  }
  await _localSync(rootPaths);
  await _uploadQueue(service, flutterLocalNotificationsPlugin);
  _clearNotification(service, flutterLocalNotificationsPlugin);
}

Future<bool> _localSync(List<String> paths) async {
  int count = 0;
  for (String path in paths) {
    count += 1;
    Directory folder = Directory(path);
    bool folderExists = await folder.exists();
    if (folderExists) {
      Stream<FileSystemEntity> files = folder.list(recursive: true);
      files.forEach((element) async {
        FileStat value = await element.stat();
        String mimeType = lookupMimeType(element.path) ?? "";
        if ((value.type == FileSystemEntityType.file) &&
                (mimeType.startsWith('image')) ||
            (mimeType.startsWith('video'))) {
          Digest digest = sha256.convert(File(element.path).readAsBytesSync());
          Media newMedia = Media(
              mediaHash: digest.toString(),
              caption: "TODO",
              //TODO: add EXIFF data
              mediaDate: value.modified.millisecondsSinceEpoch,
              createdDate: DateTime.now().millisecondsSinceEpoch,
              fileName: element.path.split('/').last,
              filePath: element.path,
              mimeType: mimeType);
          DataManagerImpl.getInstance().mediaDatabase.addMedias([newMedia]);
        }
      });
    }
  }
  return count == paths.length;
}

Future<bool> _uploadQueue(ServiceInstance service,
    [FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin]) async {
  int count = await DataManagerImpl.getInstance().mediaDatabase.countQueue();

  debugPrint("timeline_bloc::_uploadQueue uploading $count items from device");

  if (flutterLocalNotificationsPlugin != null) {
    await _showForegroundNotification(service, flutterLocalNotificationsPlugin,
        'Uploading  $count files from your device to Telegram');
  }

  try {
    int uploadCount = 0;
    do {
      uploadCount += await _uploadItemsToTelegram(uploadCount);
      if (flutterLocalNotificationsPlugin != null) {
        await _showForegroundNotification(
            service,
            flutterLocalNotificationsPlugin,
            'Uploaded  $uploadCount/$count files from your device to Telegram');
      }
    } while (uploadCount < count);
  } catch (_) {
    debugPrintStack();
  }
  if (flutterLocalNotificationsPlugin != null) {
    _clearNotification(service, flutterLocalNotificationsPlugin);
  }
  return true;
}

Future<int> _uploadItemsToTelegram([int offset = 0, limit = 20]) async {
  List<Media> uploadQueue = await DataManagerImpl.getInstance()
      .mediaDatabase
      .loadUploadQueue(limit, offset: offset);
  for (Media media in uploadQueue) {
    //TODO: send to Telegram and update the item in the local database
    Future.delayed(const Duration(seconds: 5), () {
      debugPrint(
          "media_sync_service::_uploadItemsToTelegram uploadQueue $media");
    });
  }
  return limit;
}

_showForegroundNotification(
    ServiceInstance service,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    String message) async {
  if (service is AndroidServiceInstance) {
    if (await service.isForegroundService()) {
      /// OPTIONAL for use custom notification
      /// the notification id must be equals with AndroidConfiguration when you call configure() method.
      flutterLocalNotificationsPlugin.show(
        888,
        _notificationChannelTitle,
        message,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _notificationChannelId,
            _notificationChannelTitle,
            icon: 'ic_bg_service_small',
            ongoing: true,
          ),
        ),
      );

      // if you don't using custom notification, uncomment this
      // service.setForegroundNotificationInfo(
      //   title: "My App Service",
      //   content: "Updated at ${DateTime.now()}",
      // );
    }
  }
}

_clearNotification(ServiceInstance serviceInstance,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  if (serviceInstance is AndroidServiceInstance) {
    if (await serviceInstance.isForegroundService()) {
      flutterLocalNotificationsPlugin.cancelAll();
    }
  }
}
