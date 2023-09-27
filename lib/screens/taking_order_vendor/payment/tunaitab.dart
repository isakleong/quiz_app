import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/taking_order_vendor/payment/buttonpayment.dart';
import 'package:sfa_tools/tools/textfieldformatter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controllers/taking_order_vendor_controller.dart';
import '../../../widgets/textview.dart';

class TunaiTab extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  TunaiTab({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Obx((() => Stack(
          children: [
            Container(
              width: width,
              height: 0.01 * height,
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
                      Container(
                        width: 0.45 * width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
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
                                    Icon(
                                      FontAwesomeIcons.moneyBillTransfer,
                                      color: const Color(0XFF319088),
                                      size: 10.sp,
                                    ),
                                    const SizedBox(width: 15),
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
                      ),
                      Container(
                        width: 0.45 * width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          controller:
                              _takingOrderVendorController.nominaltunai.value,
                          keyboardType: TextInputType.number,
                          // onChanged: _takingOrderVendorController
                          //     .formatMoneyTextField(_takingOrderVendorController
                          //         .nominaltunai.value),
                          style: TextStyle(fontSize: 12.sp),
                          inputFormatters: [NumberInputFormatter()],
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              labelText: 'Nominal Tunai',
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
                      _takingOrderVendorController.listProduct.isEmpty
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey.shade400,
                              highlightColor: Colors.grey.shade200,
                              child: Container(
                                width: 0.3 * width,
                                height: 0.05 * height,
                                color: Colors.white,
                                // Add any other child widgets you want inside the shimmering container
                              ),
                            )
                          : ButtonPayment(
                              ontap: () {
                                if (_takingOrderVendorController
                                            .choosedTunaiMethod.value ==
                                        "Pilih Lokasi Setoran" ||
                                    _takingOrderVendorController
                                            .choosedTunaiMethod.value ==
                                        "") {
                                  Get.snackbar("Error",
                                      "Pilih Lokasi Setoran Terlebih Dahulu !",
                                      backgroundColor:
                                          Colors.red.withOpacity(0.5));
                                } else {
                                  _takingOrderVendorController
                                      .insertRecord("Tunai");
                                }
                              },
                              bgcolor: _takingOrderVendorController
                                      .listpaymentdata
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
                              fonts: 10.5.sp,
                              icsize: 14.sp,
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
