import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/controllers/taking_order_vendor_controller.dart';
import 'package:sfa_tools/screens/transaction/payment/buttonpayment.dart';

class PotonganCnTab extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  PotonganCnTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
          children: [
            Container(
              width: Get.width,
              height: 10,
              color: Colors.grey.shade200,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 0.85 * Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      onChanged:
                          _takingOrderVendorController.formatMoneyTextField(
                              _takingOrderVendorController.nominalCn.value),
                      controller: _takingOrderVendorController.nominalCn.value,
                      style: const TextStyle(fontSize: 14),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          labelText: 'Nominal Potongan CN',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            FontAwesomeIcons.calculator,
                            color: Color(0XFF319088),
                          )),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonPayment(
                        ontap: () {
                          _takingOrderVendorController.insertRecord("cn");
                        },
                        bgcolor: _takingOrderVendorController.listpaymentdata
                                .any((data) => data.jenis == 'cn')
                            ? const Color(0xFF398e3d)
                            : const Color(0XFF319088),
                        icon: _takingOrderVendorController.listpaymentdata
                                .any((data) => data.jenis == 'cn')
                            ? FontAwesomeIcons.pencilSquare
                            : FontAwesomeIcons.plusSquare,
                        txt: _takingOrderVendorController.listpaymentdata
                                .any((data) => data.jenis == 'cn')
                            ? "Ganti Pembayaran"
                            : "Tambah Pembayaran",
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
