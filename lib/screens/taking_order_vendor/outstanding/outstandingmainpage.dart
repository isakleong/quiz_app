import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/taking_order_vendor/outstanding/outstandingcustcard.dart';
import 'package:sfa_tools/screens/taking_order_vendor/outstanding/outstandinglist.dart';
import 'package:sfa_tools/widgets/closeoverlayaction.dart';
import 'package:shimmer/shimmer.dart';
import '../../../common/app_config.dart';
import '../../../controllers/taking_order_vendor_controller.dart';
import '../../../widgets/backbuttonaction.dart';
import '../../../widgets/textview.dart';

class OutStandingMainPage extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  OutStandingMainPage({super.key});

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
                Padding(
                    padding: EdgeInsets.only(
                      left: 0.05 * width,
                      top: 0.05 * height,
                    ),
                    child: Obx(()=> OutstandingCustCard(
                        nmtoko: _takingOrderVendorController.nmtoko.value,
                        isfailed: _takingOrderVendorController.isLoadingOutstanding.value,
                        ontap: () {
                          _takingOrderVendorController
                              .overlayactivepenjualan.value = "penjualan";
                        },ontaprefresh: () async {
                        await _takingOrderVendorController.getListDataOutStanding();
                      },))) ,
                SizedBox(
                  height: 20,
                ),
                Obx(
                  () => _takingOrderVendorController.isLoadingOutstanding.value
                      ? Padding(
                          padding: EdgeInsets.only(left: 0.05 * width),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade400,
                            highlightColor: Colors.grey.shade200,
                            child: Container(
                              width: 0.9 * width,
                              height: 0.15 * height,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                          itemBuilder: (c, i) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: 0.045 * width, right: 0.042 * width),
                              child: OutstandingList(
                                  data: _takingOrderVendorController
                                      .listDataOutstanding[i]),
                            );
                          },
                          itemCount: _takingOrderVendorController
                              .listDataOutstanding.length,
                          physics: const BouncingScrollPhysics(),
                        )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
