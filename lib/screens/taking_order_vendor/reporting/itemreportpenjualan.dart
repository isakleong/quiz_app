import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/models/reportpenjualanmodel.dart';
import 'package:sfa_tools/screens/taking_order_vendor/reporting/itemlistpenjualan.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/chipsitem.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sfa_tools/tools/utils.dart';
import '../../../widgets/textview.dart';

class ItemReportPenjualan extends StatelessWidget {
  String idx;
  String custid;
  ReportPenjualanModel data;
  ItemReportPenjualan(
      {super.key, required this.idx, required this.data, required this.custid});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.white,
        child: SizedBox(
          width: 0.9 * width,
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
                          top: 10, bottom: 10, left: 0.02 * width),
                      child: Container(
                        width: 0.07 * width,
                        height: 0.07 * width,
                        decoration: const BoxDecoration(
                          color: Color(0xFFf5511e),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: TextView(
                            text: idx,
                            color: Colors.white,
                            fontSize: width < 450 ? 12.sp : 18,
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
                        Row(
                          children: [
                            TextView(
                              text: data.id + " ($custid)",
                              headings: 'H4',
                              fontSize: width < 450 ? 7.sp : 9.sp,
                            ),
                          ],
                        ),
                        data.notes == ""
                            ? Container()
                            : ChipsItem(
                                satuan: data.notes.length >= 35
                                    ? "${data.notes.substring(0, 30)}...      "
                                    : data.notes,
                                color: const Color(0xFFf5511e),
                                fontSize: width < 450 ? 8.sp : 12,
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
                      Row(
                        children: [
                          if (data.condition != 'success')
                            ChipsItem(
                              satuan: data.condition,
                              color: data.condition == 'pending'
                                  ? Colors.amber
                                  : Colors.red,
                              fontSize: width < 450 ? 8.sp : 9.sp,
                            ),
                          if (data.condition != 'success')
                            SizedBox(
                              width: 2.sp,
                            ),
                          TextView(
                            text: Utils().formatDate(data.tanggal),
                            fontSize: width < 450 ? 9.sp : 14,
                          ),
                        ],
                      ),
                      TextView(
                        text: data.waktu,
                        fontSize: width < 450 ? 9.sp : 14,
                      )
                    ],
                  ),
                )
              ],
            ),
            Center(
              child: Container(
                width: 0.85 * width,
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
