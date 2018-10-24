// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'KelompokModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KelompokModel _$KelompokModelFromJson(Map<String, dynamic> json) {
  return KelompokModel(
      id: json['_id'] as String,
      namaKelompok: json['namaKelompok'] as String,
      tujuanKelompok: json['tujuanKelompok'] as String,
      ketKelompok: json['ketKelompok'] as String,
      jenisKelompok: json['jenisKelompok'] as String,
      tglDibentuk: json['tglDibentuk'] == null
          ? null
          : DateTime.parse(json['tglDibentuk'] as String),
      anggotaKelompok: (json['anggotaKelompok'] as List)
          ?.map((e) => e == null
              ? null
              : KelompokAnggotaModel.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      idPemimpinKelompok: json['idPemimpinKelompok'] == null
          ? null
          : AnggotaModel.fromJson(
              json['idPemimpinKelompok'] as Map<String, dynamic>),
      fotoProfil: json['fotoProfil'] as String);
}

Map<String, dynamic> _$KelompokModelToJson(KelompokModel instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('namaKelompok', instance.namaKelompok);
  writeNotNull('tujuanKelompok', instance.tujuanKelompok);
  writeNotNull('ketKelompok', instance.ketKelompok);
  writeNotNull('jenisKelompok', instance.jenisKelompok);
  writeNotNull('tglDibentuk', instance.tglDibentuk?.toIso8601String());
  writeNotNull('idPemimpinKelompok', instance.idPemimpinKelompok);
  writeNotNull('fotoProfil', instance.fotoProfil);
  writeNotNull('anggotaKelompok', instance.anggotaKelompok);
  return val;
}
