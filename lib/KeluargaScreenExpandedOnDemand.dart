import 'package:flutter/material.dart';
import './api/KeluargaModel.dart';
import './api/AnggotaModel.dart';
import 'dart:async';
import './api/KeluargaApi.dart';

// import './globals/global.dart';
import 'CustomWidgets/CircleAvatarLuna.dart';

import 'CustomWidgets/SearchBoxLuna.dart';
import 'AnggotaProfileScreen.dart';
import 'AnggotaEntryScreen.dart';

class KeluargaScreenExpandedOnDemand extends StatefulWidget {
  final String title;
  KeluargaScreenExpandedOnDemand(this.title);
  @override
  _KeluargaScreenExpandedOnDemandState createState() => _KeluargaScreenExpandedOnDemandState();
}

class _KeluargaScreenExpandedOnDemandState extends State<KeluargaScreenExpandedOnDemand> {
  TextEditingController namaSearchTextCtrl =
      new TextEditingController(text: '');
  Future<List<KeluargaModel>> _futureData;
  String _namaSearch = '';
  KeluargaApi keluargaApi;
  @override
  void initState() {
    // _getData = null;// KeluargaApi.fetchKeluargaWithAnggota(_namaSearch);
    keluargaApi = new KeluargaApi();
   

    super.initState();
  }

  void _refreshData() {
    if (keluargaApi == null) {
      keluargaApi = new KeluargaApi();
    }

    setState(() {
      _futureData =
          keluargaApi.fetchKeluargaWithAnggotaSimple(namaSearchTextCtrl.text);
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
        title: new Text("List Keluarga"),
      ),
      body: dataLayout(),
    );
  }

  Widget dataLayout() {
    return Container(
        child: Column(
      children: <Widget>[
        SearchBoxLuna(
            editingControllerSearch: namaSearchTextCtrl,
            hintText: "isi nama keluarga di sini...",
            onRefreshButtonClick: (String value) => _refreshData()),
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
    return FutureBuilder<List<KeluargaModel>>(
      future: _futureData, // a previously-obtained Future<String> or null
      builder:
          (BuildContext context, AsyncSnapshot<List<KeluargaModel>> snapshot) {
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
                child: Text('Keluarga "$_namaSearch" tidak ditemukan'),
              );
            }
        }
      },
    );
  }

  Widget listExpanded(
      BuildContext context, AsyncSnapshot<List<KeluargaModel>> snapshot) {
    // List<String> values = snapshot.data;
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        if (snapshot.data[index].anggotaKeluarga.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(10.0),
            child: ListTile(
                contentPadding: EdgeInsets.only(top: 20.0, left: 10.0),
                title: Text(
                  snapshot.data[index].namaKeluarga,
                  style: new TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                leading: new CircleAvatarLuna(
                    imageNetworkUrl: keluargaApi
                        .getNetWorkImageUrl(snapshot.data[index].fotoProfil)),
                trailing: Column(children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: (() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AnggotaEntryScreen(
                                    idKeluarga: snapshot.data[index].id,
                                    namaKeluarga:
                                        snapshot.data[index].namaKeluarga,
                                  )));
                    }),
                    
                  ),
                   IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: (() {
                       loadAnggotaKeluarga(snapshot , index);
                    }),
                    
                  ),
                ])),
          ); //backgroundColor: Colors.amber,

        }

        return Column(
          children: <Widget>[
            ExpansionTile(
                // key: PageStorageKey<List<KeluargaModel>>(snapshot),

                title: new Text(
                  snapshot.data[index].namaKeluarga,
                  style: new TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                //backgroundColor: Colors.amber,

                // trailing: Padding(
                //     padding: EdgeInsets.only(right: 30.0),
                //     child: Text(
                //         "${snapshot.data[index].anggotaKeluarga.length} orang")),
                leading: new CircleAvatarLuna(
                    imageNetworkUrl: keluargaApi
                        .getNetWorkImageUrl(snapshot.data[index].fotoProfil)),
                // onExpansionChanged: (value)   {if (value) {

                // }},
                children: _buildExpandableContent(
                    context,
                    snapshot.data[index].anggotaKeluarga,
                    snapshot.data[index].id,
                    snapshot.data[index].namaKeluarga)),
                  
            Divider(
              height: 10.0,
            )
          ],
        );
      },
    );
  }

//Future <List<AnggotaModel>> _anggotaKeluarga;
loadAnggotaKeluarga(AsyncSnapshot<List<KeluargaModel>> snapshot, int listIndex) {
  AnggotaModel newAnggota=new AnggotaModel();
  newAnggota.namaDepan = "test";
  newAnggota.statusDalamKeluarga="test"; 
  snapshot.data[listIndex].anggotaKeluarga.add(newAnggota);
}
  _buildExpandableContent(BuildContext context, List<AnggotaModel> anggotaList,
      String idKeluarga, String namaKeluarga) {
    List<Widget> columnContent = [];
    for (AnggotaModel content in anggotaList) {
      columnContent.add(Divider(
        height: 10.0,
      ));
      columnContent.add(
        Padding(
          padding: const EdgeInsets.only(left: 60.0),
          child: new ListTile(
            title: Container(
              decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(5.0)),
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      new Text(
                        content.namaDepan,
                        style: new TextStyle(fontSize: 14.0),
                      ),
                      new Text(
                        content.statusDalamKeluarga,
                        style: new TextStyle(
                            fontSize: 12.0, color: Colors.lightBlue),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.more),
                    onPressed: (() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AnggotaProfileScreen(anggota: content)));
                    }),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: (() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AnggotaEntryScreen(
                                  idKeluarga: idKeluarga,
                                  namaKeluarga: namaKeluarga,
                                  anggotaModelEdit: content)));
                    }),
                  )
                ],
              ),
            ),
            leading: new CircleAvatarLuna(
                imageNetworkUrl:
                    keluargaApi.getNetWorkImageUrl(content.fotoProfil)),
          ),
        ),
      );
    }
    columnContent.add(Divider(
      height: 10.0,
    ));
    return columnContent;
  }
}
