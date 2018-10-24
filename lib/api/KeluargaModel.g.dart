// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'KeluargaModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KeluargaModel _$KeluargaModelFromJson(Map<String, dynamic> json) {
  return KeluargaModel(
      id: json['_id'] as String,
      namaKeluarga: json['namaKeluarga'] as String,
      alamat: json['alamat'] as String,
      fotoProfil: json['fotoProfil'] as String,
      anggotaKeluarga: (json['anggotaKeluarga'] as List)
          ?.map((e) => e == null
              ? null
              : AnggotaModel.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$KeluargaModelToJson(KeluargaModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'namaKeluarga': instance.namaKeluarga,
      'alamat': instance.alamat,
      'fotoProfil': instance.fotoProfil,
      'anggotaKeluarga': instance.anggotaKeluarga
    };
