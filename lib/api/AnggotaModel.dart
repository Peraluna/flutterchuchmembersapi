import 'package:json_annotation/json_annotation.dart';

part 'AnggotaModel.g.dart';

@JsonSerializable()
class AnggotaModel {
  AnggotaModel({
    this.id,
    this.noAnggota,
    this.statusDalamKeluarga,
    this.statusPernikahan,
    this.salut,
    this.gelarDepan,
    this.namaDepan,
    this.namaPanggilan,
    this.namaKeluarga,
    this.gelarBelakang,
    this.jenisKelamin,
    this.alamat,
    this.idKeluarga,
    this.tglBaptis,
    this.tglLahir,
    this.pekerjaan,
    this.bidangPekerjaan,
    this.noTelpon,
    this.email,
    this.idUser,
    this.fotoProfil,
    this.minat,
    this.keahlian,
    bool selected,
  }) : selected = selected ?? false;
  @JsonKey(name: '_id', includeIfNull: false)
  String id;
  @JsonKey(includeIfNull: false)
  String noAnggota;
  @JsonKey(includeIfNull: false)
  String statusDalamKeluarga;
  @JsonKey(includeIfNull: false)
  String statusPernikahan;
  @JsonKey(includeIfNull: false)
  String salut;
  @JsonKey(includeIfNull: false)
  String gelarDepan;
  //@JsonKey(includeIfNull: false)
  @JsonKey(nullable: false)
  String namaDepan;
  @JsonKey(includeIfNull: false)
  String namaPanggilan;
  @JsonKey(includeIfNull: false)
  String namaKeluarga;
  @JsonKey(includeIfNull: false)
  String gelarBelakang;
  @JsonKey(includeIfNull: false)
  String jenisKelamin;
  @JsonKey(includeIfNull: false)
  String alamat;

  @JsonKey(name: '_idKeluarga')
  @JsonKey(includeIfNull: false)
  String idKeluarga;
  @JsonKey(includeIfNull: false)
  DateTime tglBaptis;
  @JsonKey(includeIfNull: false)
  DateTime tglLahir;
  @JsonKey(includeIfNull: false)
  String pekerjaan;
  @JsonKey(includeIfNull: false)
  String bidangPekerjaan;
  @JsonKey(includeIfNull: false)
  String noTelpon;
  @JsonKey(includeIfNull: false)
  String email;

  @JsonKey(name: '_idUser', includeIfNull: false)
  String idUser;
  @JsonKey(includeIfNull: false)
  String fotoProfil;
  @JsonKey(includeIfNull: false)
  List minat;
  @JsonKey(includeIfNull: false)
  List keahlian;
  bool selected;

  factory AnggotaModel.fromJson(Map<String, dynamic> json) =>
      _$AnggotaModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnggotaModelToJson(this);

  //AnggotaModel copy(AnggotaModel fromAnggota) => _$AnggotaModelCopy(this);
  AnggotaModel copy() {
    //var copiedAnggota = new Map.from(this.toJson());
    var _copiedAnggota = _$AnggotaModelFromJson(this.toJson());
    return _copiedAnggota;
  }

  AnggotaModel clone() {
    AnggotaModel clonedModel;
    clonedModel = new AnggotaModel(
      id: this.id,
      noAnggota: this.noAnggota,
      statusDalamKeluarga: this.statusDalamKeluarga,
      statusPernikahan: this.statusPernikahan,
      salut: this.salut,
      gelarDepan: this.gelarDepan,
      namaDepan: this.namaDepan,
      namaPanggilan: this.namaPanggilan,
      namaKeluarga: this.namaKeluarga,
      gelarBelakang: this.gelarBelakang,
      jenisKelamin: this.jenisKelamin,
      alamat: this.alamat,
      idKeluarga: this.idKeluarga,
      tglBaptis: this.tglBaptis,
      tglLahir: this.tglLahir,
      pekerjaan: this.pekerjaan,
      bidangPekerjaan: this.bidangPekerjaan,
      noTelpon: this.noTelpon,
      email: this.email,
      idUser: this.idUser,
      fotoProfil: this.fotoProfil,
      minat: new List.from(this.minat),
      keahlian: new List.from(this.keahlian),
    );
    return clonedModel;
  }

//     AnggotaModel _$AnggotaModelCopy(AnggotaModel instance) {
//   AnggotaModel newAnggota = new AnggotaModel();
//   newAnggota.id=instance.id;
// newAnggota.noAnggota= instance.noAnggota;
//     newAnggota.statusDalamKeluarga= instance.statusDalamKeluarga;
//     newAnggota.statusPernikahan= instance.statusPernikahan;
//     newAnggota.salut= instance.salut;
//     newAnggota.gelarDepan= instance.gelarDepan;
//     newAnggota.namaDepan= instance.namaDepan;
//    newAnggota.namaPanggilan= instance.namaPanggilan;
//   newAnggota.namaKeluarga= instance.namaKeluarga;
//     newAnggota.gelarBelakang= instance.gelarBelakang;
//    newAnggota.jenisKelamin= instance.jenisKelamin;
//    newAnggota.alamat= instance.alamat;
//    newAnggota.idKeluarga= instance.idKeluarga;
//    newAnggota.tglBaptis= instance.tglBaptis;
//    newAnggota.tglLahir= instance.tglLahir;
//     newAnggota.pekerjaan= instance.pekerjaan;
//    newAnggota.bidangPekerjaan= instance.bidangPekerjaan;
//    newAnggota.noTelpon= instance.noTelpon;
//     newAnggota.email= instance.email;
//   return newAnggota;
// }
}

// flutter packages pub run build_runner build --delete-conflicting-outputs
