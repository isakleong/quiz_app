import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:quiz_app/common/app_route.dart';
import 'package:quiz_app/controllers/background_service_controller.dart';
import 'package:quiz_app/models/module.dart';
import 'package:quiz_app/models/quiz.dart';
import 'package:quiz_app/models/servicebox.dart';
import 'package:quiz_app/tools/service.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  HttpOverrides.global = ApiHttpOverrides();
  //uncomment (for demo to dsd)
  // await Backgroundservicecontroller().initializeService();
  // await Backgroundservicecontroller().hiveInitializer();

  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(ModuleAdapter());
  Hive.registerAdapter(QuizAdapter());
  Hive.registerAdapter(ServiceBoxAdapter());

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
