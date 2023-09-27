import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/app_config.dart';
import '../../../controllers/taking_order_vendor_controller.dart';

class SegmentButton extends StatelessWidget {
  final TakingOrderVendorController _takingOrderVendorController = Get.find();
  SegmentButton({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Obx(() => ToggleButtons(
          isSelected: _takingOrderVendorController.selectedsegment,
          onPressed: (index) {
            _takingOrderVendorController.indexSegment.value = index;
            for (int buttonIndex = 0;
                buttonIndex <
                    _takingOrderVendorController.selectedsegment.length;
                buttonIndex++) {
              _takingOrderVendorController.selectedsegment[buttonIndex] =
                  buttonIndex == index;
            }
          },
          constraints: BoxConstraints(minWidth: 0.18 * width),
          borderColor: Colors.grey,
          selectedBorderColor: AppConfig.mainCyan,
          borderRadius: BorderRadius.circular(20.0),
          borderWidth: 1.0,
          selectedColor: AppConfig.mainCyan,
          fillColor: const Color(0xFFe0f2f2),
          children: [
            'Tukar\nWarna',
            'Tarik\nBarang',
            'Ganti\nKemasan',
            'Servis\nMebel',
            'Ganti\nBarang'
          ]
              .map((item) => Text(
                    item,
                    textAlign: TextAlign.center,
                  ))
              .toList(),
        ));
  }
}
