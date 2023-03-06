import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:quiz_app/common/app_config.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/controllers/config_controller.dart';
import 'package:quiz_app/screens/dashboard.dart';

class SplashScreen extends StatelessWidget {
//  SplashScreen({super.key});

  final configController = Get.find<ConfigController>();

  void openDialog() {
    Get.dialog(
      AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Lottie.asset(
                'assets/lottie/error.json',
                width: 100,
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Obx(() => Text(
                  "Error message :\n${configController.errorMessage.value.capitalize}"
                  )
                )
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(AppConfig.darkGreenColor),
              ),
              child: const Text('OK', style: TextStyle(fontSize: 16, color: Colors.white)),
              onPressed: () async {
                // String? deviceId;
                // // Platform messages may fail, so we use a try/catch PlatformException.
                // try {
                //   deviceId = await PlatformDeviceId.getDeviceId;
                // } on PlatformException {
                //   deviceId = 'Failed to get deviceId.';
                // }

                // print(deviceId);
                Get.back();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    ever(configController.isError, (bool success) {
      if (success) {
          openDialog();
      }
    });

    return Scaffold(
      body: SizedBox(
        width: mediaWidth,
        height: mediaHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/images/logo.png", 
                alignment: Alignment.center, 
                fit: BoxFit.contain,
                // width: mediaWidth*0.6,
                width: 250,
              ),
              Lottie.asset(
                'assets/lottie/welcome.json',
                width: mediaWidth*0.5,
              ),
              // Lottie.asset(
              //   'assets/lottie/loading.json',
              //   width: 60,
              // ),
              // Obx(() => Text("${configController.configData}"))

              // GetX<ConfigController>(
              //   builder: (sController) => Flexible(
              //   child: Text(
              //     sController.isLoading.value ? 'Open' : 'Closed',
              //     textAlign: TextAlign.start,
              //     style: TextStyle(
              //       color: sController.isLoading.value
              //       ? Colors.green.shade700
              //       : Colors.red,
              //       fontSize: 22,
              //       fontWeight: FontWeight.bold), 
              //       ),
              //     fit: FlexFit.tight, 
              //   ),
              // ),

              Obx(() {
                if (configController.isLoading.value) {
                  return Lottie.asset(
                    'assets/lottie/loading.json',
                    width: 60,
                  );
                } else if (configController.isError.value) {
                  return ElevatedButton(
                    onPressed: () {
                      configController.getConfigData();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConfig.darkGreenColor,
                      padding: const EdgeInsets.all(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.history),
                        SizedBox(width: 10),
                        Text("Coba Lagi", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  );
                } else {
                  return Text("");
                }
              })

            ],
          ),
        ),
      ),
    );
  }
}

// class SplashScreen extends StatefulWidget {
//   @override
//   SplashScreenState createState() => SplashScreenState();
// }

// class SplashScreenState extends State<SplashScreen> {

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     Future.delayed(const Duration(seconds: 3)).then((value){
//       Navigator.pushReplacement(
//         context,
//         PageRouteBuilder(
//           // transitionDuration: Duration(seconds: 3),
//           pageBuilder: (_, __, ___) => const Dashboard()
//         )
//       );
//     }); 
//   }

//   @override
//   Widget build(BuildContext context) {

  //   double mediaWidth = MediaQuery.of(context).size.width;
  //   double mediaHeight = MediaQuery.of(context).size.height;

  //   return Scaffold(
  //     body: SizedBox(
  //       width: mediaWidth,
  //       height: mediaHeight,
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 100),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Image.asset(
  //               "assets/images/logo.png", 
  //               alignment: Alignment.center, 
  //               fit: BoxFit.contain,
  //               // width: mediaWidth*0.6,
  //               width: 250,
  //             ),
  //             Lottie.asset(
  //               'assets/lottie/welcome.json',
  //               width: mediaWidth*0.5,
  //             ),
  //             Lottie.asset(
  //               'assets/lottie/loading.json',
  //               width: 60,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
// }