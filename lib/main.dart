import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tphotos/data/data_manager_impl.dart';
import 'package:tphotos/dispatchers/main_dispatcher.dart';
import 'package:tphotos/dispatchers/welcome_dispatcher.dart';
import 'package:tphotos/services/telegram.dart';
import 'package:tphotos/ui/screens/welcome_placeholder.dart';

void main() {
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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: welcomeScreenSettings(),
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

  Future<Map<String, dynamic>> welcomeScreenSettings() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final appVersion = packageInfo.version;

    final keysFile = await rootBundle.loadString('secrets/keys.json');
    final keys = await json.decode(keysFile);
    final tgHash = keys['telegram_api_hash'];
    final tgAppId = keys['telegram_app_id'];

    DataManagerImpl.init(TelegramService(
        appVersion: appVersion, applicationId: tgAppId, apiHash: tgHash));
    return {"tgApiHash": tgHash, "tgAppId": tgAppId, "appVersion": appVersion};
  }
}
