import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/common/app_config.dart';

import '../../common/route_config.dart';
import '../../widgets/textview.dart';

class VendorlistPage extends StatelessWidget {
  const VendorlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const SizedBox(height: 20,),
          Center(
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
               child: Container(
                 decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                     colors: [
                      AppConfig.softGreen,
                      AppConfig.softCyan,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    splashColor: AppConfig.mainGreen
                        .withOpacity(0.5),
                    onTap: () async {
                     Get.toNamed(RouteName.takingOrderVendor);
                    },
                    child: const Padding(
                      padding:  EdgeInsets.only(top :20, bottom: 20 ,left: 40,right: 40),
                      child: TextView(
                          headings: "H2",
                          text: "Tangki Air Jerapah",
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          )],)
    );
  }
}