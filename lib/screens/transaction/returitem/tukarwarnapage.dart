import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/transaction/returitem/noinputretur.dart';
import 'package:sfa_tools/widgets/textview.dart';

class TukarWarnaPage extends StatelessWidget {
  const TukarWarnaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
            image: 'assets/images/returtukarwarna.png',
            title: "Belum Ada Produk Ditukar",
            description:
                "Anda dapat mulai mencari produk yang akan ditukar dan menambahkannya ke dalam keranjang.")
      ],
    );
  }
}
