import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/controllers/quiz_controller.dart';

class Dashboard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFcaceff).withOpacity(1),
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
              child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
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
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    highlightColor: Colors.blue.withOpacity(0.3),
                    splashColor: Colors.blue.withOpacity(0.3),
                    onTap: () async {
                      Get.toNamed(RouteName.starter);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.edit_note, size: 60, color: Colors.blue),
                        SizedBox(height: 15),
                        Text('Quiz', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(5),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    highlightColor: Colors.blue.withOpacity(0.3),
                    splashColor: Colors.blue.withOpacity(0.3),
                    onTap: (){},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.history_toggle_off, size: 60, color: Colors.blue),
                        SizedBox(height: 15),
                        Text('Riwayat', style: TextStyle(fontSize: 18)),
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