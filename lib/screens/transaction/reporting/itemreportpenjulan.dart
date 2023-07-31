import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/transaction/reporting/itemlistpenjualan.dart';

import '../../../models/cartmodel.dart';
import '../../../widgets/textview.dart';

class ItemReportPenjualan extends StatelessWidget {
  String idx;
  CartDetail data;
  ItemReportPenjualan({super.key, required this.idx, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.white,
        child: Container(
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
                        decoration: BoxDecoration(
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
                    SizedBox(
                      width: 10,
                    ),
                    TextView(
                      text: "GO-00AC1A0103-2307311034-001",
                      headings: 'H4',
                      fontSize: 14,
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextView(
                        text: "31-07-2023",
                        fontSize: 14,
                      ),
                      TextView(
                        text: "10:34",
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
            SizedBox(
              height: 2,
            ),
            ItemListPenjualan(idx: "1", data: data),
            SizedBox(
              height: 10,
            ),
          ]),
        ));
  }
}
