import 'package:flutter/material.dart';

class ButtonPayment extends StatelessWidget {
  var ontap;
  Color bgcolor;
  IconData icon;
  String txt;
  double? fonts;
  double? icsize;
  ButtonPayment(
      {super.key,
      required this.ontap,
      required this.bgcolor,
      required this.icon,
      required this.txt,
      this.fonts,
      this.icsize});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
        elevation: 5,
        backgroundColor: bgcolor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.all(
            10), // Set padding to zero to let the child determine the button's size
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            icon,
            size: icsize ?? 16,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            txt,
            style: TextStyle(color: Colors.white, fontSize: fonts ?? 14),
          ),
        ],
      ),
    );
  }
}
