import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/screens/dashboard.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Future.delayed(const Duration(seconds: 3)).then((value){
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          // transitionDuration: Duration(seconds: 3),
          pageBuilder: (_, __, ___) => const Dashboard()
        )
      );
    }); 
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
              Lottie.asset(
                'assets/lottie/loading.json',
                width: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}