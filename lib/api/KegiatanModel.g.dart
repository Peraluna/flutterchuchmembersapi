// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'KegiatanModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KegiatanModel _$KegiatanModelFromJson(Map<String, dynamic> json) {
  return KegiatanModel(
      id: json['_id'] as String,
      ketKegiatan: json['ketKegiatan'] as String,
      ketKegiatanPendek: json['ketKegiatanPendek'] as String,
      namaPenanggungJawab: json['namaPenanggungJawab'] as String,
      namaPembicara: json['namaPembicara'] as String,
      ketPembawaAcara: json['ketPembawaAcara'] as String,
      lokasi: json['lokasi'] as String,
      fotoProfil: json['fotoProfil'] as String,
      rincianKegiatan: (json['rincianKegiatan'] as List)
          ?.map((e) => e == null
              ? null
              : AnggotaModel.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      anggotaPengurus: (json['anggotaPengurus'] as List)
          ?.map((e) => e == null
              ? null
              : AnggotaPengurusModel.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      jumlahPersembahan: (json['jumlahPersembahan'] as num)?.toDouble(),
      jumlahPerpuluhan: (json['jumlahPerpuluhan'] as num)?.toDouble(),
      jumlahSumbangan: (json['jumlahSumbangan'] as num)?.toDouble(),
      jumlahPengeluaran: (json['jumlahPengeluaran'] as num)?.toDouble(),
      anggotaTerdaftar: (json['anggotaTerdaftar'] as List)
          ?.map((e) => e == null
              ? null
              : AnggotaTerdaftarModel.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      fotoFoto: (json['fotoFoto'] as List)?.map((e) => e as String)?.toList(),
      youTubeTrailers:
          (json['youTubeTrailers'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$KegiatanModelToJson(KegiatanModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'ketKegiatan': instance.ketKegiatan,
      'ketKegiatanPendek': instance.ketKegiatanPendek,
      'ketPembawaAcara': instance.ketPembawaAcara,
      'lokasi': instance.lokasi,
      'namaPenanggungJawab': instance.namaPenanggungJawab,
      'namaPembicara': instance.namaPembicara,
      'jumlahPersembahan': instance.jumlahPersembahan,
      'jumlahPerpuluhan': instance.jumlahPerpuluhan,
      'jumlahSumbangan': instance.jumlahSumbangan,
      'jumlahPengeluaran': instance.jumlahPengeluaran,
      'fotoProfil': instance.fotoProfil,
      'rincianKegiatan': instance.rincianKegiatan,
      'anggotaPengurus': instance.anggotaPengurus,
      'anggotaTerdaftar': instance.anggotaTerdaftar,
      'fotoFoto': instance.fotoFoto,
      'youTubeTrailers': instance.youTubeTrailers
    };

RincianKegiatanModel _$RincianKegiatanModelFromJson(Map<String, dynamic> json) {
  return RincianKegiatanModel(
      id: json['_id'] as String,
      ketKegiatan: json['ketKegiatan'] as String,
      ketPembawaAcara: json['ketPembawaAcara'] as String,
      jamMulai: json['jamMulai'] as String,
      jamSelesai: json['jamSelesai'] as String);
}

Map<String, dynamic> _$RincianKegiatanModelToJson(
        RincianKegiatanModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'ketKegiatan': instance.ketKegiatan,
      'ketPembawaAcara': instance.ketPembawaAcara,
      'jamMulai': instance.jamMulai,
      'jamSelesai': instance.jamSelesai
    };

AnggotaPengurusModel _$AnggotaPengurusModelFromJson(Map<String, dynamic> json) {
  return AnggotaPengurusModel(
      id: json['_id'] as String,
      idAnggota: json['_idAnggota'] as String,
      jabatan: json['jabatan'] as String,
      hadir: json['hadir'] as bool,
      tglHadir: json['tglHadir'] == null
          ? null
          : DateTime.parse(json['tglHadir'] as String),
      tglKonfirmasi: json['tglKonfirmasi'] == null
          ? null
          : DateTime.parse(json['tglKonfirmasi'] as String));
}

Map<String, dynamic> _$AnggotaPengurusModelToJson(
        AnggotaPengurusModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      '_idAnggota': instance.idAnggota,
      'jabatan': instance.jabatan,
      'hadir': instance.hadir,
      'tglHadir': instance.tglHadir?.toIso8601String(),
      'tglKonfirmasi': instance.tglKonfirmasi?.toIso8601String()
    };

AnggotaTerdaftarModel _$AnggotaTerdaftarModelFromJson(
    Map<String, dynamic> json) {
  return AnggotaTerdaftarModel(
      id: json['_id'] as String,
      idAnggota: json['_idAnggota'] as String,
      tglDaftar: json['tglDaftar'] == null
          ? null
          : DateTime.parse(json['tglDaftar'] as String),
      hadir: json['hadir'] as bool,
      tglHadir: json['tglHadir'] == null
          ? null
          : DateTime.parse(json['tglHadir'] as String));
}

Map<String, dynamic> _$AnggotaTerdaftarModelToJson(
        AnggotaTerdaftarModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      '_idAnggota': instance.idAnggota,
      'tglDaftar': instance.tglDaftar?.toIso8601String(),
      'hadir': instance.hadir,
      'tglHadir': instance.tglHadir?.toIso8601String()
    };
