// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'penjualanpostmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PenjualanPostModelAdapter extends TypeAdapter<PenjualanPostModel> {
  @override
  final int typeId = 7;

  @override
  PenjualanPostModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PenjualanPostModel(
      (fields[0] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, PenjualanPostModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.dataList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PenjualanPostModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
