import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/transaction/payment/buttonpayment.dart';

import '../../../controllers/taking_order_vendor_controller.dart';

class CekTab extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  CekTab({super.key});

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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 0.04 * Get.width,
                ),
                Container(
                  width: 0.6 * Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    controller: _takingOrderVendorController.nomorcek.value,
                    decoration: InputDecoration(
                        labelText: 'Nomor Cek / Giro / Slip',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          FontAwesomeIcons.moneyCheck,
                          color: Color(0XFF319088),
                        )),
                  ),
                ),
                SizedBox(
                  width: 0.02 * Get.width,
                ),
                Container(
                  width: 0.3 * Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    controller: _takingOrderVendorController.nominalcek.value,
                    keyboardType: TextInputType.number,
                    onChanged:
                        _takingOrderVendorController.formatMoneyTextField(
                            _takingOrderVendorController.nominalcek.value),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                        labelText: 'Nominal',
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 0.04 * Get.width,
                ),
                Container(
                  width: 0.292 * Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    controller: _takingOrderVendorController.nmbank.value,
                    decoration: InputDecoration(
                        labelText: 'Bank',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          FontAwesomeIcons.moneyCheck,
                          color: Color(0XFF319088),
                        )),
                  ),
                ),
                SizedBox(
                  width: 0.015 * Get.width,
                ),
                Container(
                  width: 0.292 * Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    onTap: () {
                      _takingOrderVendorController.selectDate(context);
                    },
                    focusNode: FocusNode(canRequestFocus: false),
                    controller:
                        _takingOrderVendorController.jatuhtempotgl.value,
                    keyboardType: null,
                    readOnly: true,
                    decoration: InputDecoration(
                        labelText: 'Jatuh Tempo',
                        labelStyle: TextStyle(fontSize: 14),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          FontAwesomeIcons.calendar,
                          color: Color(0XFF319088),
                        )),
                  ),
                ),
                SizedBox(
                  width: 0.05 * Get.width,
                ),
                ButtonPayment(
                  ontap: () {
                    _takingOrderVendorController.insertRecord("cek");
                  },
                  bgcolor: _takingOrderVendorController.listpaymentdata
                          .any((data) => data.jenis == 'cek')
                      ? Color(0xFF398e3d)
                      : Color(0XFF319088),
                  icon: _takingOrderVendorController.listpaymentdata
                          .any((data) => data.jenis == 'cek')
                      ? FontAwesomeIcons.pencilSquare
                      : FontAwesomeIcons.plusSquare,
                  txt: _takingOrderVendorController.listpaymentdata
                          .any((data) => data.jenis == 'cek')
                      ? "Ganti\nPembayaran "
                      : "Tambah\nPembayaran ",
                )
              ],
            )
          ],
        ));
  }
}
