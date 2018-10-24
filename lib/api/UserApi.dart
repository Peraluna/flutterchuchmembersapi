import 'dart:async';
import 'dart:convert';
import 'dart:io';
//import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
//import 'package:path/path.dart';
import 'UserModel.dart';
import '../globals/global.dart';
import '../globals/functions.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import '../globals/SharedPrefsHelperStatic.dart';

class UserApi {
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

  Future insertUser(UserModel user, File fotoProfilImage) async {
    try {
      if (_serverAddress == null) {
        await getPrefs();
      }

      Map<String, dynamic> bodyjson = user.toJson();
      // Map<dynamic, dynamic> formFields = {};

      var url = Uri.parse("$_serverAddress/user");
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
    if (imagePartUrl == null || imagePartUrl.isEmpty) {
      return null;
    }

    var url =   SharedPrefsHelperStatic.getString(PREFKEY_DOMAINURL);

    url = "$_serverAddress/$imagePartUrl";
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

  Future updateUser(UserModel user, File fotoProfilImage) async {
    try {
      if (_serverAddress == null) {
        await getPrefs();
      }

      Map<String, dynamic> bodyjson = user.toJson();
      // Map<dynamic, dynamic> formFields = {};

      var url = Uri.parse("$_serverAddress/user/update");
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

  Future<UserModel> loginWithCompleter(String email, String password) async {
    Completer _completer = new Completer();
    if (_serverAddress == null) {
      await getPrefs();
    }
    UserModel userParsed;
    try {
      final client = new http.Client();
      final url = '$_serverAddress/user/login/$email&$password';

      final response = await client
          .get(Uri.encodeFull(url), headers: {'Accept': "application/json"});
      if (response.statusCode == 200) {
        userParsed = parseUser(response.body);

        // return compute(parseUserList, response.body);
      }
      return _completer.future;
    } catch (error) {
      _completer.completeError(error);
      return null;
      //_errorHappened(error);
    } finally {
      _completer.complete(userParsed);

      //_finishOperation(userParsed);
    }

    // select_all_by_nama/nay
  }

  // void _finishOperation(UserModel result) {

  // }

  // void _errorHappened(error) {
  //   //_completer.completeError(error);
  // }

  Future<UserModel> login(String email, String password) async {
    if (_serverAddress == null) {
      await getPrefs();
    }

    final client = new http.Client();
    final url = '$_serverAddress/user/login/$email&$password';

    final response = await client
        .get(Uri.encodeFull(url), headers: {'Accept': "application/json"});
    if (response.statusCode == 200) {
      return parseUser(response.body);

      // return compute(parseUserList, response.body);
    } else {
      var serverError = json.decode(response.body)["message"];
      throw new Exception(serverError);
      //throw (serverError);
    }

    // select_all_by_nama/nay
  }

  UserModel parseUser(String responseBody) {
    /// this function if called with compute (background parsing for slower phone)
    /// must be a top level function, not a closure or
    /// or an instance or static method of a class
    /// example call : return compute(parseUserList, response.body);

    return UserModel.fromJson(json.decode(responseBody)["data"]);
  }

  List<UserModel> parseUserList(String responseBody) {
    /// this function if called with compute (background parsing for slower phone)
    /// must be a top level function, not a closure or
    /// or an instance or static method of a class
    /// example call : return compute(parseUserList, response.body);
    final dataMap =
        json.decode(responseBody)["data"].cast<Map<String, dynamic>>();
    // final String test = json
    //     .decode(responseBody)["data"]
    //     .cast<Map<String, dynamic>>()[0]["namaKeluarga"]
    //     .toString();

    // print(test);

    return dataMap.map<UserModel>((json) => UserModel.fromJson(json)).toList();
  }

  Future insertUserHttpPost(UserModel user) async {
    if (_serverAddress == null) {
      await getPrefs();
    }

    try {
      Map<String, dynamic> bodyjson = user.toJson();
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

      var url = Uri.parse("$_serverAddress/user");
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

  // Base64Codec _toJson(UserModel user) {
  //   var mapData = new Map();
  //   mapData["name"] = user.name;
  //   mapData["dob"] = new DateFormat.yMd().format(user.dob);
  //   mapData["phone"] = user.phone;
  //   mapData["email"] = user.email;
  //   mapData["favoriteColor"] = user.favoriteColor;
  //   String jsonstr = json.encode(mapData);
  //   return jsonstr;
  // }
  Future<UserModel> loginUserSync(String email, String password) async {
    // sync will prevent synchronuous to leak from async code
    return new Future.sync(() {
      if (_serverAddress == null) {
        getPrefs();
      }
      _client
          .get('$_serverAddress/user/login/$email&$password')
          .then((response) {
        if (response.statusCode == 200) {
          return parseUser(response.body);

          // return compute(parseUserList, response.body);
        } else {
          var serverError = json.decode(response.body)["message"];
          throw (serverError);
        }
      });
      // var filename = obtainFileName(data);         // Could throw.
      // File file = new File(filename);
      // return file.readAsString().then((contents) {
      //   return parseFileData(contents);            // Could throw.
      // });
    });

    // ALTERNATE call
    //  User userData=null;
    //  userData= await http.get('$URL_USERS/login/$email&$password')
    //   .then((response) => response.body)
    //   .then((responseBody) => json.decode(responseBody).cast<Map<String, dynamic>>() )
    //   .then((decodedjsonMap) => decodedjsonMap["data"]["document"].cast<Map<String, dynamic>>())
    //   .then((userDataMap) => User.fromJson(userDataMap))
    //   .catchError(onError);
  }

  Future<List<UserModel>> fetchUserList(String userGroup) async {
    if (_serverAddress == null) {
      await getPrefs();
    }
    final response = await _client.get("$_serverAddress/user");

    if (response.statusCode == 200) {
      // print(response.body);
      Map<String, dynamic> mapResponse = json.decode(response.body);

      if (mapResponse["status"] == "ok") {
        final rincianKegiatan = mapResponse["data"]["document"][0]
                ["rincian_kegiatan"]
            .cast<Map<String, dynamic>>();
        // print(rincianKegiatan.runtimeType); // CastList<dynamic, Map<String, dynamic>>
        // print(rincianKegiatan);
        //final listOfUser = await Future.wait(futures)

        final listOfUser = await rincianKegiatan.map<UserModel>((json) {
          return UserModel.fromJson(json);
        }).toList();

        // print("AFTER ===");
        return listOfUser;
      } else {
        throw Exception(mapResponse["message"]);
      }
    } else {
      throw Exception(response.body);
    }
  }

  Future<UserModel> deleteUser(
      http.Client client, String idKegiatan, String email) async {
    if (_serverAddress == null) {
      await getPrefs();
    }
    final String url = '$_serverAddress/user/$idKegiatan&$email';

    final response = await client.delete(url);

    if (response.statusCode == 200) {
      final responseBody = await json.decode(response.body);
      return UserModel.fromJson(responseBody);
    } else {
      throw Exception(
          "Failed t0 delete a User. Error : ${response.toString()}");
    }
  }

  Future<UserModel> signUserUp(
      http.Client client, String email, String password) async {
    var body = {"email": email, "password": password};
    final response =
        await client.post('$_serverAddress/user/login', body: body);

    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = await json.decode(response.body);

      // return rincianKegiatans.map<User>((json) {
      //     return User.fromJson(json);
      //   }).toList();

      return UserModel.fromJson(mapResponse);
    } else {
      throw Exception("Failed to login. Error : ${response.toString()}");
    }
  }
}
