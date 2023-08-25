
import 'package:hive/hive.dart';

part 'detailproductdata.g.dart';

@HiveType(typeId: 10)
class DetailProductData {
  @HiveField(0)
  String satuan;

  @HiveField(1)
  String id;

  @HiveField(2)
  double hrg;

  DetailProductData(this.satuan, this.hrg, this.id);
}