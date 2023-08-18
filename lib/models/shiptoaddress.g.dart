// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shiptoaddress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShipToAddressAdapter extends TypeAdapter<ShipToAddress> {
  @override
  final int typeId = 4;

  @override
  ShipToAddress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShipToAddress(
      code: fields[0] as String,
      name: fields[1] as String,
      address: fields[2] as String,
      county: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShipToAddress obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.county);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShipToAddressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShipToAddress _$ShipToAddressFromJson(Map<String, dynamic> json) =>
    ShipToAddress(
      code: json['code'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      county: json['county'] as String,
    );

Map<String, dynamic> _$ShipToAddressToJson(ShipToAddress instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'address': instance.address,
      'county': instance.county,
    };
