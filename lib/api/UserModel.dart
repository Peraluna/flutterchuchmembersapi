import 'package:json_annotation/json_annotation.dart';

part 'UserModel.g.dart';


@JsonSerializable()
class UserModel {
  UserModel({
    this.id,
    this.email,
    this.phoneNumber,
    this.userName,
    this.password,
    this.mottoStatus,
    this.userLevel,
    this.token,
 
    this.fotoProfil,
  
  });
   @JsonKey(name: '_id',includeIfNull: false)
  String id;
    String userName;
    String email;
    String password;
    String phoneNumber;
    String mottoStatus;
    String userLevel;
   String token;
  
   @JsonKey(includeIfNull: false)
   String fotoProfil;
  

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

     Map<String, dynamic> toJson() => _$UserModelToJson(this);

     //UserModel copy(UserModel fromUser) => _$UserModelCopy(this);
     UserModel copy()  {
      //var copiedUser = new Map.from(this.toJson());
      var _copiedUser =_$UserModelFromJson( this.toJson()) ;
       return _copiedUser;
     }


   
//     UserModel _$UserModelCopy(UserModel instance) {
//   UserModel newUser = new UserModel();
//   newUser.id=instance.id;
// newUser.noUser= instance.noUser;
//     newUser.statusDalamKeluarga= instance.statusDalamKeluarga;
//     newUser.statusPernikahan= instance.statusPernikahan;
//     newUser.salut= instance.salut;
//     newUser.gelarDepan= instance.gelarDepan;
//     newUser.namaDepan= instance.namaDepan;
//    newUser.namaPanggilan= instance.namaPanggilan;
//   newUser.namaKeluarga= instance.namaKeluarga;
//     newUser.gelarBelakang= instance.gelarBelakang;
//    newUser.jenisKelamin= instance.jenisKelamin;
//    newUser.alamat= instance.alamat;
//    newUser.idKeluarga= instance.idKeluarga;
//    newUser.tglBaptis= instance.tglBaptis;
//    newUser.tglLahir= instance.tglLahir;
//     newUser.pekerjaan= instance.pekerjaan;
//    newUser.bidangPekerjaan= instance.bidangPekerjaan;
//    newUser.noTelpon= instance.noTelpon;
//     newUser.email= instance.email;
//   return newUser;
// }
}

// flutter packages pub run build_runner build --delete-conflicting-outputs

