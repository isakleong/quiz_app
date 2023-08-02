import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/transaction/returitem/returcard.dart';
import 'package:sfa_tools/screens/transaction/returitem/segmentbutton.dart';

import '../../../widgets/backbuttonaction.dart';

class ReturMainPage extends StatelessWidget {
  const ReturMainPage({super.key});

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
                    child: const ReturCard()),
                Padding(
                    padding: EdgeInsets.only(
                        left: 0.05 * Get.width, top: 0.02 * Get.height),
                    child: SegmentButton())
              ],
            )
          ],
        )));
  }
}
