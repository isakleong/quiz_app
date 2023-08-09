import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/models/reportpembayaranmodel.dart';
import 'package:sfa_tools/screens/taking_order_vendor/reporting/itemlistpembayaran.dart';

import '../../../widgets/textview.dart';
import '../transaction/chipsitem.dart';

class ItemReportPembayaran extends StatelessWidget {
  String idx;
  ReportPembayaranModel data;
  String total;
  ItemReportPembayaran(
      {super.key, required this.idx, required this.data, required this.total});

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
                          color: Color(0xFF0288d1),
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
                        ChipsItem(
                          satuan: total,
                          fontSize: 13,
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
              itemCount: data.paymentList.length,
              itemBuilder: (context, inner) {
                return ItemListPembayaran(
                    idx: (inner + 1).toString(), data: data.paymentList[inner]);
              },
            ),
            const SizedBox(
              height: 10,
            ),
          ]),
        ));
  }
}
