import 'dart:async';
import 'dart:convert';
import '../globals/global.dart';
import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';

import 'KeluargaModel.dart';

import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../globals/SharedPrefsHelperStatic.dart';

class KeluargaApi {
  String _serverAddress;
  final http.Client _client = http.Client();
  // SharedPreferences sharedPreferences;
  // getServerAddress() async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   _serverAddress = sharedPreferences.getString("serverAddress");
  // }

// controllers
  Future<KeluargaModel> loginKeluarga(String email, String password) async {
    if (_serverAddress == null) {}
    final response =
        await _client.get('$_serverAddress/keluarga/$email&$password');
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["status"] == "ok") {
        final userData =
            mapResponse["data"]["document"].cast<Map<String, dynamic>>();
        return userData.map<KeluargaModel>((json) {
          return KeluargaModel.fromJson(json);
        });
      } else {
        return null;
      }
    } else {
      throw Exception("Failed to login");
    }
    // ALTERNATE call
    //  Keluarga userData=null;
    //  userData= await http.get('$URL_USERS/login/$email&$password')
    //   .then((response) => response.body)
    //   .then((responseBody) => json.decode(responseBody).cast<Map<String, dynamic>>() )
    //   .then((decodedjsonMap) => decodedjsonMap["data"]["document"].cast<Map<String, dynamic>>())
    //   .then((userDataMap) => Keluarga.fromJson(userDataMap))
    //   .catchError(onError);
  }

  init() async {
    await SharedPrefsHelperStatic.init();
      getPrefs();
  }

 // SharedPreferences sharedPreferences;

  getPrefs()   {
   

    _serverAddress =   SharedPrefsHelperStatic.getString(PREFKEY_DOMAINURL);
  }

   String getNetWorkImageUrl(String imagePartUrl)   {
    // Save the user preference
    if (_serverAddress == null) {
      // await SharedPrefsHelper.init();
      _serverAddress =   SharedPrefsHelperStatic.getString(PREFKEY_DOMAINURL);
    }
    if (imagePartUrl == null) {
      return null;
    }

    String url = "$_serverAddress/$imagePartUrl";

    url = url.replaceAll(new RegExp(r'\\'), '/');
    return (url);
    // SharedPrefsHelper.getPref(EnumPrefsKey.serverAddress).then((value) {
    //   String url = "$value/$imagePartUrl";
    //   if (imagePartUrl == null) {
    //     return null;
    //   }
    //   //String fileName = url.substring(url.lastIndexOf('/') + 1);
    //   url = url.replaceAll(new RegExp(r'\\'), '/');
    //   return (url);
    // });
  }

  Future<List<KeluargaModel>> fetchKeluargaWithAnggotaSimple(
      String namaKeluarga) async {
    if (_serverAddress == null) {
      await getPrefs();
    }
    if (namaKeluarga.trim() == '') {
      namaKeluarga = '~';
    }
    try {
      final client = new http.Client();
      final url =
          '$_serverAddress/keluarga/select_by_name_with_anggota/$namaKeluarga';

      final response = await client
          .get(Uri.encodeFull(url), headers: {'Accept': "application/json"});
      if (response.statusCode == 200) {
        return parseKeluargaList(response.body);
        // return compute(parseKeluargaList, response.body);
      }

      return null;
    } catch (err) {
      return null;
    }
    // select_all_by_nama/nay
  }

  Future<List<KeluargaModel>> fetchKeluargaWithAnggota(
      String namaKeluarga) async {
    if (_serverAddress == null) {
      await getPrefs();
    }
    if (namaKeluarga.trim() == '') {
      namaKeluarga = '~';
    }
    try {
      final client = new http.Client();
      final url =
          '$_serverAddress/keluarga/select_by_name_with_anggota/$namaKeluarga';

      final response = await client.get(url);
      if (response == null) {
        return null;
      }
      return compute(parseKeluargaList, response.body);
    } catch (err) {
      return null;
    }
    // select_all_by_nama/nay
  }

  Map<String, dynamic> res = {"data": List, "status": "", "message": ""};
  Future<Map<String, dynamic>> fetchKeluargaWithAnggotaMap(
      String namaKeluarga) async {
    if (_serverAddress == null) {
      await getPrefs();
    }
    if (namaKeluarga.trim() == '') {
      namaKeluarga = '~';
    }
    try {
      final http.Client client = http.Client();
      final url =
          '$_serverAddress/keluarga/select_by_name_with_anggota/$namaKeluarga';
      final response = await client.get(url);
      if (response == null) {
        return null;
      }
      res["data"] = compute(parseKeluargaList, response.body);
      res["status"] = "ok";
      return res;
    } catch (err) {
      res["data"] = null;
      res["status"] = "error";
      res["message"] = err;
      return null;
    }
    // select_all_by_nama/nay
  }

  List<KeluargaModel> parseKeluargaList(String responseBody) {
    /// this function if called with compute (background parsing for slower phone)
    /// must be a top level function, not a closure or
    /// or an instance or static method of a class
    /// example call : return compute(parseKeluargaList, response.body);
    final dataMap =
        json.decode(responseBody)["data"].cast<Map<String, dynamic>>();
    final String test = json
        .decode(responseBody)["data"]
        .cast<Map<String, dynamic>>()[0]["namaKeluarga"]
        .toString();

    print(test);
    //final parsed = json.decode(responseBody);
    //final parsedData = parsed["data"].cast<Map<String, dynamic>>();

    // the following statement is valid in debug console :

    // json.decode(responseBody)["data"].cast<Map<String,dynamic>>()[0]["namaKeluarga"]
    // json.decode(responseBody)["data"].cast<Map<String,dynamic>>()[1]["namaKeluarga"]
    // json.decode(responseBody)["data"].cast<Map<String,dynamic>>().toString()
    // json.decode(responseBody)["data"].cast<Map<String,dynamic>>().toList()
    // json.decode(responseBody)["data"].cast<Map<String,dynamic>>().toList()[0]["anggotaKeluarga"][0]["namaDepan"]
    // --> "Jordan Ray Juliano"

    return dataMap
        .map<KeluargaModel>((json) => KeluargaModel.fromJson(json))
        .toList();
  }

  Future<KeluargaModel> updateKeluarga(http.Client client,
      Map<String, dynamic> params, Map<String, dynamic> body) async {
    final response = await client.patch(
        '$_serverAddress/$params["id_kegiatan"]&$params["id_rincian"]}',
        body: body);
    print("response = $response");
    if (response.statusCode == 200) {
      final responseBody = await json.decode(response.body);
      return KeluargaModel.fromJson(responseBody);
    } else {
      throw Exception(
          "Failed t update a Keluarga. Error : ${response.toString()}");
    }
  }

  Future<KeluargaModel> deleteKeluarga(
      http.Client client, String idKegiatan, String email) async {
    final String url = '$_serverAddress/keluarga/$idKegiatan&$email';

    final response = await client.delete(url);

    if (response.statusCode == 200) {
      final responseBody = await json.decode(response.body);
      return KeluargaModel.fromJson(responseBody);
    } else {
      throw Exception(
          "Failed t0 delete a Keluarga. Error : ${response.toString()}");
    }
  }

  Future<KeluargaModel> signKeluargaUp(
      http.Client client, String email, String password) async {
    var body = {"email": email, "password": password};

    final response =
        await client.post('$_serverAddress/keluarga/login', body: body);

    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = await json.decode(response.body);

      // return rincianKegiatans.map<Keluarga>((json) {
      //     return Keluarga.fromJson(json);
      //   }).toList();

      return KeluargaModel.fromJson(mapResponse);
    } else {
      throw Exception("Failed to login. Error : ${response.toString()}");
    }
  }

// static Future<Image> getImage(String fileName ) async {
//   // select_all_by_nama/nay
//   if (fileName.trim()=='') {
//     return null;
//   }
//   final http.Client client = http.Client();
//   final url='$SERVER_ADDR/keluarga/get_image/$fileName';
//   final response = await client.get(url);
//     if (response==null) {
//     return null;
//   }
//   return   response.body ;
// }

}
