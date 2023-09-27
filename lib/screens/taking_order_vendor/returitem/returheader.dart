import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../common/app_config.dart';
import '../../../widgets/textview.dart';
import '../transaction/chipsitem.dart';

class ReturHeader extends StatelessWidget {
  String jumlahproduk;
  var onTap;
  ReturHeader({super.key, required this.jumlahproduk, required this.onTap});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 0.05 * width,
                ),
                Container(
                  width: 45,
                  height: 45,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF48d4d1),
                        Color(0xFF378a8a),
                      ],
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/cart.png',
                        width: 25,
                        height: 25,
                        color: Colors.white,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 0.02 * width,
                ),
                const TextView(
                  text: "Keranjang",
                  headings: 'H3',
                  fontSize: 18,
                ),
                SizedBox(
                  width: 0.02 * width,
                ),
                ChipsItem(
                  satuan: jumlahproduk,
                  fontSize: 14,
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 0.05 * width),
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConfig.mainCyan,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 2, bottom: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      FontAwesomeIcons.solidCheckCircle,
                      size: 18,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    TextView(
                      text: "Simpan",
                      headings: 'H4',
                      fontSize: 14,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
