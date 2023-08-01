import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/transaction/payment/cektab.dart';
import 'package:sfa_tools/screens/transaction/payment/potongancntab.dart';
import 'package:sfa_tools/screens/transaction/payment/transfertab.dart';
import 'package:sfa_tools/screens/transaction/payment/tunaitab.dart';

class PaymentTab extends StatelessWidget {
  const PaymentTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: 0.35 * Get.height,
      child: DefaultTabController(
        initialIndex: 1,
        length: 4,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            bottom: const TabBar(
              indicatorColor: Color.fromARGB(255, 13, 101, 91),
              unselectedLabelColor: Colors.grey,
              labelColor: Color.fromARGB(255, 13, 101, 91),
              tabs: <Widget>[
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
          body: TabBarView(
            children: <Widget>[
              TunaiTab(),
              TransferTab(),
              PotonganCnTab(),
              CekTab()
            ],
          ),
        ),
      ),
    );
  }
}
