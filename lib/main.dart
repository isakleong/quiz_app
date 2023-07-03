import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quiz_app/common/app_route.dart';
import 'package:quiz_app/controllers/background_service_controller.dart';
import 'package:quiz_app/tools/service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  HttpOverrides.global = ApiHttpOverrides();

  await Backgroundservicecontroller().initializeService();
  await Backgroundservicecontroller().hiveInitializer();

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
        fontFamily: "Poppins",
      ),
      initialRoute: "/",
      getPages: AppRoute.pages,
    );
  }
}
