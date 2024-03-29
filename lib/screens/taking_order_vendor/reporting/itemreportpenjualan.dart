import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/models/reportpenjualanmodel.dart';
import 'package:sfa_tools/screens/taking_order_vendor/reporting/itemlistpenjualan.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/chipsitem.dart';

import '../../../widgets/textview.dart';

class ItemReportPenjualan extends StatelessWidget {
  String idx;
  ReportPenjualanModel data;
  ItemReportPenjualan({super.key, required this.idx, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.white,
        child: SizedBox(
          width: 0.9 * Get.width,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 0.02 * Get.width),
                      child: Container(
                        width: 0.07 * Get.width,
                        height: 0.07 * Get.width,
                        decoration: const BoxDecoration(
                          color: Color(0xFFf5511e),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: TextView(
                            text: idx,
                            color: Colors.white,
                            fontSize: 18,
                            headings: 'H2',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextView(
                          text: data.id,
                          headings: 'H4',
                          fontSize: 14,
                        ),
                        data.notes == ""
                            ? Container()
                            : ChipsItem(
                                satuan: data.notes.length >= 35
                                    ? "${data.notes.substring(0, 30)}...      "
                                    : data.notes,
                                color: const Color(0xFFf5511e),
                                fontSize: 12,
                              )
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextView(
                        text: data.tanggal,
                        fontSize: 14,
                      ),
                      TextView(
                        text: data.waktu,
                        fontSize: 14,
                      )
                    ],
                  ),
                )
              ],
            ),
            Center(
              child: Container(
                width: 0.85 * Get.width,
                color: Colors.grey.shade400,
                height: 3,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: data.listItem.length,
              itemBuilder: (context, inner) {
                return ItemListPenjualan(
                    idx: (inner + 1).toString(), data: data.listItem[inner]);
              },
            ),
            const SizedBox(
              height: 10,
            ),
          ]),
        ));
  }
}
