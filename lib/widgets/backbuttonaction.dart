import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../common/app_config.dart';

class BackButtonAction extends StatelessWidget {
  const BackButtonAction({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Get.back();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 5,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(10),
      ),
      child: Icon(FontAwesomeIcons.arrowLeft,
          size: 35, color: AppConfig.darkGreen),
    );
  }
}
