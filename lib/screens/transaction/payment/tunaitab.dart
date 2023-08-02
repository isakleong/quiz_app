import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/widgets/customelevatedbutton.dart';

import '../../../widgets/textview.dart';

class TunaiTab extends StatelessWidget {
  const TunaiTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 0.425 * Get.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey, width: 1)),
              child: Padding(
                padding: EdgeInsets.only(right: 8.0, top: 5, bottom: 5),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: 'Pilih Lokasi Setoran',
                    onChanged: (String? newValue) {},
                    items: <String>[
                      'Pilih Lokasi Setoran',
                      'Setor di Bank',
                      'Setor di Cabang',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              FontAwesomeIcons.moneyBillTransfer,
                              color: Color(0XFF319088),
                              size: 16,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            TextView(
                              text: value,
                              textAlign: TextAlign.left,
                              fontSize: 14,
                              headings: 'H4',
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Container(
              width: 0.425 * Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                decoration: InputDecoration(
                    labelText: 'Nominal Tunai',
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
