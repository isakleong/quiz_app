// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_box.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConfigBoxAdapter extends TypeAdapter<ConfigBox> {
  @override
  final int typeId = 3;

  @override
  ConfigBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConfigBox(
      value: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ConfigBox obj) {
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
      other is ConfigBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
