import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:async';


import './api/KelompokApi.dart';
// import './api/KelompokApiDio.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:image_picker/image_picker.dart';
import './globals/functions.dart';
import 'globals/global.dart';
// import 'CustomWidgets/LunaTextDateField.dart';
import 'CustomWidgets/LunaDateFormFieldDropDown.dart';
import './api/KelompokModel.dart';

class KelompokAnggotaEntryScreen extends StatefulWidget {
  final ValueChanged<KelompokAnggotaModel> onSaved;
  final String idKelompok;
  final String namaKelompok;
  final KelompokAnggotaModel anggotaModelEdit;
  KelompokAnggotaEntryScreen(
      {Key key,
      @required this.idKelompok,
      @required this.namaKelompok,
      this.anggotaModelEdit,
      this.onSaved});

  @override
  _KelompokAnggotaEntryScreenState createState() => _KelompokAnggotaEntryScreenState();
}

class _KelompokAnggotaEntryScreenState extends State<KelompokAnggotaEntryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  KelompokApi kelompokApi = new KelompokApi();
  List<String> _jabatanList = <String>[
    '',
    'Anggota',
    'Sekertaris',
    'Bendahara',
    'Wakil',
    'Ketua',
 
    'Lain-Lain'
  ];
  String _jabatan = '';
 

  KelompokAnggotaModel newKelompokAnggotaModel;
  String fotoProfilPath = '';

    final TextEditingController _controlleridKelompok =
      new TextEditingController();
  

  final TextEditingController _controllerNamaKelompok =
      new TextEditingController();

  final TextEditingController _controllertglJabatan = new TextEditingController();
  final TextEditingController _controllerid = new TextEditingController();
 
 
  final TextEditingController _controllernamaDepan =
      new TextEditingController();
 
  final TextEditingController _controllernamaKeluarga =
      new TextEditingController();
 
  // final TextEditingController _controllerjenisKelamin =
  //     new TextEditingController();
  final TextEditingController _controlleralamat = new TextEditingController();

  
  final TextEditingController _controllernoTelpon = new TextEditingController();
  final TextEditingController _controlleremail = new TextEditingController();
  final TextEditingController _controlleridUser = new TextEditingController();

  //  final TextEditingController _controllerminat,
  //   this.keahlian,

  void init() async {
    kelompokApi = new KelompokApi();
    await kelompokApi.init();
  }

  @override
  void initState() {
    // _getData = null;// KeluargaApi.fetchKeluargaWithAnggota(_namaSearch);

    init();
    newKelompokAnggotaModel = new KelompokAnggotaModel();
       _controlleridKelompok.text = widget.idKelompok;
_controllerNamaKelompok.text=widget.namaKelompok;

 
    if (widget.anggotaModelEdit != null) {
      _initControllersValue(widget.anggotaModelEdit);
      _initNewAnggota(widget.anggotaModelEdit);
    } else {

   
    }
    super.initState();
  }

  _initControllersValue(KelompokAnggotaModel anggotaModelEdit) {
    _controllerid.text = anggotaModelEdit.id;
    _jabatan = anggotaModelEdit.jabatan;
    _controllernamaDepan.text = anggotaModelEdit.rincianAnggota.namaDepan;
    _controllernamaKeluarga.text = anggotaModelEdit.rincianAnggota.namaKeluarga;
    _controllertglJabatan.text =Functions.getDateStringYYYYMMDD( anggotaModelEdit.tglJabatan);
    if ( anggotaModelEdit.tglJabatan !=null) {
      _controllertglJabatan.text = DateFormat("yyyy-MM-dd").format(
           anggotaModelEdit.tglJabatan);
      // _controllertglJabatan.text = new DateFormat.yMd().format(

      //     Functions.convertStringWithTtoDateTime(anggotaModelEdit.tglJabatan));
    } else {
      _controllertglJabatan.text = "";
    }

 
    _controllernoTelpon.text =Functions.defValueString(anggotaModelEdit.rincianAnggota.noTelpon);
    _controlleremail.text = anggotaModelEdit.rincianAnggota.email;
    _controlleridUser.text = anggotaModelEdit.rincianAnggota.idUser;
    fotoProfilPath = anggotaModelEdit.rincianAnggota.fotoProfil;
  }

  _initNewAnggota(KelompokAnggotaModel anggotaModelEdit) {
    newKelompokAnggotaModel = anggotaModelEdit.copy();
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
                    controller: _controlleridKelompok,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.yellow, fontSize: 12.0),
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'ID Kelompok',
                      labelText: 'ID Kelompok',
                    ),
                    enabled: false,
                   // onSaved: (val) => newKelompokAnggotaModel.idKelompok = val,
                  ),
                  Text(
                    widget.namaKelompok,
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
              onSaved: (val) => newKelompokAnggotaModel.idAnggota = val,
            ),
   
            tglJabatanPicker,
         
            jabatanDropDown(),
            new TextFormField(
              enabled: false,
              controller: _controllernoTelpon,
              style: TextStyle( ),
              decoration: const InputDecoration(
                icon: const Icon(Icons.phone),
                hintText: '',
                labelText: 'No. Telpon',
              ),
             
              
    
              
            ),
            new TextFormField(
              enabled: false,
              controller: _controlleremail,
              decoration: const InputDecoration(
                icon: const Icon(Icons.email),
                hintText: '',
                labelText: 'Email',
              ),
            
            ),
            new TextFormField(
              enabled: false,
              controller: _controlleralamat,
              decoration: const InputDecoration(
                icon: const Icon(Icons.data_usage),
                hintText: '',
                labelText: 'Alamat',
              ),
           
               
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

  Widget get tglJabatanPicker {
    return new Row(children: <Widget>[
       new LunaDateFormFieldDropDown(
        initialDate: null,
        controller: _controllertglJabatan,
        //format: DateFormat("yyyy-MM-dd"),
        decoration: new InputDecoration(
          icon: const Icon(Icons.calendar_view_day),
            hintText: 'Isi Tgl Lahir',
            labelText: 'Tgl Lahir',
        ),

        // keyboardType: TextInputType.text,
        validator: (val) =>
            Functions.dateStringIsValid(val, true) ? null : 'Tgl tidak valid',
        onChanged: (val) => newKelompokAnggotaModel.tglJabatan = Functions.convertStringToDate(val),
        //onSaved: (val) => newKelompokAnggotaModel.tglJabatan = convertToDate(val),
        onSaved: (val) => newKelompokAnggotaModel.tglJabatan =Functions.convertStringToDate(val),
        onFieldSubmitted: (val) => (newKelompokAnggotaModel.tglJabatan = Functions.convertStringToDate(val)),
      ) ,
      // new IconButton(
      //   icon: new Icon(Icons.more),
      //   tooltip: 'Pilih Tgl',
      //   onPressed: (() {
      //     _chooseDate(context, _controllertglJabatan.text);
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
 

  Widget jabatanDropDown() {
    return new InputDecorator(
      decoration: const InputDecoration(
        icon: const Icon(Icons.lens),
        labelText: 'Status Dalam Keluarga',
      ),
      isEmpty: _jabatan == '',
      child: new DropdownButtonHideUnderline(
        child: new DropdownButton<String>(
          value: _jabatan,
          isDense: true,
          onChanged: (String newValue) {
            setState(() {
              newKelompokAnggotaModel.jabatan = newValue;
              _jabatan = newValue;
            });
          },
          items: _jabatanList.map((String value) {
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
  //     _controllertglJabatan.text = new DateFormat.yMd().format(result);
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
      // print('Form save called, newKelompokAnggotaModel is now up to date...');
      // print('Email: ${newKelompokAnggotaModel.email}');
      // print('Dob: ${newKelompokAnggotaModel.tglJabatan}');
      // print('Phone: ${newKelompokAnggotaModel.noTelpon}');

      // print('Favorite Color: ${newKelompokAnggotaModel.jabatan}');
      // print('========================================');
      print('Submitting to back end...');

      if (widget.anggotaModelEdit == null) {
        kelompokApi
            .insertAnggota(newKelompokAnggotaModel)
            // .insertAnggota(newKelompokAnggotaModel)
            .then((value) => _processHttpResponse(value));
      } else {
        kelompokApi
            .updateAnggota(newKelompokAnggotaModel)
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

    // response data ex : {"status":"ok","message":"Anggota berhasil ditambahkan","data":{"minat":[],"keahlian":[],"_id":"5bc1b7546369ed1470225f2b","noAnggota":"P0001","namaDepan":"Pupita","namaKeluarga":"Mailangkay","tglJabatan":"1998-10-12T16:00:00.000Z","jenisKelamin":"Perempuan","statusPernikahan":"Lajang","_idKelompok":"5bb0dc5ba4bd07409428d3b9","jabatan":"Anak","__v":0},"processedData":{"parameters":{},"queryCount":1},"requestType":{"type":"POST","url":"127.0.0.1","time":"2018-10-13T09:13:56.539Z"}}
  }
}
