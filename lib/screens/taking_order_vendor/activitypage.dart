import 'package:flutter/material.dart';
import 'package:sfa_tools/screens/taking_order_vendor/transaction/chipsitem.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          SizedBox(height: 0.02 * height,),
          Center(child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
               child: Container(
                width: 0.8 *width,height: 0.1 * height,
                 decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    const Text("Tangki Air Jerapah"),
                    const SizedBox(height: 20,),
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