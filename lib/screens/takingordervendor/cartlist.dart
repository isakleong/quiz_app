import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/models/cartmodel.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../../controllers/taking_order_vendor_controller.dart';

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
      child: Container(
        width: 0.9 * width,
        height: 0.07 * height,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              SizedBox(
                width: 0.025 * width,
              ),
              Container(
                width: 0.07 * width,
                height: 0.04 * height,
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
              Padding(
                padding: EdgeInsets.only(top: 0.012 * height),
                child: Column(
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
                        data.itemOrder.length > 0
                            ? Padding(
                                padding: EdgeInsets.only(left: 0.0),
                                child: Container(
                                  width: 0.12 * width,
                                  height: 22,
                                  decoration: BoxDecoration(
                                      color: Colors.blue.shade400,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: TextView(
                                      text:
                                          "${data.itemOrder[0].Qty} ${data.itemOrder[0].Satuan}",
                                      headings: 'H3',
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        data.itemOrder.length > 1
                            ? Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child: Container(
                                  width: 0.12 * width,
                                  height: 22,
                                  decoration: BoxDecoration(
                                      color: Colors.blue.shade400,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: TextView(
                                      text:
                                          "${data.itemOrder[1].Qty} ${data.itemOrder[1].Satuan}",
                                      headings: 'H3',
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        data.itemOrder.length > 2
                            ? Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child: Container(
                                  width: 0.12 * width,
                                  height: 22,
                                  decoration: BoxDecoration(
                                      color: Colors.blue.shade400,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: TextView(
                                      text:
                                          "${data.itemOrder[2].Qty} ${data.itemOrder[2].Satuan}",
                                      headings: 'H3',
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : Container()
                        // SizedBox(
                        //   width: 0.1 * width,
                        // ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 0.14 * width,
                height: 22,
                decoration: BoxDecoration(
                    color: Color(0xFF8B4513),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: TextView(
                    text:
                        "${_takingOrderVendorController.formatNumber(_takingOrderVendorController.countTotalDetail(data))}",
                    headings: 'H3',
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.green.shade700),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.edit,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.red.shade700),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
