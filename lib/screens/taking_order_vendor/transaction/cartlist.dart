import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/models/cartmodel.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/chipsitem.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../../../controllers/taking_order_vendor_controller.dart';

class CartList extends StatelessWidget {
  String idx;
  CartDetail data;
  CartList({super.key, required this.idx, required this.data});
  final TakingOrderVendorController _takingOrderVendorController = Get.find();

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
        child: Column(
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
                        width: 0.0725 * Get.width,
                        height: 0.0725 * Get.width,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: TextView(
                            text: idx,
                            headings: 'H2',
                            fontSize: 20,
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
                            fontSize: 14,
                            text: data.nmProduct,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              data.itemOrder.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 0.0),
                                      child: ChipsItem(
                                        satuan:
                                            "${data.itemOrder[0].Qty} ${data.itemOrder[0].Satuan}",
                                        fontSize: 12,
                                      ))
                                  : Container(),
                              data.itemOrder.length > 1
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: ChipsItem(
                                        satuan:
                                            "${data.itemOrder[1].Qty} ${data.itemOrder[1].Satuan}",
                                        fontSize: 12,
                                      ))
                                  : Container(),
                              data.itemOrder.length > 2
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ChipsItem(
                        satuan: _takingOrderVendorController.formatNumber(
                            _takingOrderVendorController
                                .countTotalDetail(data)),
                        color: const Color(0xFF8B4513),
                        fontSize: 12,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          _takingOrderVendorController.handleEditItem(data);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green.shade700),
                          child: Stack(
                            alignment: Alignment.center,
                            children: const [
                              Icon(
                                Icons.edit,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          _takingOrderVendorController.handleDeleteItem(data);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red.shade700),
                          child: Stack(
                            alignment: Alignment.center,
                            children: const [
                              Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ]),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
