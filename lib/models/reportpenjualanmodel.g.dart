// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reportpenjualanmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReportPenjualanModelAdapter extends TypeAdapter<ReportPenjualanModel> {
  @override
  final int typeId = 6;

  @override
  ReportPenjualanModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReportPenjualanModel(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      (fields[6] as List).cast<CartDetail>(),
      fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ReportPenjualanModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.condition)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.jenis)
      ..writeByte(3)
      ..write(obj.tanggal)
      ..writeByte(4)
      ..write(obj.waktu)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.listItem);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportPenjualanModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
