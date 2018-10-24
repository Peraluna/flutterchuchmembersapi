import 'dart:async';
import 'dart:convert';
import 'dart:io';
//import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
//import 'package:path/path.dart';
import 'AnggotaModel.dart';
import '../globals/global.dart';
import '../globals/functions.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../globals/SharedPrefsHelperStatic.dart';

class AnggotaApi {
  String _serverAddress;

  init() async {
    await SharedPrefsHelperStatic.init();
      getPrefs();
  }

  // SharedPreferences sharedPreferences;

  getPrefs()   {
   
    _serverAddress =
          SharedPrefsHelperStatic.getString(PREFKEY_DOMAINURL);
  }

  final http.Client _client = http.Client();

  Future insertAnggota(AnggotaModel anggota, File fotoProfilImage) async {
    try {
      if (_serverAddress == null) {
        await getPrefs();
      }

      Map<String, dynamic> bodyjson = anggota.toJson();
      // Map<dynamic, dynamic> formFields = {};

      var url = Uri.parse("$_serverAddress/anggota");
      var request = http.MultipartRequest("POST", url);

      request.headers.addAll(Functions.getPostMultiPartHeader());

      if (fotoProfilImage != null) {
        //var urlImage = Uri.parse(fotoProfilImage.path);
        // request.files.add(new http.MultipartFile.fromBytes(
        //     'fotoProfil', await File.fromUri(urlImage).readAsBytes(),
        //     contentType: new MediaType('image', 'jpeg')));
        // OPTION 2 : (WORKING)
        // var stream = new http.ByteStream(
        //     DelegatingStream.typed(fotoProfilImage.openRead()));
        // var length = await fotoProfilImage.length();
        // var multipartFile = new http.MultipartFile('fotoProfil', stream, length,
        //     filename: basename(fotoProfilImage.path),
        //     contentType: new MediaType('image', 'jpeg'));

        var multipartFile = await http.MultipartFile.fromPath(
            "fotoProfil", fotoProfilImage.path,
            contentType: new MediaType('image', 'jpeg'));

        request.files.add(multipartFile);
      }

      bodyjson.forEach((k, v) {
        if (v.runtimeType.toString() == "List<dynamic>") {
          if (v != null) {
            //       request.fields[k] = json.encode(v);
          }
        } else {
          if (v != null) {
            request.fields[k] = v;
          }
        }

        //  request.fields[k]=v;
      });

      // request.files.add(null);

      var streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        print('SUCCESS POST !');
        print(
            "${streamedResponse.reasonPhrase}, code : ${streamedResponse.statusCode}");
      } else {
        print('Unsuccessful POST atempt !!!');
        print(
            "${streamedResponse.reasonPhrase}, code : ${streamedResponse.statusCode}");
      }
      return streamedResponse;
    } catch (e) {
      print('Server Exception!!!');
      print(e);
      var val = <String, dynamic>{};

      val['status'] = "error flutter exception";
      val['errmsg'] = e;

      return (val);
    }
    //  streamedResponse.stream.transform(utf8.decoder).listen((value) {
    //   print(value);
    //   map = json.decode(value);
    //   return map;
    // }, onError: () => {}, onDone: () => {});
  }

  String getNetWorkImageUrl(String imagePartUrl)   {
    // Save the user preference

    _serverAddress =  
        SharedPrefsHelperStatic.getString(PREFKEY_DOMAINURL);

    if (imagePartUrl == null || imagePartUrl.isEmpty) {
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

  Future updateAnggota(AnggotaModel anggota, File fotoProfilImage) async {
    try {
      if (_serverAddress == null) {
        await getPrefs();
      }

      Map<String, dynamic> bodyjson = anggota.toJson();
      // Map<dynamic, dynamic> formFields = {};

      var url = Uri.parse("$_serverAddress/anggota/update");
      var request = http.MultipartRequest("PATCH", url);

      request.headers.addAll(Functions.getPostMultiPartHeader());

      if (fotoProfilImage != null) {
        // var urlImage = Uri.parse(fotoProfilImage.path);
        // // request.files.add(new http.MultipartFile.fromBytes(
        // //     'fotoProfil', await File.fromUri(urlImage).readAsBytes(),
        // //     contentType: new MediaType('image', 'jpeg')));
        // var stream = new http.ByteStream(
        //     DelegatingStream.typed(fotoProfilImage.openRead()));
        // var length = await fotoProfilImage.length();
        // var multipartFile = new http.MultipartFile('fotoProfil', stream, length,
        //     filename: basename(fotoProfilImage.path),
        //     contentType: new MediaType('image', 'jpeg'));
        var multipartFile = await http.MultipartFile.fromPath(
            "fotoProfil", fotoProfilImage.path,
            contentType: new MediaType('image', 'jpeg'));

        request.files.add(multipartFile);
      }

      bodyjson.forEach((k, v) {
        if (v.runtimeType.toString() == "List<dynamic>") {
          if (v != null) {
            //       request.fields[k] = json.encode(v);
          }
        } else {
          if (v != null) {
            request.fields[k] = v;
          }
        }

        //  request.fields[k]=v;
      });

      // request.files.add(null);

      var streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        print('SUCCESS POST !');
        print(
            "${streamedResponse.reasonPhrase}, code : ${streamedResponse.statusCode}");
      } else {
        print('Unsuccessful POST atempt !!!');
        print(
            "${streamedResponse.reasonPhrase}, code : ${streamedResponse.statusCode}");
      }
      return streamedResponse;
    } catch (e) {
      print('Server Exception!!!');
      print(e);
      var val = <String, dynamic>{};

      val['status'] = "error flutter exception";
      val['errmsg'] = e;

      return (val);
    }
  }

  Future<List<AnggotaModel>> fetchBirthdays(String bulan) async {
    if (_serverAddress == null) {
      await getPrefs();
    }
    if (bulan.trim() == '') {
      bulan = DateTime.now().month.toString();
    }
    try {
      final client = new http.Client();
      final url = '$_serverAddress/anggota/select_hut_by_bulan/$bulan';

      final response = await client
          .get(Uri.encodeFull(url), headers: {'Accept': "application/json"});
      if (response.statusCode == 200) {
        return parseAnggotaList(response.body);
        // return compute(parseAnggotaList, response.body);
      }

      return null;
    } catch (err) {
      return null;
    }
    // select_all_by_nama/nay
  }

  List<AnggotaModel> parseAnggotaList(String responseBody)  {
    /// this function if called with compute (background parsing for slower phone)
    /// must be a top level function, not a closure or
    /// or an instance or static method of a class
    /// example call : return compute(parseAnggotaList, response.body);
    final dataMap =
        json.decode(responseBody)["data"].cast<Map<String, dynamic>>();
    // final String test = json
    //     .decode(responseBody)["data"]
    //     .cast<Map<String, dynamic>>()[0]["namaKeluarga"]
    //     .toString();

    // print(test);

    return dataMap
        .map<AnggotaModel>((json) => AnggotaModel.fromJson(json))
        .toList();
  }

  Future insertAnggotaHttpPost(AnggotaModel anggota) async {
    if (_serverAddress == null) {
      await getPrefs();
    }

    try {
      Map<String, dynamic> bodyjson = anggota.toJson();
      Map formFields = {};

      bodyjson.forEach((k, v) {
        if (v.runtimeType.toString() == "List<dynamic>") {
          if (v != null) {
            //       request.fields[k] = json.encode(v);
          }
        } else {
          if (v != null) {
            formFields[k] = v;
          }
        }

        //  request.fields[k]=v;
      });

      var url = Uri.parse("$_serverAddress/anggota");
      final response = await http.post(url,
          headers: Functions.getPostMultiPartHeader(), body: formFields);
      // request.headers.addEntries(Functions.getPostMultiPartHeader());

// EROR: Bad state: Cannot set the body fields of a Request with content-type "multipart/form-data"
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print(response.reasonPhrase);
        return response.reasonPhrase;
      }
    } catch (e) {
      print('Server Exception!!!');
      print(e);
      return null;
    }
  }

  // Base64Codec _toJson(AnggotaModel anggota) {
  //   var mapData = new Map();
  //   mapData["name"] = anggota.name;
  //   mapData["dob"] = new DateFormat.yMd().format(anggota.dob);
  //   mapData["phone"] = anggota.phone;
  //   mapData["email"] = anggota.email;
  //   mapData["favoriteColor"] = anggota.favoriteColor;
  //   String jsonstr = json.encode(mapData);
  //   return jsonstr;
  // }
  Future<AnggotaModel> loginAnggota(String email, String password) async {
    if (_serverAddress == null) {
      await getPrefs();
    }
    final response =
        await _client.get('$_serverAddress/anggota/$email&$password');
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["status"] == "ok") {
        final userData =
            mapResponse["data"]["document"].cast<Map<String, dynamic>>();
        return userData.map<AnggotaModel>((json) {
          return AnggotaModel.fromJson(json);
        });
      } else {
        return null;
      }
    } else {
      throw Exception("Failed to login");
    }
    // ALTERNATE call
    //  Anggota userData=null;
    //  userData= await http.get('$URL_USERS/login/$email&$password')
    //   .then((response) => response.body)
    //   .then((responseBody) => json.decode(responseBody).cast<Map<String, dynamic>>() )
    //   .then((decodedjsonMap) => decodedjsonMap["data"]["document"].cast<Map<String, dynamic>>())
    //   .then((userDataMap) => Anggota.fromJson(userDataMap))
    //   .catchError(onError);
  }

  Future<List<AnggotaModel>> fetchAnggotaList(String userGroup) async {
    if (_serverAddress == null) {
      await getPrefs();
    }
    final response = await _client.get("$_serverAddress/anggota");

    if (response.statusCode == 200) {
      // print(response.body);
      Map<String, dynamic> mapResponse = json.decode(response.body);

      if (mapResponse["status"] == "ok") {
        final rincianKegiatan = mapResponse["data"]["document"][0]
                ["rincian_kegiatan"]
            .cast<Map<String, dynamic>>();
        // print(rincianKegiatan.runtimeType); // CastList<dynamic, Map<String, dynamic>>
        // print(rincianKegiatan);
        //final listOfAnggota = await Future.wait(futures)

        final listOfAnggota = await rincianKegiatan.map<AnggotaModel>((json) {
          return AnggotaModel.fromJson(json);
        }).toList();

        // print("AFTER ===");
        return listOfAnggota;
      } else {
        throw Exception(mapResponse["message"]);
      }
    } else {
      throw Exception(response.body);
    }
  }

  Future<AnggotaModel> deleteAnggota(
      http.Client client, String idKegiatan, String email) async {
    if (_serverAddress == null) {
      await getPrefs();
    }
    final String url = '$_serverAddress/anggota/$idKegiatan&$email';

    final response = await client.delete(url);

    if (response.statusCode == 200) {
      final responseBody = await json.decode(response.body);
      return AnggotaModel.fromJson(responseBody);
    } else {
      throw Exception(
          "Failed t0 delete a Anggota. Error : ${response.toString()}");
    }
  }

  Future<AnggotaModel> signAnggotaUp(
      http.Client client, String email, String password) async {
    var body = {"email": email, "password": password};
    final response =
        await client.post('$_serverAddress/anggota/login', body: body);

    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = await json.decode(response.body);

      // return rincianKegiatans.map<Anggota>((json) {
      //     return Anggota.fromJson(json);
      //   }).toList();

      return AnggotaModel.fromJson(mapResponse);
    } else {
      throw Exception("Failed to login. Error : ${response.toString()}");
    }
  }
}
