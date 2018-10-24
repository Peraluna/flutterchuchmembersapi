import 'AnggotaModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'KeluargaModel.g.dart';

@JsonSerializable()
class KeluargaModel {
  KeluargaModel({
    this.id,
    this.namaKeluarga,
    this.alamat,
    this.fotoProfil,
    this.anggotaKeluarga,

    
  });
  @JsonKey(name: '_id')
  final String id;
  final String namaKeluarga;
  final String alamat;
  final String fotoProfil;
  final List<AnggotaModel> anggotaKeluarga;

   factory KeluargaModel.fromJson(Map<String, dynamic> json) =>
      _$KeluargaModelFromJson(json);

        Map<String, dynamic> toJson() => _$KeluargaModelToJson(this);
 KeluargaModel copy()  {
      //var copiedAnggota = new Map.from(this.toJson());
      var _copiedKeluarga =_$KeluargaModelFromJson( this.toJson()) ;
       return _copiedKeluarga;
     }
}


