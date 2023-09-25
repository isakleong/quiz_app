import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/widgets/textview.dart';

class RefreshAction extends StatelessWidget {
  var ontap;
  RefreshAction({super.key, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConfig.darkGreen,
        padding: const EdgeInsets.all(12),
        shape: const StadiumBorder(),
        elevation: 5,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          FaIcon(FontAwesomeIcons.arrowsRotate),
          SizedBox(width: 10),
          TextView(headings: "H3", text: "Refresh", color: Colors.white),
        ],
      ),
    );
  }
}
