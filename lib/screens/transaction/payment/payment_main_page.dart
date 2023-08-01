import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/transaction/payment/paymenttab.dart';
import 'package:sfa_tools/screens/transaction/payment/piutangcard.dart';
import 'package:sfa_tools/widgets/backbuttonaction.dart';

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
                const Padding(
                    padding: EdgeInsets.only(left: 20, top: 10),
                    child: BackButtonAction()),
                Padding(
                    padding: EdgeInsets.only(
                        left: 0.05 * Get.width, top: 0.02 * Get.height),
                    child: const PiutangCard()),
                const SizedBox(
                  height: 20,
                ),
                const PaymentTab(),
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
