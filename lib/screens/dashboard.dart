import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/controllers/quiz_controller.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppConfig.lightGreenColor.withOpacity(1),
      body: Column(
        children: [
          Container(
            width: mediaWidth,
            height: mediaHeight*0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(mediaWidth * 0.5, 80),
                bottomRight: Radius.elliptical(mediaWidth * 0.5, 80),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                  color: const Color(0xff808080).withOpacity(0.5))
              ]
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(mediaWidth * 0.5, 80),
                bottomRight: Radius.elliptical(mediaWidth * 0.5, 80),
              ),
              // child: SvgPicture.asset('assets/images/bg-dashboard.svg', semanticsLabel: 'secret', fit: BoxFit.cover),
              child: Image.asset('assets/images/bg_rev.png', fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                Card(
                  margin: const EdgeInsets.all(5),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    highlightColor: AppConfig.mainGreenColor.withOpacity(0.3),
                    splashColor: AppConfig.mainGreenColor.withOpacity(0.3),
                    onTap: () async {
                      Get.toNamed(RouteName.starter);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.filePen, color: AppConfig.darkGreenColor, size: 50),
                        const SizedBox(height: 30),
                        const Text('Kuis', style: TextStyle(fontSize: 22)),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(5),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    highlightColor: AppConfig.mainGreenColor.withOpacity(0.3),
                    splashColor: AppConfig.mainGreenColor.withOpacity(0.3),
                    onTap: (){
                      Get.toNamed(RouteName.history);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(Icons.history_toggle_off, size: 60, color: Colors.blue),
                        FaIcon(FontAwesomeIcons.clockRotateLeft, color: AppConfig.darkGreenColor, size: 50),
                        const SizedBox(height: 30),
                        const Text('Riwayat', style: TextStyle(fontSize: 22)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}