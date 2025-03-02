// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RequestAdapter extends TypeAdapter<Request> {
  @override
  final int typeId = 0;

  @override
  Request read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Request(
      title: fields[0] as String,
      method: fields[1] as String,
      path: fields[2] as String,
      body: fields[3] as String,
      headers: (fields[4] as Map).cast<String, String>(),
      auth: (fields[5] as Map).cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Request obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.method)
      ..writeByte(2)
      ..write(obj.path)
      ..writeByte(3)
      ..write(obj.body)
      ..writeByte(4)
      ..write(obj.headers)
      ..writeByte(5)
      ..write(obj.auth);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
