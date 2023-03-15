import 'dart:convert';
import 'package:get/get.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/models/module.dart';
import 'package:quiz_app/tools/service.dart';

class ConfigController extends GetxController {
  var isLoading = true.obs;
  var isError = false.obs;
  var errorMessage = "".obs;
  var configData = "".obs;
  var moduleList = <Module>[].obs;

  @override
  void onInit() {
    super.onInit();
    getConfigData();
  }

  Future<String> getConfigData() async {
    isLoading(true);
    isError(false);
    try {
      final result = await ApiClient().getData("/config?app=quiz");
      var data = jsonDecode(result.toString());
      configData.value = data[0]["Value"].toString();

      await getModuleData();

      // isLoading(false);
      // isError(false);
      // Get.offAndToNamed(RouteName.homepage);
    } catch(e) {
      isLoading(false);
      isError(true);
      errorMessage(e.toString());
    }
    return configData.value;
  }

  getModuleData() async {
    try {
      final result = await ApiClient().getData("/module?sales_id=00AC1A0103");
      var data = jsonDecode(result.toString());
      data.map((item) {
        moduleList.add(Module.from(item));
      }).toList();

      isLoading(false);
      isError(false);
      Get.offAndToNamed(RouteName.homepage);
    } catch(e) {
      isLoading(false);
      isError(true);
      errorMessage(e.toString());
    }
  }

}