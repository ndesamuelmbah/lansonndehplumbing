// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_auth_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FirebaseAuthUserAdapter extends TypeAdapter<FirebaseAuthUser> {
  @override
  final int typeId = 16;

  @override
  FirebaseAuthUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FirebaseAuthUser(
      uid: fields[0] as String,
      email: fields[1] as String,
      displayName: fields[2] as String?,
      photoUrl: fields[3] as String?,
      providers: (fields[7] as List).cast<CustomAuthProvider>(),
      creationTime: fields[5] as int,
      customClaims: (fields[6] as Map?)?.cast<String, dynamic>(),
      emailVerified: fields[4] as bool,
      phoneNumber: fields[9] as String,
      currentOrderId: fields[10] as String?,
      isAdmin: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FirebaseAuthUser obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.displayName)
      ..writeByte(3)
      ..write(obj.photoUrl)
      ..writeByte(4)
      ..write(obj.emailVerified)
      ..writeByte(5)
      ..write(obj.creationTime)
      ..writeByte(6)
      ..write(obj.customClaims)
      ..writeByte(7)
      ..write(obj.providers)
      ..writeByte(8)
      ..write(obj.isAdmin)
      ..writeByte(9)
      ..write(obj.phoneNumber)
      ..writeByte(10)
      ..write(obj.currentOrderId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FirebaseAuthUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
