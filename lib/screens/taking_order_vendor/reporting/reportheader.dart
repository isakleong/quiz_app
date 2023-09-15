import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widgets/textview.dart';

class ReportHeader extends StatelessWidget {
  String img;
  String title;
  ReportHeader({super.key, required this.img, required this.title});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Row(
      children: [
        if (width < 450)
         Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 40.sp,
              height: 40.sp,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppConfig.mainCyan,
              ),
            ),
            Image.asset(
              img,
              width: 30.sp,
              height: 30.sp,
              fit: BoxFit.cover,
            ),
          ],
        )
        else
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
        SizedBox(
          width: width < 450 ? 14.sp :  20,
        ),
        TextView(headings: "H4", text: title, fontSize: width < 450 ? 14.sp : 20)
      ],
    );
  }
}
