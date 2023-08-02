import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/controllers/taking_order_vendor_controller.dart';
import 'package:sfa_tools/screens/transaction/reporting/itemreportpembayaran.dart';
import 'package:sfa_tools/screens/transaction/reporting/itemreportpenjualan.dart';

import '../../../widgets/textview.dart';

class ReportBody extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  ReportBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      physics: const BouncingScrollPhysics(),
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
                          const SizedBox(
                            width: 20,
                          ),
                          const TextView(
                              headings: "H4", text: "Penjualan", fontSize: 20)
                        ],
                      ),
                    ),
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
                              const SizedBox(
                                width: 20,
                              ),
                              const TextView(
                                  headings: "H4",
                                  text: "Penjualan",
                                  fontSize: 20)
                            ],
                          ),
                        ),
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
                                'assets/images/custpayment.png',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const TextView(
                              headings: "H4", text: "Pembayaran", fontSize: 20)
                        ],
                      ),
                    ),
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
                                    'assets/images/custpayment.png',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              const TextView(
                                  headings: "H4",
                                  text: "Pembayaran",
                                  fontSize: 20)
                            ],
                          ),
                        ),
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
                        )
      ],
    ));
  }
}
