
import 'package:hive/hive.dart';
part 'cartmodel.g.dart';

@HiveType(typeId: 9)
class CartModel extends HiveObject {
  @HiveField(0)
  String kdProduct;

  @HiveField(1)
  String nmProduct;

  @HiveField(2)
  // ignore: non_constant_identifier_names
  int Qty;

  @HiveField(3)
  // ignore: non_constant_identifier_names
  String Satuan;

  @HiveField(4)
  double hrgPerPieces;

  @HiveField(5)
  String iduom;

  @HiveField(6)
  String iditem;

  @HiveField(7)
  String komisi;

  CartModel(this.kdProduct, this.nmProduct, this.Qty, this.Satuan, this.hrgPerPieces, this.iduom, this.iditem, this.komisi);

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      json['kdProduct'] as String,
      json['nmProduct'] as String,
      json['Qty'] as int,
      json['Satuan'] as String,
      json['hrgPerPieces'] as double,
      json['iduom'] as String,
      json['iditem'] as String,
      json['komisi'] as String
    );
  }
}