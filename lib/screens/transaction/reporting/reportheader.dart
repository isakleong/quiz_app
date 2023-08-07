import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sfa_tools/common/app_config.dart';

import '../../../widgets/textview.dart';

class ReportHeader extends StatelessWidget {
  String img;
  String title;
  ReportHeader({super.key, required this.img, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppConfig.mainCyan,
              ),
            ),
            Image.asset(
              img,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ],
        ),
        const SizedBox(
          width: 20,
        ),
        TextView(headings: "H4", text: title, fontSize: 20)
      ],
    );
  }
}
