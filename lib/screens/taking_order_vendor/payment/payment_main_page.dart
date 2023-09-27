import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/controllers/taking_order_vendor_controller.dart';
import 'package:sfa_tools/screens/taking_order_vendor/payment/bannernopayment.dart';
import 'package:sfa_tools/screens/taking_order_vendor/payment/paymentheader.dart';
import 'package:sfa_tools/screens/taking_order_vendor/payment/paymentlist.dart';
import 'package:sfa_tools/screens/taking_order_vendor/payment/paymenttab.dart';
import 'package:sfa_tools/screens/taking_order_vendor/payment/piutangcard.dart';
import 'package:sfa_tools/widgets/backbuttonaction.dart';
import 'package:shimmer/shimmer.dart';

import '../../../tools/utils.dart';

class PaymentMainPage extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  PaymentMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() => SafeArea(
                child: Stack(
              children: [
                SvgPicture.asset(
                  'assets/images/bg-homepage.svg',
                  fit: BoxFit.cover,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(left: 20, top: 10),
                        child: BackButtonAction()),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 0.05 * width, top: 0.01 * height),
                        child: _takingOrderVendorController.totalpiutang.value == "" ? Shimmer.fromColors(
                          baseColor: Colors.grey.shade400,
                          highlightColor: Colors.grey.shade200,
                          child: Container(
                            width: 0.9 * width,
                            height: 0.2 * height,
                            color: Colors.white,
                            // Add any other child widgets you want inside the shimmering container
                          ),
                        ) :
                        PiutangCard(nmtoko : _takingOrderVendorController.nmtoko.value,
                        totalpiutang: _takingOrderVendorController.totalpiutang.value == "0" || _takingOrderVendorController.totalpiutang.value == "null" ? "0" : Utils().formatNumber(int.parse( _takingOrderVendorController.totalpiutang.value)),
                        totaljatuhtempo: _takingOrderVendorController.totaljatuhtempo.value == "0" || _takingOrderVendorController.totaljatuhtempo.value == "null" ? "0" : Utils().formatNumber(int.parse( _takingOrderVendorController.totaljatuhtempo.value)))),
                    const SizedBox(
                      height: 15,
                    ),
                    PaymentTab(),
                    Container(
                      width: width,
                      height: 10,
                      color: Colors.grey.shade200,
                    ),
                    // BannerNoPayment()
                    _takingOrderVendorController.listpaymentdata.isEmpty &&
                            _takingOrderVendorController.showBanner.value == 1
                        ? const BannerNoPayment()
                        : PaymentHeader(),
                    _takingOrderVendorController.listpaymentdata.isEmpty ? Container():
                    Expanded(
                        child: AnimatedList(
                            key: _takingOrderVendorController.pembayaranListKey,
                            initialItemCount: _takingOrderVendorController
                                .listpaymentdata.length,
                            itemBuilder: ((context, index, animation) {
                              return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(-1, 0),
                                    end: const Offset(0, 0),
                                  ).animate(CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeInOut,
                                    reverseCurve: Curves.easeInOut,
                                  )),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 0.05 * width,
                                        top: 5,
                                        right: 0.05 * width),
                                    child: PaymentList(
                                      idx: (index + 1).toString(),
                                      metode: _takingOrderVendorController
                                                  .listpaymentdata[index]
                                                  .jenis ==
                                              "cn"
                                          ? "Potongan CN"
                                          : _takingOrderVendorController
                                                      .listpaymentdata[index]
                                                      .jenis ==
                                                  "cek"
                                              ? "Cek / Giro / Slip - ${_takingOrderVendorController.listpaymentdata[index].tipe} [${_takingOrderVendorController.listpaymentdata[index].nomor}]"
                                              : _takingOrderVendorController.listpaymentdata[index].jenis  + (_takingOrderVendorController.listpaymentdata[index].jenis == "Transfer" ? "" : " - ${_takingOrderVendorController.listpaymentdata[index].tipe}"),
                                      jatuhtempo: _takingOrderVendorController
                                                  .listpaymentdata[index]
                                                  .jatuhtempo ==
                                              ""
                                          ? _takingOrderVendorController
                                              .listpaymentdata[index].jatuhtempo
                                          : "Jatuh Tempo : ${_takingOrderVendorController.listpaymentdata[index].jatuhtempo}",
                                      value:
                                          "Rp ${Utils().formatNumber(_takingOrderVendorController.listpaymentdata[index].value.toInt())}",
                                      jenis: _takingOrderVendorController
                                          .listpaymentdata[index].jenis,
                                    ),
                                  ));
                            })))
                  ],
                )
              ],
            ))));
  }
}
