import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/chipsitem.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controllers/taking_order_vendor_controller.dart';
import '../../../widgets/textview.dart';

class PaymentList extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  String idx;
  String metode;
  String jatuhtempo;
  String value;
  String jenis;
  PaymentList(
      {super.key,
      required this.idx,
      required this.metode,
      required this.jatuhtempo,
      required this.value,
      required this.jenis});

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
                          TextView(
                            headings: 'H4',
                            fontSize: 10.sp,
                            text: metode,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextView(
                                text:  value,
                                fontSize: 10.sp,
                              ),
                              SizedBox(
                                width: 0.01 * width,
                              ),
                              jatuhtempo == ""
                                  ? Container()
                                  : ChipsItem(
                                      satuan: jatuhtempo,
                                      fontSize: 8.sp,
                                    )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          //print("edit");
                          _takingOrderVendorController.handleeditpayment(jenis);
                        },
                        child: Container(
                          width: 30.sp,
                          height: 30.sp,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green.shade700),
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
                      ),
                      SizedBox(
                        width: 0.01 * width,
                      ),
                      InkWell(
                        onTap: () {
                          //print("delete");
                          _takingOrderVendorController.handleDeleteItemPayment(
                              metode, jenis);
                        },
                        child: Container(
                          width: 30.sp,
                          height: 30.sp,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red.shade700),
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
