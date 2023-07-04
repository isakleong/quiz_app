import 'package:get/get.dart';
import 'package:sfa_tools/controllers/history_controller.dart';

class HistoryPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HistoryController>( HistoryController());
  }

}