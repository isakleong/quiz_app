import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sfa_tools/widgets/textview.dart';

import '../../../common/app_config.dart';

class DialogDeleteTukarWarna extends StatelessWidget {
  var ontapbatal;
  var ontapconfirm;
  DialogDeleteTukarWarna(
      {super.key, required this.ontapbatal, required this.ontapconfirm});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width * 0.8,
      height: 0.45 * height,
      child: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.03,
                ),
                const TextView(
                  text: "Hapus Daftar Barang Pengganti",
                  headings: 'H3',
                  fontSize: 17,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Lottie.asset('assets/lottie/delete.json',
                    width: width * 0.25),
                SizedBox(
                  height: height * 0.02,
                ),
                SizedBox(
                  width: width * 0.7,
                  child: const TextView(
                    text:
                        "Jumlah kuantiti lebih kecil dari sebelumnya, barang pengganti sebelumnya akan terhapus semua, lanjutkan?",
                    headings: 'H4',
                    textAlign: TextAlign.center,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 0.02 * height),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: ontapbatal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side:
                              BorderSide(color: AppConfig.mainCyan, width: 1)),
                      padding: EdgeInsets.only(
                          left: 0.06 * width,
                          right: 0.06 * width,
                          top: 2,
                          bottom: 2),
                    ),
                    child: TextView(
                      text: "TIDAK",
                      headings: 'H2',
                      fontSize: 14,
                      color: AppConfig.mainCyan,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: ontapconfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConfig.mainCyan,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 2, bottom: 2),
                    ),
                    child: const TextView(
                      text: "YA, LANJUTKAN",
                      headings: 'H2',
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
