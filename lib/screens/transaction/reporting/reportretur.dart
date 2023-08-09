import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/transaction/reporting/reportheader.dart';

import '../../../controllers/taking_order_vendor_controller.dart';
import 'itemreportretur.dart';

class ReportRetur extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  ReportRetur({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _takingOrderVendorController.choosedReport.value == "" ||
                _takingOrderVendorController.choosedReport.value ==
                    "Semua Transaksi" ||
                _takingOrderVendorController.choosedReport.value ==
                    "Transaksi Retur"
            ? Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          left: 0.05 * Get.width,
                          top: 15,
                          right: 0.05 * Get.width),
                      child: ReportHeader(
                        img: "assets/images/custretur.png",
                        title: "Retur",
                      )),
                  const SizedBox(
                    height: 5,
                  ),
                  const ItemReportRetur(),
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
            : Container()
      ],
    );
  }
}
