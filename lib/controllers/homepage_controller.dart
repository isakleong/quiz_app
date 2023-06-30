import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/models/config_box.dart';

class HomepageController extends GetxController {
  var isLoading = true.obs;
  var isError = false.obs;
  var errorMessage = "".obs;
  var configData = "".obs;

  final txtServerIPController = TextEditingController();

  @override
  void onInit() async {
    super.onInit();
    var configBox = await Hive.openBox<ConfigBox>('configBox');
    try {
      txtServerIPController.text = configBox.get("configBox")!.value.toString();
    } catch (e) {
      txtServerIPController.text = AppConfig.publicUrl;
    }
  }

  @override
  void onClose() {
    super.onClose();
    txtServerIPController.dispose();
  }
}