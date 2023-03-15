import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/images/bg-home.svg',
            fit: BoxFit.cover,
          ),
        ],
      ),

      
    );
  }
}