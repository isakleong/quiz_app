import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ButtonPayment extends StatelessWidget {
  var ontap;
  Color bgcolor;
  IconData icon;
  String txt;
  ButtonPayment(
      {super.key,
      required this.ontap,
      required this.bgcolor,
      required this.icon,
      required this.txt});

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
        padding: EdgeInsets
            .zero, // Set padding to zero to let the child determine the button's size
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 10,
            ),
            Icon(icon),
            SizedBox(
              width: 10,
            ),
            Text(
              txt,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
