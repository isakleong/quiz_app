import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/transaction/reporting/itemreportpenjualan.dart';
import 'package:sfa_tools/screens/transaction/reporting/reportheader.dart';

import '../../../controllers/taking_order_vendor_controller.dart';

class ReportPenjualan extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  ReportPenjualan({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int index = 0;
            index <
                _takingOrderVendorController
                    .listReportPenjualanShow.value.length;
            index++)
          index == 0 &&
                  index !=
                      _takingOrderVendorController
                              .listReportPenjualanShow.value.length -
                          1
              ? Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            left: 0.05 * Get.width,
                            top: 15,
                            right: 0.05 * Get.width),
                        child: ReportHeader(
                          img: 'assets/images/custorder.png',
                          title: "Penjualan",
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    ItemReportPenjualan(
                      idx: (index + 1).toString(),
                      data: _takingOrderVendorController
                          .listReportPenjualanShow.value[index],
                    )
                  ],
                )
              : index == 0 &&
                      index ==
                          _takingOrderVendorController
                                  .listReportPenjualanShow.value.length -
                              1
                  ? Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                                left: 0.05 * Get.width,
                                top: 15,
                                right: 0.05 * Get.width),
                            child: ReportHeader(
                              img: 'assets/images/custorder.png',
                              title: "Penjualan",
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        ItemReportPenjualan(
                          idx: (index + 1).toString(),
                          data: _takingOrderVendorController
                              .listReportPenjualanShow.value[index],
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
                  : index != 0 &&
                          index ==
                              _takingOrderVendorController
                                      .listReportPenjualanShow.value.length -
                                  1
                      ? Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 0.05 * Get.width,
                                  top: 15,
                                  right: 0.05 * Get.width),
                              child: ItemReportPenjualan(
                                idx: (index + 1).toString(),
                                data: _takingOrderVendorController
                                    .listReportPenjualanShow.value[index],
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
                              top: 15,
                              right: 0.05 * Get.width),
                          child: ItemReportPenjualan(
                            idx: (index + 1).toString(),
                            data: _takingOrderVendorController
                                .listReportPenjualanShow.value[index],
                          )),
      ],
    );
  }
}
