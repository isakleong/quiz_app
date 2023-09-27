import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/tools/textfieldformatter.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controllers/taking_order_vendor_controller.dart';

class CekTab extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  CekTab({super.key});

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
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 0.04 * width,
                    ),
                    Container(
                      width: 0.6 * width,
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
                            border: const OutlineInputBorder(),
                            prefixIcon: Icon(
                              FontAwesomeIcons.moneyCheck,
                              color: const Color(0XFF319088),
                              size: 12.sp,
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 0.02 * width,
                    ),
                    Container(
                      width: 0.3 * width,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 0.04 * width,
                    ),
                    Container(
                      width: 0.292 * width,
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
                            border: const OutlineInputBorder(),
                            prefixIcon: Icon(
                              FontAwesomeIcons.bank,
                              color: const Color(0XFF319088),
                              size: 12.sp,
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 0.015 * width,
                    ),
                    Container(
                      width: 0.292 * width,
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
                            border: const OutlineInputBorder(),
                            prefixIcon: Icon(
                              FontAwesomeIcons.calendar,
                              color: const Color(0XFF319088),
                              size: 12.sp,
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 0.05 * width,
                    ),
                    _takingOrderVendorController.listProduct.isEmpty ?
                      Shimmer.fromColors(
                              baseColor: Colors.grey.shade400,
                              highlightColor: Colors.grey.shade200,
                              child: Container(
                                width: 0.25 * width,
                                height: 0.05 * height,
                                color: Colors.white,
                                // Add any other child widgets you want inside the shimmering container
                              ),
                            )
                          :
                    ElevatedButton(
                      onPressed: () {
                        //print(_takingOrderVendorController.nmbank.value.text);
                        if (_takingOrderVendorController
                                    .jatuhtempotgl.value.text ==
                                "" ||
                            _takingOrderVendorController.nmbank.value.text ==
                                "" ||
                            _takingOrderVendorController.nomorcek.value.text ==
                                "") {
                          //print("here");
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
                        padding: const EdgeInsets.all(
                            0), // Set padding to zero to let the child determine the button's size
                      ),
                      child: SizedBox(
                        width: 0.275 * width,
                        child: Padding(
                          padding: EdgeInsets.only(top: 5.sp, bottom: 5.sp),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 0.01 * width,
                              ),
                              Icon(
                                _takingOrderVendorController.listpaymentdata
                                        .any((data) => data.jenis == 'cek')
                                    ? FontAwesomeIcons.pencilSquare
                                    : FontAwesomeIcons.plusSquare,
                                size: 14.sp,
                              ),
                              SizedBox(
                                width: 0.01 * width,
                              ),
                              SizedBox(
                                width: 0.18 * width,
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
