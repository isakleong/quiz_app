import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/taking_order_vendor/reporting/itemreportpenjualan.dart';
import 'package:sfa_tools/screens/taking_order_vendor/reporting/reportheader.dart';

import '../../../controllers/taking_order_vendor_controller.dart';

class ReportPenjualan extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  ReportPenjualan({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Obx(() => Column(
          children: [
            for (int index = 0; index < _takingOrderVendorController.listReportPenjualanShow.length; index++)
              index == 0 && index != _takingOrderVendorController.listReportPenjualanShow.length - 1
                  ? Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                                left: 0.05 * width,
                                top: 15,
                                right: 0.05 * width),
                            child: ReportHeader(
                              img: 'assets/images/custorder.png',
                              title: "Penjualan",
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        ItemReportPenjualan(
                          idx: (index + 1).toString(),
                          custid: _takingOrderVendorController.custcode.value,
                          data: _takingOrderVendorController
                              .listReportPenjualanShow[index],
                        )
                      ],
                    )
                  : index == 0 && index == _takingOrderVendorController.listReportPenjualanShow.length - 1
                      ? Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 0.05 * width,
                                    top: 15,
                                    right: 0.05 * width),
                                child: ReportHeader(
                                  img: 'assets/images/custorder.png',
                                  title: "Penjualan",
                                )),
                            const SizedBox(
                              height: 5,
                            ),
                            ItemReportPenjualan(
                              idx: (index + 1).toString(),
                              custid: _takingOrderVendorController.custcode.value,
                              data: _takingOrderVendorController.listReportPenjualanShow[index],
                            ),
                            SizedBox(
                              height: 0.04 * height,
                            ),
                            Container(
                              width: width,
                              color: Colors.grey.shade300,
                              height: 10,
                            )
                          ],
                        )
                      : index != 0 && index == _takingOrderVendorController.listReportPenjualanShow.length - 1
                          ? Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 0.05 * width,
                                      top: 15,
                                      right: 0.05 * width),
                                  child: ItemReportPenjualan(
                                    idx: (index + 1).toString(),
                                    custid: _takingOrderVendorController.custcode.value,
                                    data: _takingOrderVendorController.listReportPenjualanShow[index],
                                  ),
                                ),
                                SizedBox(
                                  height: 0.04 * height,
                                ),
                                Container(
                                  width: width,
                                  color: Colors.grey.shade300,
                                  height: 10,
                                )
                              ],
                            )
                          : Padding(
                              padding: EdgeInsets.only(
                                  left: 0.05 * width,
                                  top: 15,
                                  right: 0.05 * width),
                              child: ItemReportPenjualan(
                                idx: (index + 1).toString(),
                                custid: _takingOrderVendorController.custcode.value,
                                data: _takingOrderVendorController.listReportPenjualanShow[index],
                              )),
          ],
        ));
  }
}
