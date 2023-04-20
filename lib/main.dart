import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:quiz_app/common/app_route.dart';
import 'package:quiz_app/models/module.dart';
import 'package:quiz_app/models/quiz.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:quiz_app/tools/service.dart';


_write(String text) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('/storage/emulated/0/Download/my_file.txt');
  await file.writeAsString(text);
}

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
