import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/taking_order_vendor/reporting/reportheader.dart';
import 'package:sfa_tools/tools/utils.dart';
import '../../../controllers/taking_order_vendor_controller.dart';
import 'itemreportpembayaran.dart';

class ReportPembayaran extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  ReportPembayaran({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Obx(() => Column(
          children: [
            for (int index = 0;index <_takingOrderVendorController.listReportPembayaranshow.length;index++)
              index == 0 && index != _takingOrderVendorController.listReportPembayaranshow.length - 1
                  ? Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                                left: 0.05 * width,
                                top: 15,
                                right: 0.05 * width),
                            child: ReportHeader(
                              img: 'assets/images/custpayment.png',
                              title: "Pembayaran",
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        ItemReportPembayaran(
                          idx: (index + 1).toString(),
                          custid: _takingOrderVendorController.custcode.value,
                          data: _takingOrderVendorController
                              .listReportPembayaranshow[index],
                          total:
                              "Rp ${Utils().formatNumber(_takingOrderVendorController.listReportPembayaranshow[index].total.toInt())}",
                        ),
                      ],
                    )
                  : index == 0 &&
                          index ==
                              _takingOrderVendorController
                                      .listReportPembayaranshow.length -
                                  1
                      ? Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 0.05 * width,
                                    top: 15,
                                    right: 0.05 * width),
                                child: ReportHeader(
                                  img: 'assets/images/custpayment.png',
                                  title: "Pembayaran",
                                )),
                            const SizedBox(
                              height: 5,
                            ),
                            ItemReportPembayaran(
                              idx: (index + 1).toString(),
                              custid:
                                  _takingOrderVendorController.custcode.value,
                              data: _takingOrderVendorController
                                  .listReportPembayaranshow[index],
                              total:
                                  "Rp ${Utils().formatNumber(_takingOrderVendorController.listReportPembayaranshow[index].total.toInt())}",
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
                      : index != 0 && index == _takingOrderVendorController.listReportPembayaranshow.length - 1
                          ? Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 0.05 * width,
                                      top: 15,
                                      right: 0.05 * width),
                                  child: ItemReportPembayaran(
                                    idx: (index + 1).toString(),
                                    custid: _takingOrderVendorController
                                        .custcode.value,
                                    data: _takingOrderVendorController
                                        .listReportPembayaranshow[index],
                                    total: "Rp ${Utils().formatNumber(_takingOrderVendorController.listReportPembayaranshow[index].total.toInt())}",
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
                              child: ItemReportPembayaran(
                                idx: (index + 1).toString(),
                                custid: _takingOrderVendorController.custcode.value,
                                data: _takingOrderVendorController .listReportPembayaranshow[index],
                                total: "Rp ${Utils().formatNumber(_takingOrderVendorController.listReportPembayaranshow[index].total.toInt())}",
                              ),
                            ),
          ],
        ));
  }
}
