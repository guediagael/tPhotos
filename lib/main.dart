import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tphotos/data/data_manager_impl.dart';
import 'package:tphotos/dispatchers/main_dispatcher.dart';
import 'package:tphotos/services/media_sync_service.dart';
import 'package:tphotos/services/telegram.dart';
import 'package:tphotos/ui/screens/welcome_placeholder.dart';

import 'color_schemes.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tPhotos',
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: FutureBuilder(
        future: appInitSettings(),
        builder: (ctx, AsyncSnapshot<Map<String, dynamic>> screenSettings) {
          if (screenSettings.hasData) {
            // final datas = screenSettings.data!;
            // return WelcomeDispatcher.buildWelcomeScreen(
            //     apiHash: datas['tgApiHash'],
            //     appVersion: datas['appVersion'],
            //     applicationId: datas['tgAppId']);
            return MainScreenDispatcher.buildMainScreen();
          } else {
            return const PlaceHolderWelcomeScreen();
          }
        },
      ),
    );
  }

  static Future<Map<String, dynamic>> appInitSettings() async {
    WidgetsFlutterBinding.ensureInitialized();
    final packageInfo = await PackageInfo.fromPlatform();
    final appVersion = packageInfo.version;

    final keysFile = await rootBundle.loadString('secrets/keys.json');
    final keys = await json.decode(keysFile);
    final tgHash = keys['telegram_api_hash'];
    final tgAppId = keys['telegram_app_id'];

    await DataManagerImpl.init(TelegramService(
        appVersion: appVersion, applicationId: tgAppId, apiHash: tgHash));
    return {"tgApiHash": tgHash, "tgAppId": tgAppId, "appVersion": appVersion};
  }
}
