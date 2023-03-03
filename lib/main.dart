import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:quiz_app/bindings/splashscreen_binding.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/common/app_route.dart';
import 'package:quiz_app/models/quiz.dart';
import 'package:quiz_app/screens/splashscreen.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // SystemChrome.setSystemUIChangeCallback((systemOverlaysAreVisible) async {
  //   await Future.delayed(const Duration(seconds: 1));
  //   // SystemChrome.restoreSystemUIOverlays();
  // });
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(QuizAdapter());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // canvasColor: AppConfig.lightGreenColor
      ),
      // home: SplashScreen(),
      // initialBinding: SplashScreenBinding(),
      initialRoute: "/",
      getPages: AppRoute.pages,
    );
  }
}
