import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tdlib/td_api.dart';
import 'package:tdlib/tdlib.dart';
import 'package:tphotos/bloc/base/navigator/base_nav_event.dart';
import 'package:tphotos/bloc/base/navigator/base_navigator_bloc.dart';

int _random() => Random().nextInt(10000000);

class TelegramService extends ChangeNotifier {
  late int _client;
  late StreamController<TdObject> _eventController;
  late StreamSubscription<TdObject> _eventReceiver;
  Map results = <int, Completer>{};
  Map callbackResults = <int, Future<void>>{};
  late Directory appDocDir;
  late Directory appExtDir;

  final ReceivePort _receivePort = ReceivePort();
  late Isolate _isolate;

  final String? systemLanguage;
  final String? systemVersion;
  final String? deviceModel;
  final String appVersion;
  final int applicationId;
  final String apiHash;

  late BaseNavigatorBloc navigatorBloc;

  static Future<TelegramService> build(Map<String, dynamic> keys) async {
    final packageInfo = await PackageInfo.fromPlatform();

    final keysFile = await rootBundle.loadString('secrets/keys.json');
    final keys = await json.decode(keysFile);
    final tgHash = keys['telegram_api_hash'];
    final tgAppId = keys['telegram_app_id'];

    String? deviceModel;
    if (Platform.isAndroid) {
      final di = await DeviceInfoPlugin().androidInfo;
      deviceModel = di.manufacturer;
    }else if (Platform.isIOS){
      final di = await DeviceInfoPlugin().iosInfo;
      deviceModel = di.model;
    }
    return TelegramService(
        appVersion: "${packageInfo.installerStore} - ${packageInfo.version}",
        applicationId: tgAppId,
        apiHash: tgHash,
        systemVersion: "${Platform.operatingSystem} - ${Platform.operatingSystemVersion}",
        deviceModel: deviceModel);
  }

  TelegramService(
      {this.systemLanguage,
      this.systemVersion,
      this.deviceModel,
      required this.appVersion,
      required this.applicationId,
      required this.apiHash}) {
    _eventController = StreamController();
    _eventController.stream.listen(_onEvent);
    initClient();
  }

  /// Creates a new instance of TDLib.
  /// Returns Pointer to the created instance of TDLib.
  /// Pointer 0 mean No client instance.
  void initClient() async {
    final tdlibPath =
        (Platform.isAndroid || Platform.isLinux || Platform.isWindows)
            ? 'libtdjson.so'
            : null;
    await TdPlugin.initialize(tdlibPath);
    _client = tdCreate();

    // ignore: unused_local_variable

    appDocDir = await getApplicationDocumentsDirectory();
    appExtDir = await getTemporaryDirectory();

    //execute(SetLogStream(logStream: LogStreamEmpty()));
    execute(const SetLogVerbosityLevel(newVerbosityLevel: 1));
    tdSend(_client, const GetCurrentState());
    _isolate = await Isolate.spawn(_receive, _receivePort.sendPort,
        debugName: "isolated receive");
    _receivePort.listen(_receiver);
  }

  static _receive(sendPortToMain) async {
    TdNativePlugin.registerWith();
    await TdPlugin.initialize();
    //var x = _rawClient.td_json_client_create();
    while (true) {
      final s = TdPlugin.instance.tdReceive();
      if (s != null) {
        sendPortToMain.send(s);
      }
    }
  }

  void _receiver(dynamic newEvent) async {
    final event = convertToObject(newEvent);
    if (event == null) {
      return;
    }
    if (event is Updates) {
      for (var event in event.updates) {
        _eventController.add(event);
      }
    } else {
      _eventController.add(event);
    }
    await _resolveEvent(event);
  }

  Future _resolveEvent(event) async {
    if (event.extra == null) {
      return;
    }
    final int extraId = event.extra;
    if (results.containsKey(extraId)) {
      results.remove(extraId).complete(event);
    } else if (callbackResults.containsKey(extraId)) {
      await callbackResults.remove(extraId);
    }
  }

  void stop() {
    _eventController.close();
    _eventReceiver.cancel();
    _receivePort.close();
    _isolate.kill(priority: Isolate.immediate);
  }

  void _onEvent(TdObject event) async {
    /*try {
      print('res =>>>> ${event.toJson()}');
    } catch (NoSuchMethodError) {
      print('res =>>>> ${event.getConstructor()}');
    }*/
    switch (event.getConstructor()) {
      case UpdateAuthorizationState.CONSTRUCTOR:
        await _authorizationController(
          (event as UpdateAuthorizationState).authorizationState,
          isOffline: true,
        );
        break;
      default:
        return;
    }
  }

  Future _authorizationController(
    AuthorizationState authState, {
    bool isOffline = false,
  }) async {
    switch (authState.getConstructor()) {
      case AuthorizationStateWaitTdlibParameters.CONSTRUCTOR:
        await send(
          SetTdlibParameters(
              useTestDc: false,
              useSecretChats: false,
              useMessageDatabase: true,
              useFileDatabase: true,
              useChatInfoDatabase: false,
              ignoreFileNames: false,
              enableStorageOptimizer: true,
              systemLanguageCode: systemLanguage ?? 'EN',
              filesDirectory: '${appExtDir.path}/tdlib',
              databaseDirectory: appDocDir.path,
              applicationVersion: appVersion,
              deviceModel: deviceModel ?? "UNKNOWN",
              systemVersion: systemVersion ?? "UNKNOWN",
              apiId: applicationId,
              apiHash: apiHash,
              databaseEncryptionKey: 'mostrandomencryption'),
        );
        return;
      case AuthorizationStateWaitPhoneNumber.CONSTRUCTOR:
      case AuthorizationStateClosed.CONSTRUCTOR:
        // route = loginRoute;
        debugPrint("Show login");
        navigatorBloc.add(const BaseNavigatorEventShowLogin());
        return;
      case AuthorizationStateReady.CONSTRUCTOR:
        // route = homeRoute;
        debugPrint("SHOW Timeline");
        return;
      case AuthorizationStateWaitCode.CONSTRUCTOR:
        // route = otpRoute;
        debugPrint("SHOW OTP ");
        return;
      case AuthorizationStateWaitOtherDeviceConfirmation.CONSTRUCTOR:
      case AuthorizationStateWaitRegistration.CONSTRUCTOR:
      case AuthorizationStateWaitPassword.CONSTRUCTOR:
        debugPrint("password needed ..");
        return;
      case AuthorizationStateLoggingOut.CONSTRUCTOR:
      case AuthorizationStateClosing.CONSTRUCTOR:
        return;
      default:
        return;
    }
  }

  void destroyClient() async {
    tdSend(_client, const Close());
  }


  /// Sends request to the TDLib client. May be called from any thread.
  // ignore: body_might_complete_normally_nullable
  Future<TdObject?> send(event,
      {Future<void>? callback, Function(TdError)? errorCallback}) async {
    // ignore: missing_return
    final rndId = _random();
    if (callback != null) {
      callbackResults[rndId] = callback;
      try {
        tdSend(_client, event, rndId);
      } on TdError catch (tde) {
        if (errorCallback != null) {
          errorCallback(tde);
        }
      } catch (e) {
        debugPrint("Error sending to telegram $e");
      }
    } else {
      final completer = Completer<TdObject>();
      results[rndId] = completer;
      tdSend(_client, event, rndId);
      return completer.future;
    }
  }

  /// Synchronously executes TDLib request. May be called from any thread.
  /// Only a few requests can be executed synchronously.
  /// Returned pointer will be deallocated by TDLib during next call to clientReceive or clientExecute in the same thread, so it can't be used after that.
  TdObject execute(TdFunction event) => tdExecute(event)!;

  Future setAuthenticationPhoneNumber(
    String phoneNumber, {
    required void Function(TdError) onError,
  }) async {
    final result = await send(
      SetAuthenticationPhoneNumber(
        phoneNumber: phoneNumber,
        settings: const PhoneNumberAuthenticationSettings(
          allowFlashCall: false,
          isCurrentPhoneNumber: false,
          allowSmsRetrieverApi: false,
          allowMissedCall: true,
          authenticationTokens: [],
        ),
      ),
    );
    if (result != null && result is TdError) {
      onError(result);
    }
  }

  Future checkAuthenticationCode(
    String code, {
    required void Function(TdError) onError,
  }) async {
    final result = await send(
      CheckAuthenticationCode(
        code: code,
      ),
    );
    if (result != null && result is TdError) {
      onError(result);
    }
  }
}
