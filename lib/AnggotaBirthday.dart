import 'package:flutter/material.dart';
import './api/AnggotaModel.dart';
 
import 'dart:async';
import './api/AnggotaApi.dart';

// import './globals/global.dart';
import 'CustomWidgets/CircleAvatarLuna.dart';
import 'CustomWidgets/LunaTextDateField.dart';

import 'globals/functions.dart';
import 'AnggotaProfileScreen.dart';
import 'package:intl/intl.dart';
 

class AnggotaBirthday extends StatefulWidget {
  final String title;
  AnggotaBirthday(this.title);
  @override
  _AnggotaBirthdayState createState() => _AnggotaBirthdayState();
}

class _AnggotaBirthdayState extends State<AnggotaBirthday> {
  TextEditingController namaSearchTextCtrl =
      new TextEditingController(text: '');
  Future<List<AnggotaModel>> _futureData;
   
  AnggotaApi anggotaApi;


  @override
  void initState() {
    // Bear in mind that Flutter expects initState to be synchronous
    anggotaApi = new AnggotaApi();
     month=DateTime.now().month.toString();

    super.initState();
  }

/// Incidentally, Function myFunc() async { } isn't valid Dart. 
/// Function here is the return value, but async requires that the return value 
/// be a Future<something>.

  void _refreshData()   {
    if (anggotaApi == null) {
      anggotaApi = new AnggotaApi();
    }
     // _futureData =   anggotaApi.fetchBirthdays(month);
    setState(() {
     _futureData =   anggotaApi.fetchBirthdays(month);
      // _futureData =
      //      anggotaApi.fetchBirthdays(month);
    });
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context); // from keep alive mixin.

    return mainLayout();
  }

  Widget mainLayout() {
    return Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.refresh),
            onPressed: () {
              _refreshData();
            },
          ),
        ],
        title: new Text("List HUT Anggota"),
      ),
      body: dataLayout(),
    );
  }

  String month;
  Widget dataLayout() {
    return Container(
        child: Column(
      children: <Widget>[
        Row(children: <Widget>[
   Text("Bulan : ") ,
        LunaTextDateField( showPickButton: false, showDay: false, showYear: false, initialDate: DateTime.now(), 
        onChanged:( value) {
           month=Functions.convertStringToDate(value).month.toString();
           _refreshData();
        } ,
        ),

       
            IconButton(
          icon: new Icon(Icons.refresh),
          alignment: Alignment.centerRight,
          onPressed: () {
            _refreshData();
          },
        ),
        ]),
        Expanded(
          child: futureKeluarga(),
        )
      ],
    ));
  }

  // Widget searchBoxExpanded() {
  //   return Row(
  //     children: <Widget>[
  //       Expanded(
  //         child: Padding(
  //           padding: const EdgeInsets.only(left: 10.0),
  //           child: Container(
  //             decoration: BoxDecoration(
  //                 // color: const Color(0x0),
  //                 border: Border.all(
  //                   color: Colors.teal,
  //                   width: 1.0,
  //                 ),
  //                 borderRadius: BorderRadius.all(Radius.circular(5.0))),
  //             child: TextField(
  //               controller: namaSearchTextCtrl,
  //               decoration: new InputDecoration.collapsed(
  //                 hintText: 'Ketik Nama Keluarga disini',
  //                 hintStyle: TextStyle(fontSize: 12.0),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //       IconButton(
  //         icon: new Icon(Icons.refresh),
  //         alignment: Alignment.centerRight,
  //         onPressed: () {
  //           _refreshData();
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget futureKeluarga() {
    return FutureBuilder<List<AnggotaModel>>(
      future: _futureData, // a previously-obtained Future<String> or null
      builder:
          (BuildContext context, AsyncSnapshot<List<AnggotaModel>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
                child: Text("Silahkan isi nama keluarga yang ingin dicari"));
          case ConnectionState.waiting:
            return new Center(
              widthFactor: 48.0,
              heightFactor: 48.0,
              child: CircularProgressIndicator(),
            ); // Text('loading...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else if (snapshot.hasData) {
              return listExpanded(context, snapshot);
            } else {
              return Center(
                child: Text('Tidak ada data untuk bulan "$month"'),
              );
            }
        }
      },
    );
  }
 

  Widget listExpanded(
      BuildContext context, AsyncSnapshot<List<AnggotaModel>> snapshot) {
    // List<String> values = snapshot.data;
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
         
          return Padding(
            padding: EdgeInsets.all(10.0),
            child: ListTile(
                contentPadding: EdgeInsets.only(top: 20.0, left: 10.0),
                title: Column(
                  children: <Widget>[
                    Text(
                      "${snapshot.data[index].namaDepan} ${snapshot.data[index].namaKeluarga}" ,
                      style: new TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  Text(new DateFormat("dd-MMM-yyyy").format(snapshot.data[index].tglLahir),
                      
                      style: new TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    Text("HUT ke : " + Functions.findAge(snapshot.data[index].tglLahir).toString(),
                      
                      style: new TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    )],
                ),
                leading: new CircleAvatarLuna(
                    imageNetworkUrl:   anggotaApi
                        .getNetWorkImageUrl(snapshot.data[index].fotoProfil)),
                trailing: Column(children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.details),
                    onPressed: (() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AnggotaProfileScreen(
                                    anggota: snapshot.data[index],
                                     
                                  )));
                    }),
                  ),
                ])),
          ); //backgroundColor: Colors.amber,
 
 
      },
    );
  }
}
