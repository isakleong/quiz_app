import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/takingordervendor/chipsitem.dart';
import 'package:sfa_tools/widgets/customelevatedbutton.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../../common/app_config.dart';
import '../../controllers/taking_order_vendor_controller.dart';

class CartHeader extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  CartHeader({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
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
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextView(
                  text: "Keranjang",
                  headings: 'H3',
                  fontSize: 16,
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    ChipsItem(
                      satuan:
                          "${_takingOrderVendorController.cartDetailList.length} produk",
                      fontSize: 12,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ChipsItem(
                      satuan:
                          "Total : ${_takingOrderVendorController.formatNumber(_takingOrderVendorController.countPriceTotal())}",
                      color: Color(0xFF8B4513),
                      fontSize: 12,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
        Padding(
            padding: EdgeInsets.only(right: 0.05 * width),
            child: CustomElevatedButton(
                text: "LANJUTKAN   >>",
                onTap: () {
                  _takingOrderVendorController.previewCheckOut();
                },
                width: 0.25 * width,
                height: 0.045 * height,
                radius: 20,
                backgroundColor: AppConfig.mainCyan,
                textcolor: Colors.white,
                elevation: 5,
                bordercolor: AppConfig.mainCyan,
                headings: 'H2'))
      ],
    );
  }
}
