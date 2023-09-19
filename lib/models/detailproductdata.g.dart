// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detailproductdata.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DetailProductDataAdapter extends TypeAdapter<DetailProductData> {
  @override
  final int typeId = 10;

  @override
  DetailProductData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DetailProductData(
      fields[0] as String,
      fields[2] as double,
      fields[1] as String,
      fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DetailProductData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.satuan)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.hrg)
      ..writeByte(3)
      ..write(obj.komisi);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DetailProductDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
