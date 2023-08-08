import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/controllers/taking_order_vendor_controller.dart';
import 'package:sfa_tools/screens/transaction/payment/bannernopayment.dart';
import 'package:sfa_tools/screens/transaction/payment/paymentheader.dart';
import 'package:sfa_tools/screens/transaction/payment/paymentlist.dart';
import 'package:sfa_tools/screens/transaction/payment/paymenttab.dart';
import 'package:sfa_tools/screens/transaction/payment/piutangcard.dart';
import 'package:sfa_tools/widgets/backbuttonaction.dart';

class PaymentMainPage extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  PaymentMainPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                            left: 0.05 * Get.width, top: 0.01 * Get.height),
                        child: const PiutangCard()),
                    const SizedBox(
                      height: 15,
                    ),
                    PaymentTab(),
                    Container(
                      width: Get.width,
                      height: 10,
                      color: Colors.grey.shade200,
                    ),
                    // BannerNoPayment()
                    _takingOrderVendorController.listpaymentdata.isEmpty
                        ? const BannerNoPayment()
                        : PaymentHeader(),
                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            _takingOrderVendorController.listpaymentdata.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: 0.05 * Get.width,
                                top: 5,
                                right: 0.05 * Get.width),
                            child: PaymentList(
                              idx: (index + 1).toString(),
                              metode: _takingOrderVendorController
                                          .listpaymentdata[index].jenis ==
                                      "cn"
                                  ? "Potongan CN"
                                  : _takingOrderVendorController
                                              .listpaymentdata[index].jenis ==
                                          "cek"
                                      ? "Cek / Giro / Slip - ${_takingOrderVendorController.listpaymentdata[index].tipe} [${_takingOrderVendorController.listpaymentdata[index].nomor}]"
                                      : "${_takingOrderVendorController.listpaymentdata[index].jenis} - ${_takingOrderVendorController.listpaymentdata[index].tipe}",
                              jatuhtempo: _takingOrderVendorController
                                          .listpaymentdata[index].jatuhtempo ==
                                      ""
                                  ? _takingOrderVendorController
                                      .listpaymentdata[index].jatuhtempo
                                  : "Jatuh Tempo : ${_takingOrderVendorController.listpaymentdata[index].jatuhtempo}",
                              value:
                                  "Rp ${_takingOrderVendorController.formatNumber(_takingOrderVendorController.listpaymentdata[index].value.toInt())}",
                              jenis: _takingOrderVendorController
                                  .listpaymentdata[index].jenis,
                            ),
                          );
                        },
                        physics: const BouncingScrollPhysics(),
                      ),
                    ),
                  ],
                )
              ],
            ))));
  }
}
