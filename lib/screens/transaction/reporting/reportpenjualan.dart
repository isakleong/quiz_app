import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/controllers/taking_order_vendor_controller.dart';
import 'package:sfa_tools/screens/transaction/reporting/itemreportpenjualan.dart';

import '../../../widgets/textview.dart';

class ReportPenjualan extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  ReportPenjualan({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(
        () => ListView.builder(
          itemCount: _takingOrderVendorController.listReport.length,
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
                          data: _takingOrderVendorController.listReport[index],
                        )
                      ],
                    ),
                  )
                : index == _takingOrderVendorController.listReport.length - 1
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
                                  .listReport[index],
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
                          data: _takingOrderVendorController.listReport[index],
                        ));
          },
          physics: BouncingScrollPhysics(),
        ),
      ),
    );
  }
}
