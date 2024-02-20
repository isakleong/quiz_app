import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sfa_tools/common/app_config.dart';
import 'package:sfa_tools/controllers/coupon_mab_controller.dart';
import 'package:sfa_tools/models/couponmab.dart';
import 'package:sfa_tools/tools/utils.dart';
import 'package:sfa_tools/widgets/textview.dart';

class ApprovalItemDetail extends StatelessWidget {
  final List<CouponMABData> listDataMAB;
  final int index;

  ApprovalItemDetail({super.key, required this.index, required this.listDataMAB});

  final CouponMABController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: Get.height * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              Positioned(
                right: 10,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConfig.darkGreen,
                    elevation: 5,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(10),
                  ),
                  child: const Icon(FontAwesomeIcons.xmark,
                      size: 30, color: Colors.white),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  listDataMAB[index].jenis == null ||
                          listDataMAB[index]
                              .jenis!
                              .toLowerCase()
                              .contains("mab")
                      ? Column(
                          children: [
                            const Center(
                                child: TextView(
                                    headings: "H3",
                                    text: "Insentif Scan Kupon MAB",
                                    fontSize: 16,
                                    color: Colors.black)),
                            const SizedBox(height: 5),
                            Center(
                                child: TextView(
                                    headings: "H3",
                                    text:
                                        "${listDataMAB[index].custID} (${listDataMAB[index].custName})",
                                    fontSize: 16,
                                    color: Colors.black)),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Center(
                                child: TextView(
                                    headings: "H3",
                                    text: "Insentif Karyawan Toko",
                                    fontSize: 16,
                                    color: Colors.black)),
                            const SizedBox(height: 5),
                            Center(
                                child: TextView(
                                    headings: "H3",
                                    text:
                                        "${listDataMAB[index].custID} (${listDataMAB[index].custName})",
                                    fontSize: 16,
                                    color: Colors.black)),
                          ],
                        ),
                  // Utils.decodeImage(listDataMAB[index].stampPhoto.toString())
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(
              color: Colors.grey.shade300,
              thickness: 3,
              height: 3,
              indent: 10,
              endIndent: 10),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextView(
                          headings: "H3",
                          text: "Nama",
                          fontSize: 14,
                          maxLines: 1,
                          isAutoSize: true,
                          textAlign: TextAlign.start),
                      const SizedBox(height: 5),
                      const TextView(
                          headings: "H3",
                          text: "Jenis Kelamin",
                          fontSize: 14,
                          maxLines: 1,
                          isAutoSize: true,
                          textAlign: TextAlign.start),
                      const SizedBox(height: 5),
                      const TextView(
                          headings: "H3",
                          text: "Tempat Lahir",
                          fontSize: 14,
                          maxLines: 1,
                          isAutoSize: true,
                          textAlign: TextAlign.start),
                      const SizedBox(height: 5),
                      const TextView(
                          headings: "H3",
                          text: "Tanggal Lahir",
                          fontSize: 14,
                          maxLines: 1,
                          isAutoSize: true,
                          textAlign: TextAlign.start),
                      const SizedBox(height: 5),
                      const TextView(
                          headings: "H3",
                          text: "Nomor HP",
                          fontSize: 14,
                          maxLines: 1,
                          isAutoSize: true,
                          textAlign: TextAlign.start),
                      const SizedBox(height: 5),
                      listDataMAB[index].jenis!.toLowerCase().contains("karyawan") ?
                      const TextView(
                          headings: "H3",
                          text: "Nomor HP (Lama)",
                          fontSize: 14,
                          maxLines: 1,
                          isAutoSize: true,
                          textAlign: TextAlign.start) : Container(),
                      listDataMAB[index].jenis!.toLowerCase().contains("karyawan") ?
                      const SizedBox(height: 5):Container(),
                      const TextView(
                          headings: "H3",
                          text: "Alamat",
                          fontSize: 14,
                          maxLines: 1,
                          isAutoSize: true,
                          textAlign: TextAlign.start),
                      const SizedBox(height: 5),
                      const TextView(
                          headings: "H3",
                          text: "Provinsi",
                          fontSize: 14,
                          maxLines: 1,
                          isAutoSize: true,
                          textAlign: TextAlign.start),
                      const SizedBox(height: 5),
                      const TextView(
                          headings: "H3",
                          text: "Kota",
                          fontSize: 14,
                          maxLines: 1,
                          isAutoSize: true,
                          textAlign: TextAlign.start),
                      const SizedBox(height: 5),
                      const TextView(
                          headings: "H3",
                          text: "Kecamatan",
                          fontSize: 14,
                          maxLines: 1,
                          isAutoSize: true,
                          textAlign: TextAlign.start),
                      const SizedBox(height: 5),
                      const TextView(
                          headings: "H3",
                          text: "Kelurahan",
                          fontSize: 14,
                          maxLines: 1,
                          isAutoSize: true,
                          textAlign: TextAlign.start),
                      const SizedBox(height: 5),
                      const TextView(
                          headings: "H3",
                          text: "Kode Pos",
                          fontSize: 14,
                          maxLines: 1,
                          isAutoSize: true,
                          textAlign: TextAlign.start),
                    ]),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        listDataMAB[index].namaBelakang != "-"
                            ? TextView(
                                headings: "H3",
                                text:
                                    ":  ${listDataMAB[index].namaDepan} ${listDataMAB[index].namaBelakang}",
                                fontSize: 14,
                                maxLines: 1,
                                isAutoSize: true,
                                textAlign: TextAlign.start)
                            : TextView(
                                headings: "H3",
                                text: ":  ${listDataMAB[index].namaDepan}",
                                fontSize: 14,
                                maxLines: 1,
                                isAutoSize: true,
                                textAlign: TextAlign.start),
                        const SizedBox(height: 5),
                        TextView(
                            headings: "H3",
                            text: ":  ${listDataMAB[index].jenisKelamin}",
                            fontSize: 14,
                            maxLines: 1,
                            isAutoSize: true,
                            textAlign: TextAlign.start),
                        const SizedBox(height: 5),
                        TextView(
                            headings: "H3",
                            text: ":  ${listDataMAB[index].tempatLahir}",
                            fontSize: 14,
                            maxLines: 1,
                            isAutoSize: true,
                            textAlign: TextAlign.start),
                        const SizedBox(height: 5),
                        TextView(
                            headings: "H3",
                            text:
                                ":  ${DateFormat("dd-MM-yyyy").format(DateTime.parse(listDataMAB[index].tanggalLahir!))}",
                            fontSize: 14,
                            maxLines: 1,
                            isAutoSize: true,
                            textAlign: TextAlign.start),
                        const SizedBox(height: 5),
                        TextView(
                            headings: "H3",
                            text: ":  ${listDataMAB[index].noHp}",
                            fontSize: 14,
                            maxLines: 1,
                            isAutoSize: true,
                            textAlign: TextAlign.start),
                        listDataMAB[index].jenis!.toLowerCase().contains("toko") ?
                        TextView(
                            headings: "H3",
                            text: ":  ${listDataMAB[index].noLama}",
                            fontSize: 14,
                            maxLines: 1,
                            isAutoSize: true,
                            textAlign: TextAlign.start) : Container(),
                        listDataMAB[index].jenis!.toLowerCase().contains("toko") ? const SizedBox(height: 5) : Container(),
                        TextView(
                            headings: "H3",
                            text: ":  ${listDataMAB[index].alamat}",
                            fontSize: 14,
                            maxLines: 1,
                            isAutoSize: true,
                            textAlign: TextAlign.start),
                        const SizedBox(height: 5),
                        TextView(
                            headings: "H3",
                            text: ":  ${listDataMAB[index].provinsi}",
                            fontSize: 14,
                            maxLines: 1,
                            isAutoSize: true,
                            textAlign: TextAlign.start),
                        const SizedBox(height: 5),
                        TextView(
                            headings: "H3",
                            text: ":  ${listDataMAB[index].kota}",
                            fontSize: 14,
                            maxLines: 1,
                            isAutoSize: true,
                            textAlign: TextAlign.start),
                        const SizedBox(height: 5),
                        TextView(
                            headings: "H3",
                            text: ":  ${listDataMAB[index].kecamatan}",
                            fontSize: 14,
                            maxLines: 1,
                            isAutoSize: true,
                            textAlign: TextAlign.start),
                        const SizedBox(height: 5),
                        TextView(
                            headings: "H3",
                            text: ":  ${listDataMAB[index].kelurahan}",
                            fontSize: 14,
                            maxLines: 1,
                            isAutoSize: true,
                            textAlign: TextAlign.start),
                        const SizedBox(height: 5),
                        TextView(
                            headings: "H3",
                            text: ":  ${listDataMAB[index].kodePos}",
                            fontSize: 14,
                            maxLines: 1,
                            isAutoSize: true,
                            textAlign: TextAlign.start),
                      ]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Divider(
              color: Colors.grey.shade300,
              thickness: 3,
              height: 3,
              indent: 10,
              endIndent: 10),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Utils.decodeImage(listDataMAB[index].stampPhoto.toString()),
                    const TextView(
                        headings: "H3",
                        text: "Stamp Toko",
                        fontSize: 14,
                        maxLines: 1,
                        isAutoSize: true,
                        textAlign: TextAlign.start),
                  ],
                ),
                Column(
                  children: [
                    Utils.decodeImage(listDataMAB[index].signature.toString()),
                    const TextView(
                        headings: "H3",
                        text: "TTD",
                        fontSize: 14,
                        maxLines: 1,
                        isAutoSize: true,
                        textAlign: TextAlign.start),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if(listDataMAB[index].jenis!.toLowerCase() == 'kupon') {
                        Utils().showConfirmationDialog(context, "reject", "Konfirmasi Tolak Pendaftaran Insentif Kupon MAB", "Apakah Anda yakin tolak pengajuan toko \n${listDataMAB[index].custName} (${listDataMAB[index].custID})?", () {
                          controller.approvalData(listDataMAB[index].id.toString(), false);
                        });
                      } else {
                        Utils().showConfirmationDialog(context, "reject", "Konfirmasi Tolak Pendaftaran Insentif Karyawan Toko", "Apakah Anda yakin tolak pengajuan toko \n${listDataMAB[index].custName} (${listDataMAB[index].custID})?", () {
                          controller.approvalData(listDataMAB[index].id.toString(), false);
                        });
                      }
                      // await controller.approvalData(
                      //     listDataMAB[index].id.toString(), false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      elevation: 5,
                      padding: const EdgeInsets.all(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        TextView(
                            headings: "H2",
                            text: "tolak",
                            fontSize: 14,
                            color: Colors.white,
                            isCapslock: true),
                        SizedBox(width: 8),
                        FaIcon(FontAwesomeIcons.xmark,
                            color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if(listDataMAB[index].jenis!.toLowerCase() == 'kupon') {
                        Utils().showConfirmationDialog(context, "accept", "Konfirmasi Terima Pendaftaran Insentif Kupon MAB", "Apakah Anda yakin terima pengajuan toko \n${listDataMAB[index].custName} (${listDataMAB[index].custID})?", () {
                          controller.approvalData(listDataMAB[index].id.toString(), true);
                        });
                      } else {
                        Utils().showConfirmationDialog(context, "accept", "Konfirmasi Terima Pendaftaran Insentif Karyawan Toko", "Apakah Anda yakin terima pengajuan toko \n${listDataMAB[index].custName} (${listDataMAB[index].custID})?", () {
                          controller.approvalData(listDataMAB[index].id.toString(), true);
                        });
                      }

                      
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade700,
                      elevation: 5,
                      padding: const EdgeInsets.all(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        TextView(
                            headings: "H2",
                            text: "terima",
                            fontSize: 14,
                            color: Colors.white,
                            isCapslock: true),
                        SizedBox(width: 8),
                        FaIcon(FontAwesomeIcons.checkToSlot,
                            color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
