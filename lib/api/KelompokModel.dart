import 'package:json_annotation/json_annotation.dart';
import './AnggotaModel.dart';

part 'KelompokModel.g.dart';

@JsonSerializable()
class KelompokModel {
  KelompokModel({
    this.id,
    this.namaKelompok,
    this.tujuanKelompok,
    this.ketKelompok,
    this.jenisKelompok,
    this.tglDibentuk,
    List<KelompokAnggotaModel> anggotaKelompok,
    this.idPemimpinKelompok,
    this.fotoProfil,
  });
  //}) : anggotaKelompok = anggotaKelompok ?? <KelompokAnggotaModel>[];

  @JsonKey(name: '_id', includeIfNull: false)
  String id;
  @JsonKey(includeIfNull: false)
  String namaKelompok;
  @JsonKey(includeIfNull: false)
  String tujuanKelompok;
  @JsonKey(includeIfNull: false)
  String ketKelompok;
  @JsonKey(includeIfNull: false)
  String jenisKelompok;
  @JsonKey(includeIfNull: false)
  DateTime tglDibentuk;
  @JsonKey(includeIfNull: false)
  AnggotaModel idPemimpinKelompok;
  @JsonKey(includeIfNull: false)
  String fotoProfil;
  @JsonKey(includeIfNull: false)
  List<KelompokAnggotaModel> anggotaKelompok;

  factory KelompokModel.fromJson(Map<String, dynamic> json) =>
      _$KelompokModelFromJson(json);

  Map<String, dynamic> toJson() => _$KelompokModelToJson(this);

  //KelompokModel copy(KelompokModel fromKelompok) => _$KelompokModelCopy(this);
  KelompokModel copy() {
    //var copiedKelompok = new Map.from(this.toJson());
    var jsoncopy = this.toJson();

    var _copiedKelompok = _$KelompokModelFromJson(jsoncopy);

    return _copiedKelompok;
  }

  KelompokModel clone() {
    KelompokModel kelompokModel;
    kelompokModel = new KelompokModel(
      id: this.id,
      namaKelompok: this.namaKelompok,
      tujuanKelompok: this.tujuanKelompok,
      ketKelompok: this.ketKelompok,
      tglDibentuk: this.tglDibentuk,
      idPemimpinKelompok: (this.idPemimpinKelompok != null)
          ? this.idPemimpinKelompok.clone()
          : null,
      anggotaKelompok: (this.anggotaKelompok != null)
          ? new List<KelompokAnggotaModel>.from(this.anggotaKelompok)
          : null,
      fotoProfil: this.fotoProfil,
    );
    return kelompokModel;
  }
}

// @JsonSerializable(includeIfNull: false)
class KelompokAnggotaModel {
  KelompokAnggotaModel({
    this.id,
    this.idAnggota,
    this.rincianAnggota,
    this.jabatan,
    this.tglJabatan,
  });
  @JsonKey(name: '_id')
  String id;
  @JsonKey(includeIfNull: false)
  String idAnggota;
  @JsonKey(name: '_idAnggota', includeIfNull: false)
  AnggotaModel rincianAnggota;
  @JsonKey(includeIfNull: false)
  String jabatan;
  @JsonKey(includeIfNull: false)
  DateTime tglJabatan;

  factory KelompokAnggotaModel.fromJson(Map<String, dynamic> json) =>
      _$KelompokAnggotaModelFromJson(json);

  Map<String, dynamic> toJson() => _$KelompokAnggotaModelToJson(this);
  KelompokAnggotaModel copy() {
    //var copiedAnggota = new Map.from(this.toJson());
    var _copiedKelompok = _$KelompokAnggotaModelFromJson(this.toJson());
    return _copiedKelompok;
  }

  KelompokAnggotaModel clone() {
    KelompokAnggotaModel clonedModel;
    clonedModel = new KelompokAnggotaModel(
      id: this.id,
      idAnggota: this.idAnggota,
      rincianAnggota:
          (this.rincianAnggota != null) ? this.rincianAnggota.clone() : null,
      jabatan: this.jabatan,
      tglJabatan: this.tglJabatan,
    );
    return clonedModel;
  }
}

// @JsonLiteral('data.json') // a file named "data.json" for sample data
// Map get glossaryData => _$glossaryDataJsonLiteral;

// flutter packages pub run build_runner build --delete-conflicting-outputs
