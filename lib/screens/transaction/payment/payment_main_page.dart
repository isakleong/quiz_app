import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/screens/transaction/payment/paymenttab.dart';
import 'package:sfa_tools/screens/transaction/payment/piutangcard.dart';
import 'package:sfa_tools/widgets/backbuttonaction.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../reporting/searchreport.dart';

class PaymentMainPage extends StatelessWidget {
  const PaymentMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Stack(
          children: [
            SvgPicture.asset(
              'assets/images/bg-homepage.svg',
              fit: BoxFit.cover,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 20, top: 10),
                    child: BackButtonAction()),
                Padding(
                    padding: EdgeInsets.only(
                        left: 0.05 * Get.width, top: 0.02 * Get.height),
                    child: PiutangCard()),
                PaymentTab(),
                Container(
                  width: Get.width,
                  height: 10,
                  color: Colors.grey.shade200,
                ),
              ],
            )
          ],
        )));
  }
}
