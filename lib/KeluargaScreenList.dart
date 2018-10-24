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

class KeluargaScreenList extends StatefulWidget {
  final String title;
  KeluargaScreenList(this.title);
  @override
  _KeluargaScreenListState createState() => _KeluargaScreenListState();
}

class _KeluargaScreenListState extends State<KeluargaScreenList> {
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
    _futureData.then((List<KeluargaModel> val) {
      setState(() {
        _expandedListIndexes.clear();
        int count = val.length;
        for (var i = 0; i < count; i++) {
          _expandedListIndexes.add(false);
        }
      });
    });
  }

  List<bool> _expandedListIndexes = [];

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
              return widgetListExpansion(context, snapshot);
            } else {
              return Center(
                child: Text('Keluarga "$_namaSearch" tidak ditemukan'),
              );
            }
        }
      },
    );
  }

  Widget widgetListExpansion(
      BuildContext context, AsyncSnapshot<List<KeluargaModel>> snapshot) {
    // List<String> values = snapshot.data;
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        if (snapshot.data[index].anggotaKeluarga.isEmpty) {
          return widgetAnggotaKeluargaEmpty(context, snapshot, index);
        } else {
          return widgetAnggotaKeluargaExists(context, snapshot, index);
        }
      },
    );
  }

  Widget widgetAnggotaKeluargaExists(BuildContext context,
      AsyncSnapshot<List<KeluargaModel>> snapshot, int index) {
    return Column(
      children: <Widget>[
        ExpansionTile(
            // key: PageStorageKey<List<KeluargaModel>>(snapshot),
            onExpansionChanged: ((expanded) {
              setState(() {
                _expandedListIndexes[index] = expanded;
              });
            }),
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
            trailing: widgetTrailing(context, snapshot, index),
            leading: new CircleAvatarLuna(
                imageNetworkUrl: keluargaApi
                    .getNetWorkImageUrl(snapshot.data[index].fotoProfil)),
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
  }

  Widget widgetTrailing(BuildContext context,
      AsyncSnapshot<List<KeluargaModel>> snapshot, int index) {
    return Column(
      children: <Widget>[
        Container(
          height: 40.0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AnggotaEntryScreen(
                                idKeluarga: snapshot.data[index].id,
                                namaKeluarga: snapshot.data[index].namaKeluarga,
                              )));
                }),
              ),
               
              IconButton(
                icon: (_expandedListIndexes[index] )
                    ? Icon(Icons.zoom_out)
                    : Icon(Icons.zoom_in),
                onPressed: (() {}),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget widgetAnggotaKeluargaEmpty(BuildContext context,
      AsyncSnapshot<List<KeluargaModel>> snapshot, int index) {
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
        trailing: widgetTrailing(context, snapshot, index),
      ),
    );
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
