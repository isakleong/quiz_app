import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/widgets/textview.dart';

class NoInputRetur extends StatelessWidget {
  String image;
  String title;
  String description;
  NoInputRetur(
      {super.key,
      required this.image,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 0.04 * Get.height,
        ),
        Image.asset(
          // 'assets/images/returtukarwarna.png',
          image,
          width: 0.6 * Get.width,
          height: 0.35 * Get.width,
          fit: BoxFit.scaleDown,
        ),
        SizedBox(
          height: 0.02 * Get.height,
        ),
        TextView(
          text: title,
          // "Belum Ada Produk Ditukar",
          fontSize: 24,
          headings: 'H4',
        ),
        TextView(
          text: description,
          // "Anda dapat mulai mencari produk yang akan ditukar dan menambahkannya ke dalam keranjang.",
          fontSize: 16,
          // headings: 'H4',
        )
      ],
    );
  }
}
