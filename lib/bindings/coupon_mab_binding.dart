import 'package:get/get.dart';
import 'package:sfa_tools/controllers/coupon_mab_controller.dart';

class CouponMABBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<CouponMABController>( CouponMABController());
  }

}