// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuizConfigAdapter extends TypeAdapter<QuizConfig> {
  @override
  final int typeId = 12;

  @override
  QuizConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizConfig(
      branchCode: fields[1] as String,
      name: fields[2] as String,
      description: fields[3] as String,
      value: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, QuizConfig obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.branchCode)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizConfig _$QuizConfigFromJson(Map<String, dynamic> json) => QuizConfig(
      branchCode: json['BranchCode'] as String,
      name: json['Name'] as String,
      description: json['Description'] as String,
      value: json['Value'] as String,
    );

Map<String, dynamic> _$QuizConfigToJson(QuizConfig instance) =>
    <String, dynamic>{
      'BranchCode': instance.branchCode,
      'Name': instance.name,
      'Description': instance.description,
      'Value': instance.value,
    };
