import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/screens/taking_order_vendor/activitypage.dart';
import 'package:sfa_tools/screens/taking_order_vendor/vendorlistpage.dart';
import '../../common/app_config.dart';
import '../../widgets/backbuttonaction.dart';

class VendorListAndActivity extends StatefulWidget {
  const VendorListAndActivity({super.key});

  @override
  State<VendorListAndActivity> createState() => _VendorListAndActivityState();
}

class _VendorListAndActivityState extends State<VendorListAndActivity> with SingleTickerProviderStateMixin{
  List<bool> selectedsegment = [true, false];
  int indexSegment = 0;
  List pages = [
    const VendorlistPage(),
    const ActivityPage(),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
       body:  SafeArea(
            child: Stack(
              children: [
                SvgPicture.asset(
                  'assets/images/bg-homepage.svg',
                  fit: BoxFit.cover,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 0.05 * width,
                        top: 0.01 * height,
                      ),
                      child: const BackButtonAction(),
                    ),
                    Center(
                      child: ToggleButtons(
                        isSelected: selectedsegment,
                        onPressed: (index) {
                          indexSegment = index;
                          for (var i = 0; i < selectedsegment.length; i++) {
                            selectedsegment[i] = false;
                          }
                          setState(() {
                            selectedsegment[index] = true;
                          });
                        },
                        constraints: BoxConstraints(minWidth: 0.25 * width,minHeight: 0.05 * height),
                        borderColor: Colors.grey,
                        selectedBorderColor: AppConfig.mainCyan,
                        borderRadius: BorderRadius.circular(20.0),
                        borderWidth: 1.0,
                        selectedColor: AppConfig.mainCyan,
                        fillColor: const Color(0xFFe0f2f2),
                        children: [
                          'Daftar Vendor',
                          'Aktivitas',
                        ].map((item) => Text(
                              item,
                              textAlign: TextAlign.center,
                            ))
                        .toList(),
                      ),
                    ),
                    SizedBox(height: 0.02 * height,),
                    Expanded(child: pages[indexSegment])
                  ],
                ),
              ],
            ),
          ));
    
  }
}