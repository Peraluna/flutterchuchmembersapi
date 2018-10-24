import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import './api/KelompokModel.dart';
import './api/KelompokApi.dart';
// import './api/KelompokApiDio.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:image_picker/image_picker.dart';
import './globals/functions.dart';
import 'globals/global.dart';
// import 'CustomWidgets/LunaTextDateField.dart';
import 'CustomWidgets/LunaDateFormFieldDropDown.dart';

class KelompokEntryScreen extends StatefulWidget {
  final ValueChanged<KelompokModel> onSaved;

  final KelompokModel kelompokModel;
  KelompokEntryScreen({Key key, this.kelompokModel, this.onSaved});

  @override
  _KelompokEntryScreenState createState() => _KelompokEntryScreenState();
}

class _KelompokEntryScreenState extends State<KelompokEntryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  KelompokApi kelompokApi = new KelompokApi();
  List<String> _jenisKelompokList = <String>[
    '',
    'Ibadah Kelompok',
    'Ibadah Pemuda',
    'Pelayanan Anggota',
    'Sekolah Sabat Cabang',
    'Ketua Gereja',
    'Pendeta Gereja',
    'Pemuda',
    'Koor',
    'Diakones',
    'Diakon',
    'Kostor',
    'Lain-Lain'
  ];

  String _jenisKelompok = '';
  String fotoProfilPath = '';

  KelompokModel kelompokModelSubmit = new KelompokModel();

  final TextEditingController _controllerid = new TextEditingController();

  // final TextEditingController _controllerjenisKelompok =
  //     new TextEditingController();
  // final TextEditingController _controllerstatusPernikahan =
  //     new TextEditingController();

  final TextEditingController _controllernamaKelompok =
      new TextEditingController();
  final TextEditingController _controllertujuanKelompok =
      new TextEditingController();

  // final TextEditingController _controllerjenisKelamin =
  //     new TextEditingController();
  final TextEditingController _controllerketKelompok =
      new TextEditingController();
  final TextEditingController _controlleridPemimpinKelompok =
      new TextEditingController();
  final TextEditingController _controllertglDibentuk =
      new TextEditingController();

  //  final TextEditingController _controllerminat,
  //   this.keahlian,

  void init() async {
    kelompokApi = new KelompokApi();
    await kelompokApi.init();
  }

  @override
  void initState() {
    // _getData = null;// KelompokApi.fetchKelompokWithKelompok(_namaSearch);

    init();

    _jenisKelompok = '';
    if (widget.kelompokModel != null) {
      _initNewKelompok(widget.kelompokModel);
      _initControllersValue(widget.kelompokModel);

      //kelompokModelSubmit = widget.kelompokModel.toJson();
    } else {
      kelompokModelSubmit = new KelompokModel();
    }

    super.initState();
  }

  _initControllersValue(KelompokModel fromKelompokModel) {
    _controllerid.text = fromKelompokModel.id;

    _controllernamaKelompok.text =Functions.defValueString(fromKelompokModel.namaKelompok);

    _controllertujuanKelompok.text =
        Functions.defValueString(fromKelompokModel.tujuanKelompok);
    _controlleridPemimpinKelompok.text =(fromKelompokModel.idPemimpinKelompok!=null) ? Functions.defValueString(fromKelompokModel.idPemimpinKelompok.id):"";


    _controllerketKelompok.text =
        Functions.defValueString(fromKelompokModel.ketKelompok);

    _controllertglDibentuk.text =
        Functions.getDateStringYYYYMMDD(fromKelompokModel.tglDibentuk);
    if (fromKelompokModel.tglDibentuk != null) {
      _controllertglDibentuk.text =
          DateFormat("yyyy-MM-dd").format(fromKelompokModel.tglDibentuk);
      // _controllertglDibentuk.text = new DateFormat.yMd().format(

      //     Functions.convertStringWithTtoDateTime(kelompokModelSubmit.tglDibentuk));
    } else {
      _controllertglDibentuk.text = "";
    }

    fotoProfilPath = Functions.defValueString(fromKelompokModel.fotoProfil);
  }

  _initNewKelompok(KelompokModel kelompokModel) {
    kelompokModelSubmit = kelompokModel.clone();
    // kelompokModelSubmit = new KelompokModel(
    //   id: kelompokModel.id,
    //   namaKelompok: kelompokModel.namaKelompok,
    //   tujuanKelompok: kelompokModel.tujuanKelompok,
    //   ketKelompok: kelompokModel.ketKelompok,
    //   tglDibentuk: kelompokModel.tglDibentuk,
    //   idPemimpinKelompok: kelompokModel.idPemimpinKelompok,
    //   anggotaKelompok: kelompokModel.anggotaKelompok,
    //   fotoProfil: kelompokModel.fotoProfil,
    // );
  }

  @override
  void dispose() {
    kelompokApi = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text("Entry Kelompok"),
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
            new TextFormField(
              controller: _controllerid,
              decoration: const InputDecoration(
                icon: const Icon(Icons.assignment_ind),
                hintText: '<Auto ID>',
                labelText: 'ID Data',
              ),
              enabled: false,
            ),
            new TextFormField(
              controller: _controllernamaKelompok,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'isi Nama Kelompok',
                labelText: 'Nama Kelompok',
              ),
              inputFormatters: [new LengthLimitingTextInputFormatter(100)],
              validator: (val) => val.isEmpty ? 'Nama harus diisi' : null,
              onSaved: (val) => kelompokModelSubmit.namaKelompok = val,
            ),
            tglDibentukPicker,
            jenisKelompokDropDown(),
            new TextFormField(
              controller: _controllertujuanKelompok,
              maxLength: 500,
              maxLengthEnforced: true,
              maxLines: 5,
              decoration: const InputDecoration(
                icon: const Icon(Icons.data_usage),
                hintText: 'Isi Tujuan Kelompok',
                labelText: 'Tujuan Kelompok',
              ),
              keyboardType: TextInputType.text,
              // validator: (value) =>
              //     (value.isEmpty) ? 'Harap isi ketKelompok' : null,
              onSaved: (val) => kelompokModelSubmit.tujuanKelompok = val,
            ),
            new TextFormField(
              controller: _controllerketKelompok,
              maxLength: 500,
              maxLengthEnforced: true,
              maxLines: 5,
              decoration: const InputDecoration(
                icon: const Icon(Icons.data_usage),
                hintText: 'Isi Ket Kelompok',
                labelText: 'Ket Kelompok',
              ),
              keyboardType: TextInputType.text,
              // validator: (value) =>
              //     (value.isEmpty) ? 'Harap isi ketKelompok' : null,
              onSaved: (val) => kelompokModelSubmit.ketKelompok = val,
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

  Widget get tglDibentukPicker {
    return new Row(children: <Widget>[
      new LunaDateFormFieldDropDown(
        initialDate: null,
        controller: _controllertglDibentuk,
        //format: DateFormat("yyyy-MM-dd"),
        decoration: new InputDecoration(
          icon: const Icon(Icons.calendar_view_day),
          hintText: 'Isi Tgl Dibentuk',
          labelText: 'Tgl Dibentuk',
        ),

        // keyboardType: TextInputType.text,
        validator: (val) =>
            Functions.dateStringIsValid(val, true) ? null : 'Tgl tidak valid',
        onChanged: (val) => kelompokModelSubmit.tglDibentuk =
            Functions.convertStringToDate(val),
        //onSaved: (val) => kelompokModelSubmit.tglDibentuk = convertToDate(val),
        onSaved: (val) => kelompokModelSubmit.tglDibentuk =
            Functions.convertStringToDate(val),
        onFieldSubmitted: (val) => (kelompokModelSubmit.tglDibentuk =
            Functions.convertStringToDate(val)),
      ),
      // new IconButton(
      //   icon: new Icon(Icons.more),
      //   tooltip: 'Pilih Tgl',
      //   onPressed: (() {
      //     _chooseDate(context, _controllertglDibentuk.text);
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
    return kelompokApi.getNetWorkImageUrl(fotoProfilPath);
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

  Widget jenisKelompokDropDown() {
    return new InputDecorator(
      decoration: const InputDecoration(
        icon: const Icon(Icons.lens),
        labelText: 'Jenis Kelompok',
      ),
      isEmpty: _jenisKelompok == '',
      child: new DropdownButtonHideUnderline(
        child: new DropdownButton<String>(
          value: _jenisKelompok,
          isDense: true,
          onChanged: (String newValue) {
            setState(() {
              kelompokModelSubmit.jenisKelompok = newValue;
              _jenisKelompok = newValue;
            });
          },
          items: _jenisKelompokList.map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

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

      print('Submitting to back end...');

      if (widget.kelompokModel == null) {
        kelompokApi
            .insertKelompok(kelompokModelSubmit, imagefileFromPicker)
            // .insertKelompok(kelompokModelSubmit)
            .then((value) => _processHttpResponse(value));
      } else {
        kelompokModelSubmit.anggotaKelompok =null;
        kelompokApi
            .updateKelompok(kelompokModelSubmit, imagefileFromPicker)
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
         setState(() {
        _inAsyncCall = false;
      });
      }
    } catch (err) {
      showMessage("Data gagal disimpan : $err");
      setState(() {
        _inAsyncCall = false;
      });
    }

    // response data ex : {"status":"ok","message":"Kelompok berhasil ditambahkan","data":{"minat":[],"keahlian":[],"_id":"5bc1b7546369ed1470225f2b","noKelompok":"P0001","namaKelompok":"Pupita","namaKelompok":"Mailangkay","tglDibentuk":"1998-10-12T16:00:00.000Z","jenisKelamin":"Perempuan","statusPernikahan":"Lajang","_idPemimpinKelompok":"5bb0dc5ba4bd07409428d3b9","jenisKelompok":"Anak","__v":0},"processedData":{"parameters":{},"queryCount":1},"requestType":{"type":"POST","url":"127.0.0.1","time":"2018-10-13T09:13:56.539Z"}}
  }
}
