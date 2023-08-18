import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/taking_order_vendor/reporting/reportheader.dart';

import '../../../controllers/taking_order_vendor_controller.dart';
import 'itemreportpembayaran.dart';

class ReportPembayaran extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  ReportPembayaran({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int index = 0;
            index <
                _takingOrderVendorController
                    .listReportPembayaranshow.value.length;
            index++)
          index == 0 &&
                  index !=
                      _takingOrderVendorController
                              .listReportPembayaranshow.value.length -
                          1
              ? Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            left: 0.05 * Get.width,
                            top: 15,
                            right: 0.05 * Get.width),
                        child: ReportHeader(
                          img: 'assets/images/custpayment.png',
                          title: "Pembayaran",
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    ItemReportPembayaran(
                      idx: (index + 1).toString(),
                      data: _takingOrderVendorController
                          .listReportPembayaranshow.value[index],
                      total:
                          "Rp ${_takingOrderVendorController.formatNumber(_takingOrderVendorController.listReportPembayaranshow.value[index].total.toInt())}",
                    ),
                  ],
                )
              : index == 0 &&
                      index ==
                          _takingOrderVendorController
                                  .listReportPembayaranshow.value.length -
                              1
                  ? Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                                left: 0.05 * Get.width,
                                top: 15,
                                right: 0.05 * Get.width),
                            child: ReportHeader(
                              img: 'assets/images/custpayment.png',
                              title: "Pembayaran",
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        ItemReportPembayaran(
                          idx: (index + 1).toString(),
                          data: _takingOrderVendorController
                              .listReportPembayaranshow.value[index],
                          total:
                              "Rp ${_takingOrderVendorController.formatNumber(_takingOrderVendorController.listReportPembayaranshow.value[index].total.toInt())}",
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
                                      .listReportPembayaranshow.value.length -
                                  1
                      ? Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 0.05 * Get.width,
                                  top: 15,
                                  right: 0.05 * Get.width),
                              child: ItemReportPembayaran(
                                idx: (index + 1).toString(),
                                data: _takingOrderVendorController
                                    .listReportPembayaranshow.value[index],
                                total:
                                    "Rp ${_takingOrderVendorController.formatNumber(_takingOrderVendorController.listReportPembayaranshow.value[index].total.toInt())}",
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
                          child: ItemReportPembayaran(
                            idx: (index + 1).toString(),
                            data: _takingOrderVendorController
                                .listReportPembayaranshow.value[index],
                            total:
                                "Rp ${_takingOrderVendorController.formatNumber(_takingOrderVendorController.listReportPembayaranshow.value[index].total.toInt())}",
                          ),
                        ),
      ],
    );
  }
}
