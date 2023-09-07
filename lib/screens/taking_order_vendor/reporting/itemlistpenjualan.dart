import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../models/cartdetail.dart';
import '../../../widgets/textview.dart';
import '../transaction/chipsitem.dart';

class ItemListPenjualan extends StatelessWidget {
  String idx;
  CartDetail data;
  ItemListPenjualan({super.key, required this.idx, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 0.05 * Get.width),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 0.04 * Get.height,
            decoration: const BoxDecoration(color: Color(0xFFfe8a66)),
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
                                  fontSize: Get.width < 450 ? 12.sp : 20,
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
                                  fontSize: Get.width < 450 ? 10.sp : 13,
                                  text: data.nmProduct,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    for(var j = 0 ; j < data.itemOrder.length; j++)
                                    Padding(
                                      padding: EdgeInsets.only(left: j == 0 ? 0.0 : 5),
                                        child: ChipsItem(
                                          satuan: "${data.itemOrder[j].Qty} ${data.itemOrder[j].Satuan}",
                                            fontSize: Get.width < 450 ? 8.sp : 12,
                                    )),
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
