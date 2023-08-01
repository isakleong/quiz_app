import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TunaiTab extends StatelessWidget {
  const TunaiTab({super.key});

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
          child: Text("It's tunai"),
        ),
      ],
    );
  }
}
