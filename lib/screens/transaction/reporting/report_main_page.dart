import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/controllers/taking_order_vendor_controller.dart';
import 'package:sfa_tools/screens/transaction/reporting/itemlistpenjualan.dart';
import 'package:sfa_tools/screens/transaction/reporting/itemreportpenjulan.dart';
import 'package:sfa_tools/screens/transaction/reporting/searchreport.dart';
import 'package:sfa_tools/screens/transaction/takingordervendor/checkoutlist.dart';
import 'package:sfa_tools/widgets/backbuttonaction.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../takingordervendor/cartlist.dart';
import '../takingordervendor/chipsitem.dart';

class ReportMainPage extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  ReportMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(children: [
          SvgPicture.asset(
            'assets/images/bg-homepage.svg',
            fit: BoxFit.cover,
          ),
          Obx(() => _takingOrderVendorController.cartDetailList.isEmpty
              ? Center(
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/lottie/notfound.json',
                        width: Get.width * 0.35),
                    TextView(
                      text: "Tidak Ada Laporan",
                      headings: 'H4',
                      fontSize: 20,
                    )
                  ],
                ))
              : Container()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: BackButtonAction()),
              Padding(
                  padding: EdgeInsets.only(
                      left: 0.05 * Get.width, top: 0.02 * Get.height),
                  child: SearchReport()),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount:
                        _takingOrderVendorController.cartDetailList.length,
                    itemBuilder: (context, index) {
                      return index == 0
                          ? Padding(
                              padding: EdgeInsets.only(
                                  left: 0.05 * Get.width,
                                  top: 5,
                                  right: 0.05 * Get.width),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 15, top: 15),
                                    child: Row(
                                      children: [
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppConfig.mainCyan,
                                              ),
                                            ),
                                            Image.asset(
                                              'assets/images/custorder.png',
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        TextView(
                                            headings: "H4",
                                            text: "Penjualan",
                                            fontSize: 20)
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  ItemReportPenjualan(
                                    idx: (index + 1).toString(),
                                    data: _takingOrderVendorController
                                        .cartDetailList[index],
                                  )
                                ],
                              ),
                            )
                          : index ==
                                  _takingOrderVendorController
                                          .cartDetailList.length -
                                      1
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 0.05 * Get.width,
                                          top: 5,
                                          right: 0.05 * Get.width),
                                      child: ItemReportPenjualan(
                                        idx: (index + 1).toString(),
                                        data: _takingOrderVendorController
                                            .cartDetailList[index],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0.04 * Get.height,
                                    ),
                                    Container(
                                      width: Get.width,
                                      color: Colors.grey.shade300,
                                      height: 10,
                                    )
                                  ],
                                )
                              : Padding(
                                  padding: EdgeInsets.only(
                                      left: 0.05 * Get.width,
                                      top: 5,
                                      right: 0.05 * Get.width),
                                  child: ItemReportPenjualan(
                                    idx: (index + 1).toString(),
                                    data: _takingOrderVendorController
                                        .cartDetailList[index],
                                  ));
                    },
                    physics: BouncingScrollPhysics(),
                  ),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
