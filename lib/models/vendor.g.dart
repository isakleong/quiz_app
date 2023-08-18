// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VendorAdapter extends TypeAdapter<Vendor> {
  @override
  final int typeId = 5;

  @override
  Vendor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Vendor(
      prefix: fields[0] as String,
      name: fields[1] as String,
      baseApiUrl: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Vendor obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.prefix)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.baseApiUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VendorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vendor _$VendorFromJson(Map<String, dynamic> json) => Vendor(
      prefix: json['prefix'] as String,
      name: json['name'] as String,
      baseApiUrl: json['baseApiUrl'] as String,
    );

Map<String, dynamic> _$VendorToJson(Vendor instance) => <String, dynamic>{
      'prefix': instance.prefix,
      'name': instance.name,
      'baseApiUrl': instance.baseApiUrl,
    };
