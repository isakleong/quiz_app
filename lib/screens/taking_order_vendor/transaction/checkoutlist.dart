import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/chipsitem.dart';
import 'package:sfa_tools/widgets/textview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controllers/taking_order_vendor_controller.dart';
import '../../../models/cartdetail.dart';

class CheckoutList extends StatelessWidget {
  String idx;
  CartDetail data;
  CheckoutList({super.key, required this.idx, required this.data});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Colors.white,
      child: SizedBox(
        width: 0.9 * width,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Column(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 0.025 * width,
                        ),
                        Container(
                          width: 0.07 * width,
                          height: 0.07 * width,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: TextView(
                              text: idx,
                              headings: 'H3',
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 0.025 * width,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextView(
                              headings: 'H4',
                              fontSize: data.nmProduct.length > 40 ? 8.7.sp : 9.5.sp,
                              text: data.nmProduct,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                for (var l = 0; l < data.itemOrder.length; l++)
                                  l == 0 ? ChipsItem(
                                          satuan: "${data.itemOrder[l].Qty} ${data.itemOrder[l].Satuan}",
                                          fontSize: data.nmProduct.length > 40 ? 7.5.sp : 8.sp,
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: ChipsItem(
                                            satuan: "${data.itemOrder[l].Qty} ${data.itemOrder[l].Satuan}",
                                            fontSize: data.nmProduct.length > 40 ? 7.5.sp : 8.sp,
                                          ))
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
    );
  }
}
