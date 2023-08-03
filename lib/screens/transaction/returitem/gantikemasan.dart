import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/transaction/returitem/noinputretur.dart';

import '../../../widgets/textview.dart';

class GantiKemasan extends StatelessWidget {
  const GantiKemasan({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 0.02 * Get.height),
          child: Container(
            width: 0.9 * Get.width,
            height: 0.02 * Get.height,
            decoration:
                BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          ),
        ),
        SizedBox(
          height: 0.02 * Get.height,
        ),
        NoInputRetur(
            image: 'assets/images/returgantikemasan.png',
            title: "Belum Ada Produk Diganti",
            description:
                "Anda dapat mulai mencari produk yang akan diganti dan menambahkannya ke dalam keranjang.")
      ],
    );
  }
}
