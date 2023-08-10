import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/taking_order_vendor/payment/buttonpayment.dart';
import 'package:sfa_tools/tools/textfieldformatter.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controllers/taking_order_vendor_controller.dart';

class CekTab extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  CekTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
          children: [
            Container(
              width: Get.width,
              height: 10,
              color: Colors.grey.shade200,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                        style: TextStyle(fontSize: 12.sp),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            labelText: 'Nomor Cek / Giro / Slip',
                            labelStyle: TextStyle(
                              fontSize: 10.sp,
                            ),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(
                              FontAwesomeIcons.moneyCheck,
                              color: Color(0XFF319088),
                              size: 12.sp,
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
                        controller:
                            _takingOrderVendorController.nominalcek.value,
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 12.sp),
                        // onChanged:
                        //     _takingOrderVendorController.formatMoneyTextField(
                        //         _takingOrderVendorController.nominalcek.value),
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.digitsOnly
                        // ],
                        inputFormatters: [NumberInputFormatter()],
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            labelText: 'Nominal',
                            labelStyle: TextStyle(
                              fontSize: 10.sp,
                            ),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(
                              FontAwesomeIcons.calculator,
                              color: Color(0XFF319088),
                              size: 12.sp,
                            )),
                      ),
                    )
                  ],
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
                        style: TextStyle(fontSize: 12.sp),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            labelText: 'Bank',
                            labelStyle: TextStyle(
                              fontSize: 10.sp,
                            ),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(
                              FontAwesomeIcons.bank,
                              color: Color(0XFF319088),
                              size: 12.sp,
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
                        style: TextStyle(fontSize: 12.sp),
                        keyboardType: null,
                        readOnly: true,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            labelText: 'Jatuh Tempo',
                            labelStyle: TextStyle(
                              fontSize: 10.sp,
                            ),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(
                              FontAwesomeIcons.calendar,
                              color: Color(0XFF319088),
                              size: 12.sp,
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 0.05 * Get.width,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print(_takingOrderVendorController.nmbank.value.text);
                        if (_takingOrderVendorController
                                    .jatuhtempotgl.value.text ==
                                "" ||
                            _takingOrderVendorController.nmbank.value.text ==
                                "" ||
                            _takingOrderVendorController.nomorcek.value.text ==
                                "") {
                          print("here");
                          Get.snackbar(
                              "Error", "Pastikan semua form sudah di isi !",
                              backgroundColor: Colors.red.withOpacity(0.5));
                          return;
                        }
                        _takingOrderVendorController.insertRecord("cek");
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: _takingOrderVendorController
                                .listpaymentdata
                                .any((data) => data.jenis == 'cek')
                            ? const Color(0xFF398e3d)
                            : const Color(0XFF319088),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.all(
                            0), // Set padding to zero to let the child determine the button's size
                      ),
                      child: Container(
                        width: 0.275 * Get.width,
                        child: Padding(
                          padding: EdgeInsets.only(top: 5.sp, bottom: 5.sp),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 0.01 * Get.width,
                              ),
                              Icon(
                                _takingOrderVendorController.listpaymentdata
                                        .any((data) => data.jenis == 'cek')
                                    ? FontAwesomeIcons.pencilSquare
                                    : FontAwesomeIcons.plusSquare,
                                size: 14.sp,
                              ),
                              SizedBox(
                                width: 0.01 * Get.width,
                              ),
                              Container(
                                width: 0.18 * Get.width,
                                child: Text(
                                  _takingOrderVendorController.listpaymentdata
                                          .any((data) => data.jenis == 'cek')
                                      ? "Ganti Pembayaran"
                                      : "Tambah Pembayaran",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 9.5.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ));
  }
}
