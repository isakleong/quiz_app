import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/controllers/taking_order_vendor_controller.dart';
import 'package:sfa_tools/models/paymentdata.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/chipsitem.dart';

import '../../../widgets/textview.dart';

class ItemListPembayaran extends StatelessWidget {
  String idx;
  PaymentData data;
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  ItemListPembayaran({super.key, required this.idx, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 0.05 * Get.width),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 0.04 * Get.height,
            decoration: const BoxDecoration(color: Color(0xFF4fc2f8)),
          ),
          SizedBox(
            width: 0.7 * Get.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 7, bottom: 7),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 0.025 * Get.width,
                            ),
                            Container(
                              width: 0.07 * Get.width,
                              height: 0.04 * Get.height,
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: TextView(
                                  text: idx,
                                  headings: 'H3',
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 0.025 * Get.width,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextView(
                                  headings: 'H4',
                                  fontSize: 13,
                                  text: data.jenis == "cn"
                                      ? "Potongan CN"
                                      : data.jenis == "cek"
                                          ? "Cek / Giro / Slip - ${data.tipe} [${data.nomor}]"
                                          : "${data.jenis} - ${data.tipe}",
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextView(
                                      text:
                                          "Rp ${_takingOrderVendorController.formatNumber(data.value.toInt())}",
                                      fontSize: 13,
                                    ),
                                    SizedBox(
                                      width: 0.01 * Get.width,
                                    ),
                                    data.jatuhtempo == ""
                                        ? Container()
                                        : ChipsItem(
                                            satuan:
                                                "Jatuh Tempo : ${data.jatuhtempo}",
                                            fontSize: 12,
                                          )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
