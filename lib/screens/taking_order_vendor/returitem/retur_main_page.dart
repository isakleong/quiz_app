import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/taking_order_vendor/returitem/returcard.dart';
import 'package:sfa_tools/screens/taking_order_vendor/returitem/tarikbarangpage.dart';
import '../../../controllers/taking_order_vendor_controller.dart';
import '../../../widgets/backbuttonaction.dart';
/* for other retur
import 'package:sfa_tools/screens/taking_order_vendor/returitem/tukarwarnapage.dart';
import 'package:sfa_tools/screens/taking_order_vendor/returitem/segmentbutton.dart';
import 'package:sfa_tools/screens/taking_order_vendor/returitem/servismebel.dart';
import 'package:sfa_tools/screens/taking_order_vendor/returitem/gantibarang.dart';
import 'package:sfa_tools/screens/taking_order_vendor/returitem/gantikemasan.dart';
*/


class ReturMainPage extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  ReturMainPage({super.key});
  List pages = [
    // TukarWarnaPage(),
    TarikBarangPage(),
    // GantiKemasan(),
    // ServisMebel(),
    // GantiBarang(),
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                        left: 0.05 * width, top: 0.01 * height),
                    child:  ReturCard(nmToko: _takingOrderVendorController.nmtoko.value,)),
                // Padding(
                //     padding: EdgeInsets.only(
                //         left: 0.05 * width, top: 0.02 * height),
                //     child: SegmentButton()),
                Obx(() =>
                    pages[_takingOrderVendorController.indexSegment.value])
              ],
            )
          ],
        )));
  }
}
