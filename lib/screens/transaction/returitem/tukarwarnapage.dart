import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class TukarWarnaPage extends StatelessWidget {
  const TukarWarnaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.only(left: 0.05 * Get.width, top: 0.02 * Get.height),
          child: Container(
            width: 0.9 * Get.width,
            height: 0.02 * Get.height,
            decoration:
                BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          ),
        )
      ],
    );
  }
}
