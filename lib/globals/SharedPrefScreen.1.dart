//import 'dart:async';

import 'package:flutter/material.dart';

// import 'package:shared_preferences/shared_preferences.dart';
import 'SharedPrefsHelperNonStatic.dart';
import 'global.dart';
import 'functions.dart';
import '../api/DomainApi.dart';
import '../api/DomainModel.dart';

class SharedPrefScreen extends StatefulWidget {
  SharedPrefScreen({Key key}) : super(key: key);
  @override
  _SharedPrefScreenState createState() => _SharedPrefScreenState();
}

class _SharedPrefScreenState extends State<SharedPrefScreen> {
  TextEditingController _controllerServerAddress = new TextEditingController();
  TextEditingController _controllerToken = new TextEditingController();
  TextEditingController _controllerDomainServer = new TextEditingController(text: "mockserver");
 

  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool checkValue = false;
  SharedPrefsHelper sharedPrefsHelper = new SharedPrefsHelper();
  @override
  void initState() {
    // init();
  loadDomains();
    initPrefs();
    super.initState();
  
    
    //   _controllerServerAddress.text = SharedPrefScreenHelper.getPref(EnumPrefsKey.serverAddress)
    // ;
  }

  initPrefs() async {
    sharedPrefsHelper = new SharedPrefsHelper();
    await sharedPrefsHelper.init().then((_) {
      _getPrefs();
    });
  }
 List<String> _domainComboList = <String>[];
  String _domainName = 'general';
  List<DomainModel> domainModelList;
  DomainApi domainApi = new DomainApi();
  loadDomains() async {
    await domainApi.init();
    await domainApi.fetchList().then((List<DomainModel> domainList) {
      domainModelList = domainList;
      for (DomainModel item in domainModelList) {
        _domainComboList.add(item.domainName);
      }

      if (!_domainComboList.contains(_domainName)) {
        _domainName = _domainComboList[0];
      }
      setState(() {});
    });
  }
//     init() async {
// await SharedPrefsHelper.init();
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preferences"),
      ),
      body: new SingleChildScrollView(
        child: _body(),
        scrollDirection: Axis.vertical,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitForm,
        tooltip: 'Save',
        child: const Icon(Icons.save),
      ),
    );
  }

  Widget _body() {
    return Form(
        key: _formKey,
        autovalidate: true,
        child: new Container(
          padding: EdgeInsets.only(right: 20.0, left: 20.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // new Container(
              //   margin: EdgeInsets.all(30.0),
              //   child: new Image.asset(
              //     "assets/images/flutter_icon.png",
              //     height: 100.0,
              //   ),
              // ),
             
              new TextFormField(
                enabled: false,
                controller: _controllerDomainServer,
                decoration: InputDecoration(
                    labelText: "Domain Server",
                    hintText: "Domain Server",
                    hintStyle:
                        new TextStyle(color: Colors.grey.withOpacity(0.3))),
              ),
               domainDropDown,
              new TextFormField(
                controller: _controllerServerAddress,
                decoration: InputDecoration(
                    labelText: "Server Address",
                    hintText: "Server Address",
                    hintStyle:
                        new TextStyle(color: Colors.grey.withOpacity(0.3))),
                // inputFormatters: [new LengthLimitingTextInputFormatter(100)],
                //     validator: (val) => val.isEmpty ? 'Nama harus diisi' : null,
                //     onSaved: (val) => newAnggotaModel.namaDepan = val,
              ),
              new TextFormField(
                enabled: false,
                controller: _controllerToken,
                decoration: InputDecoration(
                    labelText: "Token",
                    hintText: "Token",
                    hintStyle:
                        new TextStyle(color: Colors.grey.withOpacity(0.3))),
              ),
              new TextFormField(
                enabled: false,
                controller: _controllerDomainServer,
                decoration: InputDecoration(
                  labelText: "Nama Organisasi",
                  // hintText: "Token",
                  // hintStyle:
                  //     new TextStyle(color: Colors.grey.withOpacity(0.3))
                ),
              ),
              (_inAsyncCall) ? 
              Center(child: Container(child:CircularProgressIndicator(), width: 40.0,height: 40.0,)) : null,

              // new CheckboxListTile(
              //   value: checkValue,
              //   onChanged: (bool value) { if (value) {setState(() {
              //                 _controllerServerAddress.text="http://10.0.3.2";
              //               });} ;},
              //   title: new Text("Use Dev Server Address"),
              //   controlAffinity: ListTileControlAffinity.leading,
              // ),
              // new Container(
              //   decoration:
              //       new BoxDecoration(border: Border.all(color: Colors.black)),
              //   child: new ListTile(
              //     title: new Text(
              //       "Login",
              //       textAlign: TextAlign.center,
              //     ),
              //     onTap: _navigator,
              //   ),
              // )
            ],
          ),
        ));
  }

 

  Widget get domainDropDown {
    return new InputDecorator(
      decoration: const InputDecoration(
        icon: const Icon(Icons.lens),
        labelText: 'Domain',
      ),
      isEmpty: _domainComboList.length == 0,
      child: new DropdownButtonHideUnderline(
        child: new DropdownButton<String>(
          value: _domainName,
          isDense: true,
          onChanged: (String newValue) {
            setState(() {
              _domainName = newValue;
              int i = _domainComboList.indexOf(newValue);

              _controllerServerAddress.text = domainModelList[i].url;
            });
          },
          items: _domainComboList.map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  bool _inAsyncCall = false;
  void _submitForm() async {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      Functions.showMyDialog(
          context, 'Form is not valid!  Please review and correct.');
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
      print('Saving Preferences...');
      await _savePrefs();
    }
  }

  //SharedPreferences sharedPreferences;
  _savePrefs() async {
    setState(() {
      _inAsyncCall = true;
    });
    await sharedPrefsHelper.setString(
        PREFKEY_DOMAINSERVER, _controllerDomainServer.text);
await sharedPrefsHelper.setString(
        PREFKEY_DOMAINNAME, _domainName);
    await sharedPrefsHelper.setString(
        PREFKEY_DOMAINURL, _controllerServerAddress.text);

    await sharedPrefsHelper.setString(
        PREFKEY_DOMAINNAME, _controllerServerAddress.text);

    print('Done Save Preferences...');
    setState(() {
      _inAsyncCall = false;
    });

    // await sharedPrefsHelper
    //     .setString(PREFKEY_DOMAINURL, _controllerServerAddress.text)
    //     .then((onValue) {
    //   setState(() {
    //     _inAsyncCall = false;
    //   });
    // });
  }

  _getPrefs() async {
    _controllerServerAddress.text =
        await sharedPrefsHelper.getString(PREFKEY_DOMAINURL);
    _controllerToken.text = await sharedPrefsHelper.getString(PREFKEY_TOKEN);
    _controllerDomainServer.text = await sharedPrefsHelper.getString(PREFKEY_DOMAINSERVER);
    _domainName = await sharedPrefsHelper.getString(PREFKEY_DOMAINNAME);

    setState(() {});
    // sharedPrefsHelper.getString(PREFKEY_DOMAINURL).then((onValue) {
    //   _controllerServerAddress.text = onValue;
    // sharedPrefsHelper.getString(PREFKEY_DOMAINURL).then((onValue) {
    //   _controllerServerAddress.text = onValue;
    // });
    // sharedPrefsHelper.getString(PREFKEY_TOKEN).then((onValue) {
    //   _controllerToken.text = onValue;
    // });
  }
}
