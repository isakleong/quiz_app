import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/taking_order_vendor/payment/buttonpayment.dart';
import 'package:sfa_tools/tools/textfieldformatter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controllers/taking_order_vendor_controller.dart';

class TransferTab extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  TransferTab({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Obx(() => Stack(
          children: [
            Container(
              width: width,
              height: 10,
              color: Colors.grey.shade200,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      /* pilih bank
                      Container(
                        width: 0.45 * width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey, width: 1)),
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
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      FontAwesomeIcons.bank,
                                      color: const Color(0XFF319088),
                                      size: 12.sp,
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    TextView(
                                      text: value,
                                      textAlign: TextAlign.left,
                                      fontSize: 10.sp,
                                      headings: 'H4',
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),*/
                      Container(
                        width: 0.8 * width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          controller: _takingOrderVendorController
                              .nominaltransfer.value,
                          keyboardType: TextInputType.number,
                          // onChanged: _takingOrderVendorController
                          //     .formatMoneyTextField(_takingOrderVendorController
                          //         .nominaltransfer.value),
                          // inputFormatters: [
                          //   FilteringTextInputFormatter.digitsOnly
                          // ],
                          inputFormatters: [NumberInputFormatter()],
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              labelText: 'Nominal Transfer',
                              labelStyle: TextStyle(
                                fontSize: 10.sp,
                              ),
                              border: const OutlineInputBorder(),
                              prefixIcon: Icon(
                                FontAwesomeIcons.calculator,
                                color: const Color(0XFF319088),
                                size: 12.sp,
                              )),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _takingOrderVendorController.listProduct.isEmpty ?
                      Shimmer.fromColors(
                              baseColor: Colors.grey.shade400,
                              highlightColor: Colors.grey.shade200,
                              child: Container(
                                width: 0.3 * width,
                                height: 0.05 * height,
                                color: Colors.white,
                                // Add any other child widgets you want inside the shimmering container
                              ),
                            )
                          :
                      ButtonPayment(
                        ontap: () {
                           _takingOrderVendorController.choosedTransferMethod.value = 'MANDIRI';
                          if (_takingOrderVendorController
                                      .choosedTransferMethod.value ==
                                  "Pilih Bank" ||
                              _takingOrderVendorController
                                      .choosedTransferMethod.value ==
                                  "") {
                            Get.snackbar(
                                "Error", "Pilih Bank Terlebih Dahulu !",
                                backgroundColor: Colors.red.withOpacity(0.5));
                          } else {
                            _takingOrderVendorController
                                .insertRecord("Transfer");
                          }
                        },
                        bgcolor: _takingOrderVendorController.listpaymentdata
                                .any((data) => data.jenis == 'Transfer')
                            ? const Color(0xFF398e3d)
                            : const Color(0XFF319088),
                        icon: _takingOrderVendorController.listpaymentdata
                                .any((data) => data.jenis == 'Transfer')
                            ? FontAwesomeIcons.pencilSquare
                            : FontAwesomeIcons.plusSquare,
                        txt: _takingOrderVendorController.listpaymentdata
                                .any((data) => data.jenis == 'Transfer')
                            ? "Ganti Pembayaran"
                            : "Tambah Pembayaran",
                        fonts: 10.5.sp,
                        icsize: 14.sp,
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
