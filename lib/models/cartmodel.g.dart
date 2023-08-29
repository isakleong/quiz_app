// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cartmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartModelAdapter extends TypeAdapter<CartModel> {
  @override
  final int typeId = 9;

  @override
  CartModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartModel(
      fields[0] as String,
      fields[1] as String,
      fields[2] as int,
      fields[3] as String,
      fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CartModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.kdProduct)
      ..writeByte(1)
      ..write(obj.nmProduct)
      ..writeByte(2)
      ..write(obj.Qty)
      ..writeByte(3)
      ..write(obj.Satuan)
      ..writeByte(4)
      ..write(obj.hrgPerPieces);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}