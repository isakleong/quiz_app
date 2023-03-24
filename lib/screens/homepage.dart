import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/models/module.dart';
import 'package:quiz_app/widgets/textview.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    // print(Get.arguments);

    List<Module> moduleList = Get.arguments;
    // for(int i=0; i<moduleList.length; i++) {
    //   print(moduleList[i].moduleID);
    //   print(moduleList[i].version);
    //   print(moduleList[i].orderNumber);
    // }
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/images/bg-history.svg',
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Center(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: moduleList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 12,
                    color: AppConfig.lightGreenColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      splashColor: AppConfig.lightOpactityGreenColor,
                      onTap: () {
                        Get.toNamed(RouteName.quizDashboard, arguments: moduleList);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: TextView(headings: "H2", text: moduleList[index].moduleID, fontSize: 30, color: Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}