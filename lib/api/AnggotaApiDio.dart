import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
import 'package:dio/dio.dart';
import 'AnggotaModel.dart';
// import '../globals/global.dart';
import '../globals/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AnggotaApiDio {
  String _serverAddress;
 
  SharedPreferences sharedPreferences;
  getServerAddress() async {
    sharedPreferences = await SharedPreferences.getInstance();
    _serverAddress = sharedPreferences.getString("ServerAddress");
  }

   

  initHttpAddress() {
    getServerAddress();
  }
  Future insertAnggota(AnggotaModel anggota) async {
    var dio = new Dio();
    // dio.options.baseUrl = "$_serverAddress";
    dio.options.headers = Functions.getPostMultiPartHeader();
    
    try {
      Map<String, dynamic> bodyjson = anggota.toJson();
      FormData formData = new FormData();
      bodyjson.forEach((k, v) {
        if (v.runtimeType.toString() == "List<dynamic>") {
          if (v != null) {
            //       request.fields[k] = json.encode(v);
          }
        } else {
          if (v != null) {
            formData.add(k, v);
          }
        }

        //  request.fields[k]=v;
      });
      dio.options.data=formData;
       
      // var url = Uri.parse("$_serverAddress/anggota");
      Response response =
          //await dio.post("$_serverAddress/anggota", data: formData);
await dio.post("$_serverAddress/anggota") ;
      if (response.statusCode == 200) {
        return response;
      }
    } catch (e) {
      print('Server Exception!!!');
      print(e);
      return null;
    }
  }

  // // Base64Codec _toJson(AnggotaModel anggota) {
  // //   var mapData = new Map();
  // //   mapData["name"] = anggota.name;
  // //   mapData["dob"] = new DateFormat.yMd().format(anggota.dob);
  // //   mapData["phone"] = anggota.phone;
  // //   mapData["email"] = anggota.email;
  // //   mapData["favoriteColor"] = anggota.favoriteColor;
  // //   String jsonstr = json.encode(mapData);
  // //   return jsonstr;
  // // }
  // Future<AnggotaModel> loginAnggota(
  //     String email, String password) async {
  //   final response = await _client.get('$_serverAddress/anggota/$email&$password');
  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> mapResponse = json.decode(response.body);
  //     if (mapResponse["status"] == "ok") {
  //       final userData =
  //           mapResponse["data"]["document"].cast<Map<String, dynamic>>();
  //       return userData.map<AnggotaModel>((json) {
  //         return AnggotaModel.fromJson(json);
  //       });
  //     } else {
  //       return null;
  //     }
  //   } else {
  //     throw Exception("Failed to login");
  //   }
  //   // ALTERNATE call
  //   //  Anggota userData=null;
  //   //  userData= await http.get('$URL_USERS/login/$email&$password')
  //   //   .then((response) => response.body)
  //   //   .then((responseBody) => json.decode(responseBody).cast<Map<String, dynamic>>() )
  //   //   .then((decodedjsonMap) => decodedjsonMap["data"]["document"].cast<Map<String, dynamic>>())
  //   //   .then((userDataMap) => Anggota.fromJson(userDataMap))
  //   //   .catchError(onError);
  // }

  // Future<List<AnggotaModel>> fetchAnggotaList(String userGroup) async {
  //   final response = await _client.get("$_serverAddress/anggota");

  //   if (response.statusCode == 200) {
  //     // print(response.body);
  //     Map<String, dynamic> mapResponse = json.decode(response.body);

  //     if (mapResponse["status"] == "ok") {
  //       final rincianKegiatan = mapResponse["data"]["document"][0]
  //               ["rincian_kegiatan"]
  //           .cast<Map<String, dynamic>>();
  //       // print(rincianKegiatan.runtimeType); // CastList<dynamic, Map<String, dynamic>>
  //       // print(rincianKegiatan);
  //       //final listOfAnggota = await Future.wait(futures)

  //       final listOfAnggota = await rincianKegiatan.map<AnggotaModel>((json) {
  //         return AnggotaModel.fromJson(json);
  //       }).toList();

  //       // print("AFTER ===");
  //       return listOfAnggota;
  //     } else {
  //       throw Exception(mapResponse["message"]);
  //     }
  //   } else {
  //     throw Exception(response.body);
  //   }
  // }

  // Future<AnggotaModel> updateAnggota(http.Client client,
  //     Map<String, dynamic> params, Map<String, dynamic> body) async {
  //   final response = await client.patch(
  //       '$_serverAddress/$params["id_kegiatan"]&$params["id_rincian"]}',
  //       body: body);
  //   print("response = $response");
  //   if (response.statusCode == 200) {
  //     final responseBody = await json.decode(response.body);
  //     return AnggotaModel.fromJson(responseBody);
  //   } else {
  //     throw Exception(
  //         "Failed t update a Anggota. Error : ${response.toString()}");
  //   }
  // }

  // Future<AnggotaModel> deleteAnggota(
  //     http.Client client, String idKegiatan, String email) async {
  //   final String url = '$_serverAddress/anggota/$idKegiatan&$email';

  //   final response = await client.delete(url);

  //   if (response.statusCode == 200) {
  //     final responseBody = await json.decode(response.body);
  //     return AnggotaModel.fromJson(responseBody);
  //   } else {
  //     throw Exception(
  //         "Failed t0 delete a Anggota. Error : ${response.toString()}");
  //   }
  // }

  // Future<AnggotaModel> signAnggotaUp(
  //     http.Client client, String email, String password) async {
  //   var body = {"email": email, "password": password};
  //   final response =
  //       await client.post('$_serverAddress/anggota/login', body: body);

  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> mapResponse = await json.decode(response.body);

  //     // return rincianKegiatans.map<Anggota>((json) {
  //     //     return Anggota.fromJson(json);
  //     //   }).toList();

  //     return AnggotaModel.fromJson(mapResponse);
  //   } else {
  //     throw Exception("Failed to login. Error : ${response.toString()}");
  //   }
  // }
}
