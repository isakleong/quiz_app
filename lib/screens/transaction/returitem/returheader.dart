import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../common/app_config.dart';
import '../../../controllers/taking_order_vendor_controller.dart';
import '../../../widgets/customelevatedbutton.dart';
import '../../../widgets/textview.dart';
import '../takingordervendor/chipsitem.dart';

class ReturHeader extends StatelessWidget {
  String jumlahproduk;
  var onTap;
  ReturHeader({super.key, required this.jumlahproduk, required this.onTap});

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
                  width: 45,
                  height: 45,
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
                        width: 25,
                        height: 25,
                        color: Colors.white,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 0.02 * Get.width,
                ),
                const TextView(
                  text: "Keranjang",
                  headings: 'H3',
                  fontSize: 18,
                ),
                SizedBox(
                  width: 0.02 * Get.width,
                ),
                ChipsItem(
                  satuan: "${jumlahproduk}",
                  fontSize: 14,
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 0.05 * Get.width),
              child: CustomElevatedButton(
                  icon: Icon(
                    FontAwesomeIcons.solidCheckCircle,
                    size: 20,
                  ),
                  text: "Simpan",
                  onTap: onTap,
                  width: 0.25 * width,
                  height: 0.045 * height,
                  radius: 15,
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
