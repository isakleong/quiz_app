import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../../common/app_config.dart';
import '../../../controllers/taking_order_vendor_controller.dart';
import '../../../widgets/textview.dart';

class SearchReport extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  SearchReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: Container(
        width: 0.9 * Get.width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                        color: Color(0XFF008996),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 18.0),
                      child: Image.asset(
                        'assets/images/custreport.png',
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView(headings: "H2", text: "Laporan", fontSize: 14),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppConfig.mainCyan,
                              ),
                            ),
                            Icon(
                              Icons.home,
                              color: Colors.white,
                              size: 15,
                            )
                          ],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Adek Abang"),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.only(left: 0.02 * Get.width),
            child: Container(
              width: 0.86 * Get.width,
              height: 2,
              color: Colors.grey.shade300,
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  left: 0.05 * Get.width,
                  right: 0.05 * Get.width,
                  top: 0.01 * Get.height,
                  bottom: 0.01 * Get.height),
              child: Obx(
                () => Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border:
                          Border.all(width: 1, color: Colors.grey.shade500)),
                  child: Padding(
                    padding: EdgeInsets.only(left: 5, right: 10),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _takingOrderVendorController
                                    .choosedReport.value ==
                                ""
                            ? 'Semua Transaksi'
                            : _takingOrderVendorController.choosedReport.value,
                        onChanged: (String? newValue) {
                          _takingOrderVendorController.choosedReport.value =
                              newValue!;
                        },
                        items: <String>[
                          'Semua Transaksi',
                          'Transaksi Penjualan',
                          'Transaksi Pembayaran',
                          // 'Transaksi Retur',
                          // 'Transaksi TTH',
                          // 'Transaksi Survey',
                          // 'Transaksi Keluhan'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.filter_alt_rounded,
                                  size: 18,
                                  color: Colors.grey.shade500,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                TextView(
                                  text: value,
                                  textAlign: TextAlign.left,
                                  fontSize: 13,
                                  headings: 'H4',
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ))
        ]),
      ),
    );
  }
}
