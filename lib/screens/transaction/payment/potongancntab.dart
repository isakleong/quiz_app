import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../widgets/textview.dart';

class PotonganCnTab extends StatelessWidget {
  const PotonganCnTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: Get.width,
          height: 10,
          color: Colors.grey.shade200,
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          width: 0.85 * Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
                labelText: 'Nominal Potongan CN',
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  FontAwesomeIcons.calculator,
                  color: Color(0XFF319088),
                )),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                elevation: 5,
                backgroundColor: Color(0XFF319088),
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
                    Icon(FontAwesomeIcons.circlePlus),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Tambah Pembayaran",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
