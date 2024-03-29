import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/chipsitem.dart';
import 'package:sfa_tools/widgets/customelevatedbutton.dart';
import 'package:sfa_tools/widgets/textview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/app_config.dart';
import '../../../controllers/taking_order_vendor_controller.dart';

class PaymentHeader extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  PaymentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 0.05 * Get.width,
                ),
                Image.asset('assets/images/paymentlist.png',
                    width: 0.07 * Get.width, fit: BoxFit.cover),
                SizedBox(
                  width: 0.02 * Get.width,
                ),
                TextView(
                  text: "Daftar Pembayaran",
                  headings: 'H3',
                  fontSize: 12.sp,
                ),
                SizedBox(
                  width: 0.02 * Get.width,
                ),
                Obx(() => ChipsItem(
                      satuan:
                          "${_takingOrderVendorController.listpaymentdata.length} Metode",
                      fontSize: 10.sp,
                    ))
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 0.05 * Get.width),
              child: CustomElevatedButton(
                  icon: Icon(
                    Icons.check_circle_outline_rounded,
                    size: 14.sp,
                  ),
                  text: "SIMPAN",
                  onTap: () {
                    _takingOrderVendorController.handleSaveConfirm(
                        "Yakin untuk simpan pembayaran?",
                        "Konfirmasi Pembayaran");
                  },
                  radius: 10,
                  space: 5,
                  fonts: 10.sp,
                  backgroundColor: AppConfig.mainCyan,
                  textcolor: Colors.white,
                  elevation: 2,
                  bordercolor: AppConfig.mainCyan,
                  headings: 'H2'),
            )
          ],
        ),
      ],
    );
  }
}
