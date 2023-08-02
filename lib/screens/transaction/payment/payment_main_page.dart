import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/controllers/taking_order_vendor_controller.dart';
import 'package:sfa_tools/screens/transaction/payment/bannernopayment.dart';
import 'package:sfa_tools/screens/transaction/payment/paymentheader.dart';
import 'package:sfa_tools/screens/transaction/payment/paymentlist.dart';
import 'package:sfa_tools/screens/transaction/payment/paymenttab.dart';
import 'package:sfa_tools/screens/transaction/payment/piutangcard.dart';
import 'package:sfa_tools/screens/transaction/takingordervendor/chipsitem.dart';
import 'package:sfa_tools/widgets/backbuttonaction.dart';
import 'package:sfa_tools/widgets/customelevatedbutton.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../takingordervendor/cartlist.dart';

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
                            left: 0.05 * Get.width, top: 0.02 * Get.height),
                        child: PiutangCard()),
                    const SizedBox(
                      height: 20,
                    ),
                    PaymentTab(),
                    Container(
                      width: Get.width,
                      height: 10,
                      color: Colors.grey.shade200,
                    ),
                    // BannerNoPayment()
                    PaymentHeader(),
                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            _takingOrderVendorController.cartDetailList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: 0.05 * Get.width,
                                top: 5,
                                right: 0.05 * Get.width),
                            child: PaymentList(
                              idx: (index + 1).toString(),
                              metode: 'Cek / Giro / Slip - mandiri[gjugbgfv]',
                              jatuhtempo: "Jatuh Tempo: 02-08-2023",
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
