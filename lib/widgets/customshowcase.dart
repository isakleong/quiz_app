import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:sfa_tools/widgets/textview.dart';
import 'package:showcaseview/showcaseview.dart';

class CustomShowCase extends StatelessWidget {
  final Widget child;
  final String description;
  final GlobalKey globalkey;
  final double fontsize;
  const CustomShowCase(
      {required this.child,
      required this.description,
      required this.globalkey,
      required this.fontsize});

  @override
  Widget build(BuildContext context) {
    return Showcase(
      description: description,
      key: globalkey,
      showcaseBackgroundColor: Colors.teal,
      // contentPadding: const EdgeInsets.all(12),
      descTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: fontsize
      ),
      child: child
    );
  }
}
