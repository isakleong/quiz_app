import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/models/tarikbarangmodel.dart';
import 'package:sfa_tools/screens/transaction/takingordervendor/chipsitem.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../../../controllers/taking_order_vendor_controller.dart';

class CheckoutListGb extends StatelessWidget {
  TarikBarangModel data;
  String idx;
  CheckoutListGb({super.key, required this.idx, required this.data});
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
                              text: data.nmProduct,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                data.itemOrder.isNotEmpty
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(left: 0.0),
                                        child: ChipsItem(
                                          satuan:
                                              "${data.itemOrder[0].Qty} ${data.itemOrder[0].Satuan}",
                                          fontSize: 12,
                                        ))
                                    : Container(),
                                data.itemOrder.length > 1
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: ChipsItem(
                                          satuan:
                                              "${data.itemOrder[1].Qty} ${data.itemOrder[1].Satuan}",
                                          fontSize: 12,
                                        ))
                                    : Container(),
                                data.itemOrder.length > 2
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: ChipsItem(
                                          satuan:
                                              "${data.itemOrder[2].Qty} ${data.itemOrder[2].Satuan}",
                                          fontSize: 12,
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
