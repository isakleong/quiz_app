import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/models/cartmodel.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/chipsitem.dart';
import 'package:sfa_tools/widgets/textview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controllers/taking_order_vendor_controller.dart';

class CheckoutList extends StatelessWidget {
  String idx;
  CartDetail data;
  CheckoutList({super.key, required this.idx, required this.data});
  final TakingOrderVendorController _takingOrderVendorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Colors.white,
      child: SizedBox(
        width: 0.9 * Get.width,
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
                          height: 0.07 * Get.width,
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
                          width: 0.025 * Get.width,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextView(
                              headings: 'H4',
                              fontSize: 9.5.sp,
                              text: data.nmProduct,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                data.itemOrder.isNotEmpty
                                    ? ChipsItem(
                                        satuan:
                                            "${data.itemOrder[0].Qty} ${data.itemOrder[0].Satuan}",
                                        fontSize: 8.sp,
                                      )
                                    : Container(),
                                data.itemOrder.length > 1
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: ChipsItem(
                                          satuan:
                                              "${data.itemOrder[1].Qty} ${data.itemOrder[1].Satuan}",
                                          fontSize: 8.sp,
                                        ))
                                    : Container(),
                                data.itemOrder.length > 2
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: ChipsItem(
                                          satuan:
                                              "${data.itemOrder[2].Qty} ${data.itemOrder[2].Satuan}",
                                          fontSize: 8.sp,
                                        ))
                                    : Container()
                                // SizedBox(
                                //   width: 0.1 * width,
                                // ),
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
