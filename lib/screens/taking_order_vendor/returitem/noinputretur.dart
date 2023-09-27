import 'package:flutter/material.dart';
import 'package:sfa_tools/widgets/textview.dart';

class NoInputRetur extends StatelessWidget {
  String image;
  String title;
  String description;
  bool? isHorizontal;
  NoInputRetur(
      {super.key,
      required this.image,
      required this.title,
      required this.description,
      this.isHorizontal});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return isHorizontal == true
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                image,
                width: 0.25 * width,
                height: 0.2 * width,
                fit: BoxFit.scaleDown,
              ),
              SizedBox(
                width: 0.6 * width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextView(
                      text: title,
                      fontSize: 24,
                      headings: 'H4',
                    ),
                    TextView(
                      text: description,
                      fontSize: 16,
                    )
                  ],
                ),
              )
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 0.04 * height,
              ),
              Image.asset(
                image,
                width: 0.6 * width,
                height: 0.35 * width,
                fit: BoxFit.scaleDown,
              ),
              SizedBox(
                height: 0.02 * height,
              ),
              TextView(
                text: title,
                fontSize: 24,
                headings: 'H4',
              ),
              TextView(
                text: description,
                fontSize: 16,
              )
            ],
          );
  }
}
