// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AnggotaModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnggotaModel _$AnggotaModelFromJson(Map<String, dynamic> json) {
  return AnggotaModel(
      id: json['_id'] as String,
      noAnggota: json['noAnggota'] as String,
      statusDalamKeluarga: json['statusDalamKeluarga'] as String,
      statusPernikahan: json['statusPernikahan'] as String,
      salut: json['salut'] as String,
      gelarDepan: json['gelarDepan'] as String,
      namaDepan: json['namaDepan'] as String,
      namaPanggilan: json['namaPanggilan'] as String,
      namaKeluarga: json['namaKeluarga'] as String,
      gelarBelakang: json['gelarBelakang'] as String,
      jenisKelamin: json['jenisKelamin'] as String,
      alamat: json['alamat'] as String,
      idKeluarga: json['_idKeluarga'] as String,
      tglBaptis: json['tglBaptis'] == null
          ? null
          : DateTime.parse(json['tglBaptis'] as String),
      tglLahir: json['tglLahir'] == null
          ? null
          : DateTime.parse(json['tglLahir'] as String),
      pekerjaan: json['pekerjaan'] as String,
      bidangPekerjaan: json['bidangPekerjaan'] as String,
      noTelpon: json['noTelpon'] as String,
      email: json['email'] as String,
      idUser: json['_idUser'] as String,
      fotoProfil: json['fotoProfil'] as String,
      minat: json['minat'] as List,
      keahlian: json['keahlian'] as List,
      selected: json['selected'] as bool);
}

Map<String, dynamic> _$AnggotaModelToJson(AnggotaModel instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('noAnggota', instance.noAnggota);
  writeNotNull('statusDalamKeluarga', instance.statusDalamKeluarga);
  writeNotNull('statusPernikahan', instance.statusPernikahan);
  writeNotNull('salut', instance.salut);
  writeNotNull('gelarDepan', instance.gelarDepan);
  val['namaDepan'] = instance.namaDepan;
  writeNotNull('namaPanggilan', instance.namaPanggilan);
  writeNotNull('namaKeluarga', instance.namaKeluarga);
  writeNotNull('gelarBelakang', instance.gelarBelakang);
  writeNotNull('jenisKelamin', instance.jenisKelamin);
  writeNotNull('alamat', instance.alamat);
  val['_idKeluarga'] = instance.idKeluarga;
  writeNotNull('tglBaptis', instance.tglBaptis?.toIso8601String());
  writeNotNull('tglLahir', instance.tglLahir?.toIso8601String());
  writeNotNull('pekerjaan', instance.pekerjaan);
  writeNotNull('bidangPekerjaan', instance.bidangPekerjaan);
  writeNotNull('noTelpon', instance.noTelpon);
  writeNotNull('email', instance.email);
  writeNotNull('_idUser', instance.idUser);
  writeNotNull('fotoProfil', instance.fotoProfil);
  writeNotNull('minat', instance.minat);
  writeNotNull('keahlian', instance.keahlian);
  val['selected'] = instance.selected;
  return val;
}
