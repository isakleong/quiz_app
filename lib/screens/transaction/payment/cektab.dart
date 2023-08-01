import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CekTab extends StatelessWidget {
  const CekTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: Get.width,
          height: 10,
          color: Colors.grey.shade200,
        ),
        const Center(
          child: Text("It's cek"),
        ),
      ],
    );
  }
}
