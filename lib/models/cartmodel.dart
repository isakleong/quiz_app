
import 'package:hive/hive.dart';
part 'cartmodel.g.dart';

@HiveType(typeId: 9)
class CartModel extends HiveObject {
  @HiveField(0)
  String kdProduct;

  @HiveField(1)
  String nmProduct;

  @HiveField(2)
  int Qty;

  @HiveField(3)
  String Satuan;

  @HiveField(4)
  double hrgPerPieces;

  CartModel(this.kdProduct, this.nmProduct, this.Qty, this.Satuan, this.hrgPerPieces);

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      json['kdProduct'] as String,
      json['nmProduct'] as String,
      json['Qty'] as int,
      json['Satuan'] as String,
      json['hrgPerPieces'] as double,
    );
  }
}