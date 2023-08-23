import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/chipsitem.dart';

class ActivityPage extends StatelessWidget {
  ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          SizedBox(height: 0.02 * Get.height,),
          Center(child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
               child: Container(
                width: 0.8 *Get.width,height: 0.1 * Get.height,
                 decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    Text("Tangki Air Jerapah"),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ChipsItem(satuan: "3 input penjualan"),
                        ChipsItem(satuan: "1 input pembayaran",color: Colors.amber),
                        ChipsItem(satuan: "2 input retur",color: Colors.amber.shade800),
                      ],
                    )
                  ],),
                )
              ),
            ),)
        ],
      )
    );
  }
}