import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
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
        Center(
          child: Text("It's tunai"),
        ),
      ],
    );
  }
}
