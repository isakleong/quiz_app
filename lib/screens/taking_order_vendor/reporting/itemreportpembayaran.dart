import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/models/reportpembayaranmodel.dart';
import 'package:sfa_tools/screens/taking_order_vendor/reporting/itemlistpembayaran.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../tools/utils.dart';
import '../../../widgets/textview.dart';
import '../transaction/chipsitem.dart';

class ItemReportPembayaran extends StatelessWidget {
  String idx;
  ReportPembayaranModel data;
  String total;
  String custid;
  ItemReportPembayaran({super.key, required this.idx, required this.data, required this.total,required this.custid});

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
                          color: Color(0xFF0288d1),
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
                              text: data.id,
                              headings: 'H4',
                              fontSize: width < 450 ? 8.sp : 14,
                            ),
                            if(data.condition != 'success')
                            SizedBox(width: 5.sp,),
                            if(data.condition != 'success')
                           ChipsItem(
                                satuan: data.condition,
                                color: data.condition == 'pending' ? Colors.amber : Colors.red,
                                fontSize: width < 450 ? 8.sp : 12,
                              )
                          ],
                        ),
                        ChipsItem(
                          satuan: total,
                          fontSize: width < 450 ? 8.sp : 13,
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
                        text: Utils().formatDate(data.tanggal),
                        fontSize: width < 450 ? 9.sp : 14,
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
