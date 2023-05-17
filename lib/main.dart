import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quiz_app/common/app_route.dart';
import 'package:quiz_app/controllers/background_service_controller.dart';
import 'package:quiz_app/models/module.dart';
import 'package:quiz_app/models/quiz.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:quiz_app/tools/service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(ModuleAdapter());
  Hive.registerAdapter(QuizAdapter());

  HttpOverrides.global = ApiHttpOverrides();

  var mDeviceMediaQueryData = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  print("$mDeviceMediaQueryData hehe");
  await Backgroundservicecontroller().initializeService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Poppins"
      ),
      initialRoute: "/",
      getPages: AppRoute.pages,
    );
  }
}
