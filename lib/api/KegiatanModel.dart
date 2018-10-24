import 'AnggotaModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'KegiatanModel.g.dart';

@JsonSerializable()
class KegiatanModel {
  KegiatanModel({
    this.id,
    this.ketKegiatan,
    this.ketKegiatanPendek,
    this.namaPenanggungJawab,
    this.namaPembicara,
    this.ketPembawaAcara,
    this.lokasi,
    this.fotoProfil,
    this.rincianKegiatan,
    this.anggotaPengurus,
   this.jumlahPersembahan,
  this.jumlahPerpuluhan,
  this.jumlahSumbangan,
  this.jumlahPengeluaran,
  this.anggotaTerdaftar,
  this.fotoFoto,
 this.youTubeTrailers,
    
  });
  @JsonKey(name: '_id')
  final String id;
  final String ketKegiatan;
   final String ketKegiatanPendek;
  final String ketPembawaAcara;
  final String lokasi;
  final String namaPenanggungJawab;
  final String namaPembicara;
  final double jumlahPersembahan;
  final double jumlahPerpuluhan;
  final double jumlahSumbangan;
  final double jumlahPengeluaran;
  final String fotoProfil;
  final List<AnggotaModel> rincianKegiatan;
  final List<AnggotaPengurusModel> anggotaPengurus;
  final List<AnggotaTerdaftarModel> anggotaTerdaftar;
  final List<String> fotoFoto;
  final List<String> youTubeTrailers;

   factory KegiatanModel.fromJson(Map<String, dynamic> json) =>
      _$KegiatanModelFromJson(json);

        Map<String, dynamic> toJson() => _$KegiatanModelToJson(this);
 KegiatanModel copy()  {
      //var copiedAnggota = new Map.from(this.toJson());
      var _copiedKegiatan =_$KegiatanModelFromJson( this.toJson()) ;
       return _copiedKegiatan;
     }
}

@JsonSerializable()
class RincianKegiatanModel {
  RincianKegiatanModel({
    this.id,
    this.ketKegiatan,
    
    this.ketPembawaAcara,
    this.jamMulai,
    this.jamSelesai,
    

    
  });
  @JsonKey(name: '_id')
  final String id;
  final String ketKegiatan;
 
  final String ketPembawaAcara;
  final String jamMulai;
  final String jamSelesai;
  
   

   factory RincianKegiatanModel.fromJson(Map<String, dynamic> json) =>
      _$RincianKegiatanModelFromJson(json);

        Map<String, dynamic> toJson() => _$RincianKegiatanModelToJson(this);
 RincianKegiatanModel copy()  {
      //var copiedAnggota = new Map.from(this.toJson());
      var _copiedKegiatan =_$RincianKegiatanModelFromJson( this.toJson()) ;
       return _copiedKegiatan;
     }
}

@JsonSerializable()
class AnggotaPengurusModel {
  AnggotaPengurusModel({
    this.id,
    this.idAnggota,
    
    this.jabatan,
    
    this.hadir,
    this.tglHadir,
    this.tglKonfirmasi,

    
  });
  @JsonKey(name: '_id')
  final String id;
   @JsonKey(name: '_idAnggota')
  final String idAnggota;
 
  final String jabatan;
  
  final bool hadir;
  final DateTime tglHadir;
  final DateTime tglKonfirmasi;

   

   factory AnggotaPengurusModel.fromJson(Map<String, dynamic> json) =>
      _$AnggotaPengurusModelFromJson(json);

        Map<String, dynamic> toJson() => _$AnggotaPengurusModelToJson(this);
 AnggotaPengurusModel copy()  {
      //var copiedAnggota = new Map.from(this.toJson());
      var _copiedKegiatan =_$AnggotaPengurusModelFromJson( this.toJson()) ;
       return _copiedKegiatan;
     }
}


@JsonSerializable()
class AnggotaTerdaftarModel {
  AnggotaTerdaftarModel({
    this.id,
    this.idAnggota,
   
   
    this.tglDaftar,
    this.hadir,
    this.tglHadir,
   

    
  });
  @JsonKey(name: '_id')
  final String id;
   @JsonKey(name: '_idAnggota')
  final String idAnggota;
 
  final DateTime tglDaftar;
  final bool hadir;
  final DateTime tglHadir;
   

   

   factory AnggotaTerdaftarModel.fromJson(Map<String, dynamic> json) =>
      _$AnggotaTerdaftarModelFromJson(json);

        Map<String, dynamic> toJson() => _$AnggotaTerdaftarModelToJson(this);
 AnggotaTerdaftarModel copy()  {
      //var copiedAnggota = new Map.from(this.toJson());
      var _copiedKegiatan =_$AnggotaTerdaftarModelFromJson( this.toJson()) ;
       return _copiedKegiatan;
     }
}
