import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/common/route_config.dart';
import 'package:quiz_app/controllers/config_controller.dart';
import 'package:quiz_app/screens/dashboard.dart';

class SplashScreen extends StatelessWidget {
//  SplashScreen({super.key});

  final configController = Get.find<ConfigController>();

  void openDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Dialog'),
        content: const Text('This is a dialog'),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

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

              Obx(() {
                if (configController.isLoading.value) {
                  return Lottie.asset(
                    'assets/lottie/loading.json',
                    width: 60,
                  );
                } else if (configController.isError.value) {
                  return Text(
                    "Error: ${configController.errorMessage.value.capitalize}"
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