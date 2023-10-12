import 'package:hive/hive.dart';

late Box vendorBox; //box list vendor customer
late Box branchinfobox; //box info branch user
late Box customerBox; //box data customer
late Box outstandingBox; //box data outstanding
late Box piutangBox; //box informasi piutang
late Box shiptobox; //box alamat customer
late Box tokenbox; //box token user
late Box bankbox; //box bank data
late Box paymentMethodsBox; //box payment methods
late Box devicestatebox; //box device state untuk sinkronisasi state

late Box boxpostpenjualan; //box data post body penjualan
late Box postpembayaranbox; //box data post body pembayaran
late Box boxreportpenjualan; //box laporan data penjualan
late Box boxPembayaranReport; //box laporan data pembayaran

late Box statePenjualanbox; // box state penjualan, untuk menyimpan data input user
late Box boxPembayaranState; // box state pembayaran, untuk menyimpan data input user
late Box itemvendorbox; //box item vendor
late Box masteritemvendorbox; // box master item vendor
late Box masteritembox; //box item dengan subdis
late Box mastervendorbox; //box list vendor master
