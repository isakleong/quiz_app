import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/transaction/payment/buttonpayment.dart';

import '../../../controllers/taking_order_vendor_controller.dart';
import '../../../widgets/textview.dart';

class TransferTab extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  TransferTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            Container(
              width: Get.width,
              height: 10,
              color: Colors.grey.shade200,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 0.425 * Get.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey, width: 1)),
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.0, top: 5, bottom: 5),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _takingOrderVendorController
                                    .choosedTransferMethod.value ==
                                ""
                            ? 'Pilih Bank'
                            : _takingOrderVendorController
                                .choosedTransferMethod.value,
                        onChanged: (String? newValue) {
                          _takingOrderVendorController
                              .choosedTransferMethod.value = newValue!;
                        },
                        items: <String>[
                          'Pilih Bank',
                          'MANDIRI',
                          'BCA',
                          'BRI',
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  FontAwesomeIcons.bank,
                                  color: Color(0XFF319088),
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                TextView(
                                  text: value,
                                  textAlign: TextAlign.left,
                                  fontSize: 14,
                                  headings: 'H4',
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 0.425 * Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    controller:
                        _takingOrderVendorController.nominaltransfer.value,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                        labelText: 'Nominal Transfer',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          FontAwesomeIcons.calculator,
                          color: Color(0XFF319088),
                        )),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonPayment(
                  ontap: () {
                    _takingOrderVendorController.insertRecord("Transfer");
                  },
                  bgcolor: _takingOrderVendorController.listpaymentdata
                          .any((data) => data.jenis == 'Transfer')
                      ? Color(0xFF398e3d)
                      : Color(0XFF319088),
                  icon: _takingOrderVendorController.listpaymentdata
                          .any((data) => data.jenis == 'Transfer')
                      ? FontAwesomeIcons.pencilSquare
                      : FontAwesomeIcons.plusSquare,
                  txt: _takingOrderVendorController.listpaymentdata
                          .any((data) => data.jenis == 'Transfer')
                      ? "Ganti Pembayaran"
                      : "Tambah Pembayaran",
                )
              ],
            ),
          ],
        ));
  }
}
