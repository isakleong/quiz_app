import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/controllers/taking_order_vendor_controller.dart';
import 'package:sfa_tools/screens/transaction/payment/cektab.dart';
import 'package:sfa_tools/screens/transaction/payment/potongancntab.dart';
import 'package:sfa_tools/screens/transaction/payment/transfertab.dart';
import 'package:sfa_tools/screens/transaction/payment/tunaitab.dart';

class PaymentTab extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  PaymentTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: 0.23 * Get.height,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.06 * Get.height),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 20,
            bottom: TabBar(
              controller: _takingOrderVendorController.controller,
              indicatorColor: const Color.fromARGB(255, 13, 101, 91),
              unselectedLabelColor: Colors.grey,
              labelColor: const Color.fromARGB(255, 13, 101, 91),
              tabs: const <Widget>[
                Tab(
                  text: "TUNAI",
                ),
                Tab(
                  text: "TRANSFER",
                ),
                Tab(
                  text: "POTONGAN CN",
                ),
                Tab(
                  text: "CEK/GIRO/SLIP",
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _takingOrderVendorController.controller,
          children: <Widget>[
            TunaiTab(),
            TransferTab(),
            PotonganCnTab(),
            CekTab()
          ],
        ),
      ),
    );
  }
}
