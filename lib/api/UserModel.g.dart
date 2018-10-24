// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
      id: json['_id'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      userName: json['userName'] as String,
      password: json['password'] as String,
      mottoStatus: json['mottoStatus'] as String,
      userLevel: json['userLevel'] as String,
      token: json['token'] as String,
      fotoProfil: json['fotoProfil'] as String);
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  val['userName'] = instance.userName;
  val['email'] = instance.email;
  val['password'] = instance.password;
  val['phoneNumber'] = instance.phoneNumber;
  val['mottoStatus'] = instance.mottoStatus;
  val['userLevel'] = instance.userLevel;
  val['token'] = instance.token;
  writeNotNull('fotoProfil', instance.fotoProfil);
  return val;
}
