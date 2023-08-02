import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CekTab extends StatelessWidget {
  CekTab({super.key});

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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 0.04 * Get.width,
            ),
            Container(
              width: 0.6 * Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                decoration: InputDecoration(
                    labelText: 'Nomor Cek / Giro / Slip',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      FontAwesomeIcons.moneyCheck,
                      color: Color(0XFF319088),
                    )),
              ),
            ),
            SizedBox(
              width: 0.02 * Get.width,
            ),
            Container(
              width: 0.3 * Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                decoration: InputDecoration(
                    labelText: 'Nominal',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      FontAwesomeIcons.calculator,
                      color: Color(0XFF319088),
                    )),
              ),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 0.04 * Get.width,
            ),
            Container(
              width: 0.292 * Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                decoration: InputDecoration(
                    labelText: 'Bank',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      FontAwesomeIcons.moneyCheck,
                      color: Color(0XFF319088),
                    )),
              ),
            ),
            SizedBox(
              width: 0.015 * Get.width,
            ),
            InkWell(
              onTap: () {},
              child: Container(
                width: 0.292 * Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  // enabled: false,

                  decoration: InputDecoration(
                      labelText: 'Jatuh Tempo',
                      labelStyle: TextStyle(fontSize: 14),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        FontAwesomeIcons.calendar,
                        color: Color(0XFF319088),
                      )),
                ),
              ),
            ),
            SizedBox(
              width: 0.05 * Get.width,
            ),
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
                      "Tambah\nPembayaran",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
