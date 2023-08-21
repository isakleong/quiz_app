// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cartdetail.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartDetailAdapter extends TypeAdapter<CartDetail> {
  @override
  final int typeId = 8;

  @override
  CartDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartDetail(
      fields[0] as String,
      fields[1] as String,
      (fields[2] as List).cast<CartModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, CartDetail obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.kdProduct)
      ..writeByte(1)
      ..write(obj.nmProduct)
      ..writeByte(2)
      ..write(obj.itemOrder);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
