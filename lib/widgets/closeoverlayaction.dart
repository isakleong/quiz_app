import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../common/app_config.dart';

class CloseOverlayAction extends StatelessWidget {
  var ontap;
  CloseOverlayAction({super.key,required this.ontap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConfig.mainCyan,
        elevation: 5,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(10),
      ),
      child: const Icon(FontAwesomeIcons.close,
          size: 35, color: Colors.white),
    );
  }
}