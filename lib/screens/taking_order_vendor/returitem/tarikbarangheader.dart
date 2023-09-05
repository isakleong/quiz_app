import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/chipsitem.dart';
import 'package:sfa_tools/widgets/textview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/app_config.dart';
import '../../../widgets/customelevatedbutton.dart';

class TarikBarangHeader extends StatelessWidget {
  String jumlahproduk;
  var onTap;
  TarikBarangHeader(
      {super.key, required this.jumlahproduk, required this.onTap});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                Container(
                  width: 32.sp,
                  height: 32.sp,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF48d4d1),
                        Color(0xFF378a8a),
                      ],
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/cart.png',
                        width: 17.sp,
                        height: 17.sp,
                        color: Colors.white,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 0.02 * Get.width,
                ),
                TextView(
                  text: "Keranjang",
                  headings: 'H3',
                  fontSize: 12.sp,
                ),
                SizedBox(
                  width: 0.02 * Get.width,
                ),
               ChipsItem(
                      satuan: jumlahproduk,
                      fontSize: 8.sp,
                    ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 0.05 * width),
              child: CustomElevatedButton(
                  text: "LANJUTKAN  >>",
                  onTap: onTap,
                  width: 0.25 * width,
                  height: 0.045 * height,
                  radius: 15,
                  backgroundColor: AppConfig.mainCyan,
                  textcolor: Colors.white,
                  elevation: 5,
                  fonts: 10.sp,
                  bordercolor: AppConfig.mainCyan,
                  headings: 'H2')
            )
          ],
        ),
      ],
    );
  }
}
