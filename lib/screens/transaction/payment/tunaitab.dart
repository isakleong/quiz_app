import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/transaction/payment/buttonpayment.dart';

import '../../../controllers/taking_order_vendor_controller.dart';
import '../../../widgets/textview.dart';

class TunaiTab extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  TunaiTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx((() => Stack(
          children: [
            Container(
              width: Get.width,
              height: 0.01 * Get.height,
              color: Colors.grey.shade200,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 0.425 * Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.zero, // Remove content padding
                              border: InputBorder.none, // Remove border
                            ),
                            isExpanded: true,
                            value: _takingOrderVendorController
                                        .choosedTunaiMethod.value ==
                                    ""
                                ? 'Pilih Lokasi Setoran'
                                : _takingOrderVendorController
                                    .choosedTunaiMethod.value,
                            onChanged: (String? newValue) {
                              _takingOrderVendorController
                                  .choosedTunaiMethod.value = newValue!;
                            },
                            items: <String>[
                              'Pilih Lokasi Setoran',
                              'Setor di Bank',
                              'Setor di Cabang',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 10),
                                    const Icon(
                                      FontAwesomeIcons.moneyBillTransfer,
                                      color: Color(0XFF319088),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 15),
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
                      Container(
                        width: 0.425 * Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          controller:
                              _takingOrderVendorController.nominaltunai.value,
                          keyboardType: TextInputType.number,
                          onChanged: _takingOrderVendorController
                              .formatMoneyTextField(_takingOrderVendorController
                                  .nominaltunai.value),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              labelText: 'Nominal Tunai',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                FontAwesomeIcons.calculator,
                                color: Color(0XFF319088),
                              )),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonPayment(
                        ontap: () {
                          _takingOrderVendorController.insertRecord("Tunai");
                        },
                        bgcolor: _takingOrderVendorController.listpaymentdata
                                .any((data) => data.jenis == 'Tunai')
                            ? const Color(0xFF398e3d)
                            : const Color(0XFF319088),
                        icon: _takingOrderVendorController.listpaymentdata
                                .any((data) => data.jenis == 'Tunai')
                            ? FontAwesomeIcons.pencilSquare
                            : FontAwesomeIcons.plusSquare,
                        txt: _takingOrderVendorController.listpaymentdata
                                .any((data) => data.jenis == 'Tunai')
                            ? "Ganti Pembayaran"
                            : "Tambah Pembayaran",
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        )));
  }
}
