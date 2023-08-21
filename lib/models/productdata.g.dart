// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productdata.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductDataAdapter extends TypeAdapter<ProductData> {
  @override
  final int typeId = 11;

  @override
  ProductData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductData(
      fields[0] as String,
      fields[1] as String,
      (fields[2] as List).cast<DetailProductData>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.kdProduct)
      ..writeByte(1)
      ..write(obj.nmProduct)
      ..writeByte(2)
      ..write(obj.detailProduct);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
