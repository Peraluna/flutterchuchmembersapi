import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import './api/AnggotaModel.dart';
import './api/AnggotaApi.dart';
// import './api/AnggotaApiDio.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:image_picker/image_picker.dart';
import './globals/functions.dart';
import 'globals/global.dart';
// import 'CustomWidgets/LunaTextDateField.dart';
import 'CustomWidgets/LunaDateFormFieldDropDown.dart';

class AnggotaEntryScreen extends StatefulWidget {
  final ValueChanged<AnggotaModel> onSaved;
  final String idKeluarga;
  final String namaKeluarga;
  final AnggotaModel anggotaModelEdit;
  AnggotaEntryScreen(
      {Key key,
      @required this.idKeluarga,
      @required this.namaKeluarga,
      this.anggotaModelEdit,
      this.onSaved});

  @override
  _AnggotaEntryScreenState createState() => _AnggotaEntryScreenState();
}

class _AnggotaEntryScreenState extends State<AnggotaEntryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  AnggotaApi anggotaApi = new AnggotaApi();
  List<String> _statusDalamKeluargaList = <String>[
    '',
    'Kepala Keluarga',
    'Istri',
    'Anak',
    'Keponakan',
    'Orang Tua',
    'Saudara',
    'Pembantu',
    'Lain-Lain'
  ];
  String _statusDalamKeluarga = '';

  List<String> _statusPernikahanList = <String>[
    '',
    'Menikah',
    'Lajang',
  ];
  String _statusPernikahan = '';

  List<String> _jenisKelaminList = <String>[
    '',
    'Laki-Laki',
    'Perempuan',
  ];
  String _jenisKelamin = '';

  AnggotaModel newAnggotaModel;
  String fotoProfilPath = '';

  final TextEditingController _controllerid = new TextEditingController();

  final TextEditingController _controllernoAnggota =
      new TextEditingController();
  // final TextEditingController _controllerstatusDalamKeluarga =
  //     new TextEditingController();
  // final TextEditingController _controllerstatusPernikahan =
  //     new TextEditingController();
  final TextEditingController _controllersalut = new TextEditingController();
  final TextEditingController _controllergelarDepan =
      new TextEditingController();
  final TextEditingController _controllernamaDepan =
      new TextEditingController();
  final TextEditingController _controllernamaPanggilan =
      new TextEditingController();
  final TextEditingController _controllernamaKeluarga =
      new TextEditingController();
  final TextEditingController _controllergelarBelakang =
      new TextEditingController();
  // final TextEditingController _controllerjenisKelamin =
  //     new TextEditingController();
  final TextEditingController _controlleralamat = new TextEditingController();
  final TextEditingController _controlleridKeluarga =
      new TextEditingController();
  final TextEditingController _controllertglBaptis =
      new TextEditingController();
  final TextEditingController _controllertglLahir = new TextEditingController();
  final TextEditingController _controllerpekerjaan =
      new TextEditingController();
  final TextEditingController _controllerbidangPekerjaan =
      new TextEditingController();
  final TextEditingController _controllernoTelpon = new TextEditingController();
  final TextEditingController _controlleremail = new TextEditingController();
  final TextEditingController _controlleridUser = new TextEditingController();

  //  final TextEditingController _controllerminat,
  //   this.keahlian,

  void init() async {
    anggotaApi = new AnggotaApi();
    await anggotaApi.init();
  }

  @override
  void initState() {
    // _getData = null;// KeluargaApi.fetchKeluargaWithAnggota(_namaSearch);

    init();
    newAnggotaModel = new AnggotaModel();
    newAnggotaModel.idKeluarga = widget.idKeluarga;

    _jenisKelamin = '';
    if (widget.anggotaModelEdit != null) {
      _initControllersValue(widget.anggotaModelEdit);
      _initNewAnggota(widget.anggotaModelEdit);
    } else {
      _controlleridKeluarga.text = widget.idKeluarga;

      newAnggotaModel.idKeluarga = widget.idKeluarga;
    }
    super.initState();
  }

  _initControllersValue(AnggotaModel anggotaModelEdit) {
    _controllerid.text = anggotaModelEdit.id;

    _controllernoAnggota.text = anggotaModelEdit.noAnggota;

    // _controllerstatusDalamKeluarga.text = anggotaModelEdit.statusDalamKeluarga;
    _statusDalamKeluarga = anggotaModelEdit.statusDalamKeluarga;

    // _controllerstatusPernikahan.text = anggotaModelEdit.statusPernikahan;
    _statusPernikahan = anggotaModelEdit.statusPernikahan;

    _controllersalut.text = anggotaModelEdit.salut;

    _controllergelarDepan.text = anggotaModelEdit.gelarDepan;

    _controllernamaDepan.text = anggotaModelEdit.namaDepan;

    _controllernamaPanggilan.text = anggotaModelEdit.namaPanggilan;
    _controlleridKeluarga.text = anggotaModelEdit.idKeluarga;
    _controllernamaKeluarga.text = anggotaModelEdit.namaKeluarga;
    _controllergelarBelakang.text = anggotaModelEdit.gelarBelakang;
    // _controllerjenisKelamin.text = anggotaModelEdit.jenisKelamin;
    _jenisKelamin = anggotaModelEdit.jenisKelamin;
    _controlleralamat.text = anggotaModelEdit.alamat;

    _controllertglBaptis.text =Functions.getDateStringYYYYMMDD( anggotaModelEdit.tglBaptis);
    if ( anggotaModelEdit.tglLahir !=null) {
      _controllertglLahir.text = DateFormat("yyyy-MM-dd").format(
           anggotaModelEdit.tglLahir);
      // _controllertglLahir.text = new DateFormat.yMd().format(

      //     Functions.convertStringWithTtoDateTime(anggotaModelEdit.tglLahir));
    } else {
      _controllertglLahir.text = "";
    }

    _controllerpekerjaan.text = anggotaModelEdit.pekerjaan;
    _controllerbidangPekerjaan.text = anggotaModelEdit.bidangPekerjaan;
    _controllernoTelpon.text = anggotaModelEdit.noTelpon;
    _controlleremail.text = anggotaModelEdit.email;
    _controlleridUser.text = anggotaModelEdit.idUser;
    fotoProfilPath = anggotaModelEdit.fotoProfil;
  }

  _initNewAnggota(AnggotaModel anggotaModelEdit) {
    newAnggotaModel = anggotaModelEdit.copy();
  }

  @override
  void dispose() {
    anggotaApi = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text("Entry Anggota"),
          actions: <Widget>[
            IconButton(
              icon: new Icon(Icons.save),
              onPressed: () {
                _submitForm();
              },
            )
          ],
        ),
        body: progressHUD(context));
  }

  Widget safeAreaForm(BuildContext context) {
    return new SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: <Widget>[
            Container(child: fotoProfilWidget),
            Expanded(child: formEntry),
          ],
        ));
  }

  Widget get formEntry {
    return new Form(
        key: _formKey,
        autovalidate: true,
        child: new ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.blue[800],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: <Widget>[
                  new TextFormField(
                    controller: _controlleridKeluarga,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.yellow, fontSize: 12.0),
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'id Keluarga',
                      labelText: 'ID Keluarga',
                    ),
                    enabled: false,
                    onSaved: (val) => newAnggotaModel.idKeluarga = val,
                  ),
                  Text(
                    widget.namaKeluarga,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  )
                ],
              ),
            ),
            new TextFormField(
              controller: _controllerid,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: '<Auto ID>',
                labelText: 'ID Data',
              ),
              enabled: false,
            ),
            new TextFormField(
              controller: _controllernamaDepan,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'isi Nama Depan',
                labelText: 'Nama Depan',
              ),
              inputFormatters: [new LengthLimitingTextInputFormatter(100)],
              validator: (val) => val.isEmpty ? 'Nama harus diisi' : null,
              onSaved: (val) => newAnggotaModel.namaDepan = val,
            ),
            new TextFormField(
              controller: _controllernamaKeluarga,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'isi Nama Keluarga',
                labelText: 'Nama Keluarga',
              ),
              inputFormatters: [new LengthLimitingTextInputFormatter(100)],
              validator: (val) => val.isEmpty ? 'Nama harus diisi' : null,
              onSaved: (val) => newAnggotaModel.namaKeluarga = val,
            ),
            jenisKelaminDropDown(),
            tglLahirPicker,
            statusPernikahanDropDown(),
            statusDalamKeluargaDropDown(),
            new TextFormField(
              controller: _controllernoTelpon,
              decoration: const InputDecoration(
                icon: const Icon(Icons.phone),
                hintText: 'Isi No Telpon',
                labelText: 'No. Telpon',
              ),
              validator: ((value) {
                if (value.isNotEmpty) {
                  return (Functions.isValidPhoneNumber(value)
                      ? null
                      : 'Harap isi no telpon yang valid');
                }
                return null;
              }),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                new WhitelistingTextInputFormatter(
                    new RegExp(r'^[()\d -]{1,15}$')),
              ],
              // validator: (value) => isValidPhoneNumber(value)
              //     ? null
              //     : 'Phone number must be entered as (###)###-####',
              onSaved: (val) => newAnggotaModel.noTelpon = val,
            ),
            new TextFormField(
              controller: _controlleremail,
              decoration: const InputDecoration(
                icon: const Icon(Icons.email),
                hintText: 'Isi email',
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
              validator: ((value) {
                if (value.isNotEmpty) {
                  return (Functions.isValidEmail(value)
                      ? null
                      : 'Harap isi email yang valid');
                }
                return null;
              }),
              onSaved: (val) => newAnggotaModel.email = val,
            ),
            new TextFormField(
              controller: _controlleralamat,
              decoration: const InputDecoration(
                icon: const Icon(Icons.data_usage),
                hintText: 'Isi alamat',
                labelText: 'Alamat',
              ),
              keyboardType: TextInputType.text,
              // validator: (value) =>
              //     (value.isEmpty) ? 'Harap isi alamat' : null,
              onSaved: (val) => newAnggotaModel.alamat = val,
            ),
            new TextFormField(
              controller: _controllernoAnggota,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Isi No. Anggota',
                labelText: 'No. Anggota',
              ),
              inputFormatters: [new LengthLimitingTextInputFormatter(100)],
              validator: (val) =>
                  val.isEmpty ? 'No. Anggota harus diisi' : null,
              onSaved: (val) => newAnggotaModel.noAnggota = val,
            ),
            new Container(
                padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                child: new RaisedButton(
                  child: const Text('Simpan'),
                  onPressed: _submitForm,
                )),
          ],
        ));
  }

  Widget progressHUD(BuildContext context) {
    return ModalProgressHUD(
      child: safeAreaForm(context),
      inAsyncCall: _inAsyncCall,
      // demo of some additional parameters
      opacity: 0.5,
      progressIndicator: CircularProgressIndicator(),
    );
  }

  Widget get tglLahirPicker {
    return new Row(children: <Widget>[
       new LunaDateFormFieldDropDown(
        initialDate: null,
        controller: _controllertglLahir,
        //format: DateFormat("yyyy-MM-dd"),
        decoration: new InputDecoration(
          icon: const Icon(Icons.calendar_view_day),
            hintText: 'Isi Tgl Lahir',
            labelText: 'Tgl Lahir',
        ),

        // keyboardType: TextInputType.text,
        validator: (val) =>
            Functions.dateStringIsValid(val, true) ? null : 'Tgl tidak valid',
        onChanged: (val) => newAnggotaModel.tglLahir = Functions.convertStringToDate(val),
        //onSaved: (val) => newAnggotaModel.tglLahir = convertToDate(val),
        onSaved: (val) => newAnggotaModel.tglLahir =Functions.convertStringToDate(val),
        onFieldSubmitted: (val) => (newAnggotaModel.tglLahir = Functions.convertStringToDate(val)),
      ) ,
      // new IconButton(
      //   icon: new Icon(Icons.more),
      //   tooltip: 'Pilih Tgl',
      //   onPressed: (() {
      //     _chooseDate(context, _controllertglLahir.text);
      //   }),
      // )
    ]);
  }

  Widget get fotoProfilWidget {
    return new Row(children: <Widget>[
      anggotaImage,
      new IconButton(
        icon: new Icon(Icons.camera),
        tooltip: 'Camera',
        onPressed: () {
          showImagePicker(ImageSource.camera);
        },
      ),
      new IconButton(
        icon: new Icon(Icons.photo_library),
        tooltip: 'Ambil Foto',
        onPressed: () {
          showImagePicker(ImageSource.gallery);
        },
      )
    ]);
  }

  // File _image;

  bool imageUpdated = false;
  File imagefileFromPicker;
  var imageMemory;

  Future showImagePicker(ImageSource source) async {
    var imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile == null) {
    } else {
      setState(() {
        //_image=image;
        imageUpdated = true;
        imagefileFromPicker = imageFile;
      });
    }
  }

  String getImageUrl() {
    return anggotaApi.getNetWorkImageUrl(fotoProfilPath);
  }

  getMemoryImage() {
    if (imageMemory == null) {
      return "";
    }
    return imageMemory;
  }

  AssetImage getImageAsset() {
    return AssetImage(IMAGE_PERSON_DEFAULT);
  }

  NetworkImage getNetworkImage() {
    return NetworkImage(getImageUrl() ?? '');

    // return NetworkImage(getImageUrl() ?? '');
  }

  getImageFileFromPicker() {
    if (imagefileFromPicker == null) {
      return "";
    }
    return imagefileFromPicker;
  }

  getImageFromFile(File file) async {
    var urlImage = Uri.parse(file.path);
    var imageMem;
    imageMem = await File.fromUri(urlImage).readAsBytes();
    return imageMem;
  }

  Widget get anggotaImage {
    var anggotaAvatar = new Container(
      // you can explicity set heights and widths on Containers.
      // otherwise they take up as much space as their children.
      width: 100.0,
      height: 100.0,
      // decoration is a property that lets you style the container.
      // It expects a BoxDecoration
      decoration: new BoxDecoration(
        // BoxDecorations have many possible properties
        // Using BoxShape with a background image
        // is the easiest way to make a circle cropped avatar style
        // image.
        shape: BoxShape.circle,
        image: new DecorationImage(
          // Just like CSS's `imagesize` property
          fit: BoxFit.cover,
          // A NetworkImage widget is a widget that
          // takes a URL to an image.
          // ImageProviders (such as NetworkImage)
          // are ideal when your image needs to be laoded or can
          // change.
          // Use the null check to avoid an error.
          //image: (this.widget.anggota.fotoProfil!=null) ? new NetworkImage(this.widget.anggota.fotoProfil ?? '') : AssetImage(this.widget.imageAssetName),
          image: (imageUpdated)
              ? FileImage(imagefileFromPicker)
              : (Functions.isEmpty(fotoProfilPath))
                  ? getImageAsset()
                  : getNetworkImage(),
        ),
      ),
    );

    return anggotaAvatar;
  }

  Widget statusPernikahanDropDown() {
    return new InputDecorator(
      decoration: const InputDecoration(
        icon: const Icon(Icons.lens),
        labelText: 'Status Pernikahan',
      ),
      isEmpty: _statusPernikahan == '',
      child: new DropdownButtonHideUnderline(
        child: new DropdownButton<String>(
          value: _statusPernikahan,
          isDense: true,
          onChanged: (String newValue) {
            setState(() {
              newAnggotaModel.statusPernikahan = newValue;
              _statusPernikahan = newValue;
            });
          },
          items: _statusPernikahanList.map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget statusDalamKeluargaDropDown() {
    return new InputDecorator(
      decoration: const InputDecoration(
        icon: const Icon(Icons.lens),
        labelText: 'Status Dalam Keluarga',
      ),
      isEmpty: _statusDalamKeluarga == '',
      child: new DropdownButtonHideUnderline(
        child: new DropdownButton<String>(
          value: _statusDalamKeluarga,
          isDense: true,
          onChanged: (String newValue) {
            setState(() {
              newAnggotaModel.statusDalamKeluarga = newValue;
              _statusDalamKeluarga = newValue;
            });
          },
          items: _statusDalamKeluargaList.map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget jenisKelaminDropDown() {
    return new InputDecorator(
      decoration: const InputDecoration(
        icon: const Icon(Icons.arrow_drop_down),
        labelText: 'Jenis Kelamin',
      ),
      isEmpty: _jenisKelamin == '',
      child: new DropdownButtonHideUnderline(
        child: new DropdownButton<String>(
          value: _jenisKelamin,
          isDense: true,
          onChanged: (String newValue) {
            setState(() {
              newAnggotaModel.jenisKelamin = newValue;
              _jenisKelamin = newValue;
            });
          },
          items: _jenisKelaminList.map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Future<Null> _chooseDate(
  //     BuildContext context, String initialDateString) async {
  //   var now = new DateTime.now();
  //   var initialDate = Functions.convertStringToDate(initialDateString) ?? now;
  //   initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
  //       ? initialDate
  //       : now);

  //   var result = await showDatePicker(
  //       context: context,
  //       initialDate: initialDate,
  //       firstDate: new DateTime(1900),
  //       lastDate: new DateTime.now());

  //   if (result == null) return;

  //   setState(() {
  //     _controllertglLahir.text = new DateFormat.yMd().format(result);
  //   });
  // }

  bool isValidDob(String dob) {
    if (dob.isEmpty) return true;
    var d = Functions.convertStringToDate(dob);
    return d != null && d.isBefore(new DateTime.now());
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  bool _inAsyncCall = false;
  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      form.save(); //This invokes each onSaved event
      // dismiss keyboard
      // FocusScope.of(context).requestFocus(new FocusNode());
      setState(() {
        _inAsyncCall = true;
      });
      // print('Form save called, newAnggotaModel is now up to date...');
      // print('Email: ${newAnggotaModel.email}');
      // print('Dob: ${newAnggotaModel.tglLahir}');
      // print('Phone: ${newAnggotaModel.noTelpon}');

      // print('Favorite Color: ${newAnggotaModel.statusDalamKeluarga}');
      // print('========================================');
      print('Submitting to back end...');

      if (widget.anggotaModelEdit == null) {
        anggotaApi
            .insertAnggota(newAnggotaModel, imagefileFromPicker)
            // .insertAnggota(newAnggotaModel)
            .then((value) => _processHttpResponse(value));
      } else {
        anggotaApi
            .updateAnggota(newAnggotaModel, imagefileFromPicker)
            .then((value) => _processHttpResponse(value));
      }
    }
  }

  _processHttpResponse(value) {
    try {
      if (value.runtimeType.toString() == 'StreamedResponse') {
        value.stream.transform(utf8.decoder).listen((value) {
          print(value);
          Map<String, dynamic> mapResponse;
          try {
            mapResponse = json.decode(value);
          } catch (err) {
            showMessage("Error : $err,  Data gagal disimpan");
            setState(() {
              _inAsyncCall = false;
            });
            return;
          } finally {
            if (mapResponse["status"] == "ok") {
              setState(() {
                _controllerid.text = mapResponse["data"]["_id"];
                fotoProfilPath = mapResponse["data"]["fotoProfil"] ?? "";

                _inAsyncCall = false;
                imageUpdated = false;
              });
              showMessage("Data tersimpan", Colors.yellow);
            } else {
              showMessage(
                  "Data gagal disimpan ${mapResponse["error"]["message"]}",
                  Colors.red);
              setState(() {
                _inAsyncCall = false;
              });
            }
          }
        });
      } else {
        showMessage("Data gagal disimpan ${value["errmsg"]}", Colors.red);
      }
    } catch (err) {
      showMessage("Data gagal disimpan : $err");
      setState(() {
        _inAsyncCall = false;
      });
    }

    // response data ex : {"status":"ok","message":"Anggota berhasil ditambahkan","data":{"minat":[],"keahlian":[],"_id":"5bc1b7546369ed1470225f2b","noAnggota":"P0001","namaDepan":"Pupita","namaKeluarga":"Mailangkay","tglLahir":"1998-10-12T16:00:00.000Z","jenisKelamin":"Perempuan","statusPernikahan":"Lajang","_idKeluarga":"5bb0dc5ba4bd07409428d3b9","statusDalamKeluarga":"Anak","__v":0},"processedData":{"parameters":{},"queryCount":1},"requestType":{"type":"POST","url":"127.0.0.1","time":"2018-10-13T09:13:56.539Z"}}
  }
}
