import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/chipsitem.dart';
import 'package:sfa_tools/tools/utils.dart';
import 'package:sfa_tools/widgets/textview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controllers/taking_order_vendor_controller.dart';
import '../../../models/cartdetail.dart';

class CartList extends StatelessWidget {
  String idx;
  CartDetail data;
  CartList({super.key, required this.idx, required this.data});
  final TakingOrderVendorController _takingOrderVendorController = Get.find();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // print(data.nmProduct.length);
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: SizedBox(
        width: 0.9 * width,
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
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
                            width: 0.0725 * width,
                            height: 0.0725 * width,
                            decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: TextView(
                                text: idx,
                                headings: 'H2',
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
                              if (width > 450)
                                SizedBox(
                                  height: 14.sp,
                                  child: TextView(
                                    headings: 'H4',
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                    text: data.nmProduct,
                                    fontSize: data.nmProduct.length > 40 &&
                                            data.nmProduct.length < 45
                                        ? 9.sp
                                        : data.nmProduct.length > 45
                                            ? 8.5.sp
                                            : 9.5.sp,
                                  ),
                                )
                              else
                                SizedBox(
                                  height: 0.018 * height,
                                  child: TextView(
                                    headings: 'H4',
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                    text: data.nmProduct,
                                    fontSize: data.nmProduct.length > 30 &&
                                            data.nmProduct.length < 35
                                        ? 8.sp
                                        : data.nmProduct.length > 35
                                            ? 7.sp
                                            : 9.5.sp,
                                  ),
                                ),
                              if (width > 450)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    data.itemOrder.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0.0),
                                            child: ChipsItem(
                                              satuan:
                                                  "${data.itemOrder[0].Qty} ${data.itemOrder[0].Satuan}",
                                              fontSize: 8.sp,
                                            ))
                                        : Container(),
                                    data.itemOrder.length > 1
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0),
                                            child: ChipsItem(
                                              satuan:
                                                  "${data.itemOrder[1].Qty} ${data.itemOrder[1].Satuan}",
                                              fontSize: 8.sp,
                                            ))
                                        : Container(),
                                    data.itemOrder.length > 2
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0),
                                            child: ChipsItem(
                                              satuan:
                                                  "${data.itemOrder[2].Qty} ${data.itemOrder[2].Satuan}",
                                              fontSize: 8.sp,
                                            ))
                                        : Container()
                                  ],
                                )
                              else
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    data.itemOrder.isNotEmpty
                                        ? ChipsItem(
                                            satuan:
                                                "${data.itemOrder[0].Qty} ${data.itemOrder[0].Satuan}",
                                            fontSize: 6.sp,
                                          )
                                        : Container(),
                                    data.itemOrder.length > 1
                                        ? Padding(
                                            padding:
                                                EdgeInsets.only(left: 2.0.sp),
                                            child: ChipsItem(
                                              satuan:
                                                  "${data.itemOrder[1].Qty} ${data.itemOrder[1].Satuan}",
                                              fontSize: 6.sp,
                                            ))
                                        : Container(),
                                    data.itemOrder.length > 2
                                        ? Padding(
                                            padding:
                                                EdgeInsets.only(left: 2.0.sp),
                                            child: ChipsItem(
                                              satuan:
                                                  "${data.itemOrder[2].Qty} ${data.itemOrder[2].Satuan}",
                                              fontSize: 6.sp,
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
                const SizedBox(
                  height: 10,
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top : 0.0124 * height),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (width > 450)
                    ChipsItem(
                      satuan: Utils().formatNumber(
                          _takingOrderVendorController.countTotalDetail(data)),
                      color: const Color(0xFF8B4513),
                      fontSize: 7.8.sp,
                    )
                  else
                    ChipsItem(
                      satuan: Utils().formatNumber(
                          _takingOrderVendorController.countTotalDetail(data)),
                      color: const Color(0xFF8B4513),
                      fontSize: 6.sp,
                    ),
                  SizedBox(
                    width: 0.01.sw,
                  ),
                  if (width > 450)
                    InkWell(
                      onTap: () {
                        _takingOrderVendorController.handleEditItem(data);
                      },
                      child: Container(
                        width: 28.sp,
                        height: 28.sp,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.green.shade700),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 14.sp,
                            )
                          ],
                        ),
                      ),
                    )
                  else
                    InkWell(
                      onTap: () {
                        _takingOrderVendorController.handleEditItem(data);
                      },
                      child: Container(
                        width: 25.sp,
                        height: 25.sp,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.green.shade700),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 12.sp,
                            )
                          ],
                        ),
                      ),
                    ),
                  SizedBox(
                    width: 0.01.sw,
                  ),
                  if (width > 450)
                    InkWell(
                      onTap: () {
                        _takingOrderVendorController.handleDeleteItem(data);
                      },
                      child: Container(
                        width: 28.sp,
                        height: 28.sp,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red.shade700),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.delete_forever,
                              color: Colors.white,
                              size: 14.sp,
                            )
                          ],
                        ),
                      ),
                    )
                  else
                    InkWell(
                      onTap: () {
                        _takingOrderVendorController.handleDeleteItem(data);
                      },
                      child: Container(
                        width: 25.sp,
                        height: 25.sp,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red.shade700),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.delete_forever,
                              color: Colors.white,
                              size: 12.sp,
                            )
                          ],
                        ),
                      ),
                    ),
                  SizedBox(
                    width: 10.sp,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
