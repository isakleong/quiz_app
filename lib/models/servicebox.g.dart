// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'servicebox.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceBoxAdapter extends TypeAdapter<ServiceBox> {
  @override
  final int typeId = 2;

  @override
  ServiceBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceBox(
      value: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ServiceBox obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
