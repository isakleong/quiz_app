import 'package:get/get.dart';
import 'package:quiz_app/controllers/history_controller.dart';

class HistoryPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HistoryController>( HistoryController());
  }

}