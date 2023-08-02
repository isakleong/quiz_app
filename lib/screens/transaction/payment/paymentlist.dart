import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/transaction/takingordervendor/chipsitem.dart';

import '../../../controllers/taking_order_vendor_controller.dart';
import '../../../widgets/textview.dart';

class PaymentList extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  String idx;
  String metode;
  String jatuhtempo;
  PaymentList(
      {super.key,
      required this.idx,
      required this.metode,
      required this.jatuhtempo});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: SizedBox(
        width: 0.9 * Get.width,
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
                        width: 0.025 * Get.width,
                      ),
                      Container(
                        width: 0.07 * Get.width,
                        height: 0.045 * Get.height,
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
                        width: 0.025 * Get.width,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.0 * Get.height),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextView(
                              headings: 'H4',
                              fontSize: 14,
                              text: metode,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextView(
                                  text: "Rp 3,500",
                                  fontSize: 14,
                                ),
                                SizedBox(
                                  width: 0.01 * Get.width,
                                ),
                                jatuhtempo == ""
                                    ? Container()
                                    : ChipsItem(
                                        satuan: jatuhtempo,
                                        fontSize: 12,
                                      )
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
                      InkWell(
                        onTap: () {},
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
                          print("delete");
                          _takingOrderVendorController.handleDeleteItemPayment(
                              'Cek / Giro / Slip - mandiri');
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
