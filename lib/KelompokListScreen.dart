import 'package:flutter/material.dart';
import './api/KelompokModel.dart';

import 'dart:async';
import './api/KelompokApi.dart';

import './globals/functions.dart';
import 'CustomWidgets/CircleAvatarLuna.dart';

import 'CustomWidgets/SearchBoxLuna.dart';

import 'KelompokEntryScreen.dart';
import 'AnggotaProfileScreen.dart';
 
import './api/AnggotaModel.dart';
import './AnggotaListScreen.dart';

class KelompokListScreen extends StatefulWidget {
  final String title;
  KelompokListScreen(this.title);
  @override
  _KelompokListScreenState createState() => _KelompokListScreenState();
}

class _KelompokListScreenState extends State<KelompokListScreen> {
  TextEditingController namaSearchTextCtrl =
      new TextEditingController(text: '');
  Future<List<KelompokModel>> _futureData;
  String _namaSearch = '';
  KelompokApi kelompokApi;
  @override
  void initState() {
    // _getData = null;// KelompokApi.fetchKelompokWithKelompok(_namaSearch);
    kelompokApi = new KelompokApi();

    super.initState();
  }

  void _refreshData() {
    if (kelompokApi == null) {
      kelompokApi = new KelompokApi();
    }

    setState(() {
      _futureData = kelompokApi.selectListByNama(namaSearchTextCtrl.text);
    });
    _futureData.then((List<KelompokModel> val) {
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
          IconButton(
            icon: new Icon(Icons.fiber_new),
            onPressed: () {
              _showKelompokEntryScreen(null);
            },
          ),
        ],
        title: new Text("List Kelompok"),
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
            hintText: "isi nama kelompok yang ingin dicari di sini...",
            onRefreshButtonClick: (String value) => _refreshData()),
        Expanded(
          child: futureKelompok(),
        )
      ],
    ));
  }

  Widget futureKelompok() {
    return FutureBuilder<List<KelompokModel>>(
      future: _futureData, // a previously-obtained Future<String> or null
      builder:
          (BuildContext context, AsyncSnapshot<List<KelompokModel>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
                child: Text("Silahkan isi nama kelompok yang ingin dicari"));
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
                child: Text('Kelompok "$_namaSearch" tidak ditemukan'),
              );
            }
        }
      },
    );
  }

  Widget widgetListExpansion(
      BuildContext context, AsyncSnapshot<List<KelompokModel>> snapshot) {
    // List<String> values = snapshot.data;
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        if (snapshot.data[index].anggotaKelompok==null || snapshot.data[index].anggotaKelompok.isEmpty) {
          return widgetKelompokKelompokEmpty(context, snapshot, index);
        } else {
          return widgetKelompokKelompokExists(context, snapshot, index);
        }
      },
    );
  }

  Widget widgetKelompokKelompokExists(BuildContext context,
      AsyncSnapshot<List<KelompokModel>> snapshot, int index) {
    return Column(
      children: <Widget>[
        ExpansionTile(
            // key: PageStorageKey<List<KelompokModel>>(snapshot),
            onExpansionChanged: ((expanded) {
              setState(() {
                _expandedListIndexes[index] = expanded;
              });
            }),
            title: new Text(
              snapshot.data[index].namaKelompok,
              style: new TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
            //backgroundColor: Colors.amber,

            // trailing: Padding(
            //     padding: EdgeInsets.only(right: 30.0),
            //     child: Text(
            //         "${snapshot.data[index].anggotaKelompok.length} orang")),
            trailing: widgetTrailing(context, snapshot, index),
            leading: new CircleAvatarLuna(
                imageNetworkUrl: kelompokApi
                    .getNetWorkImageUrl(snapshot.data[index].fotoProfil)),
            children: _buildExpandableContent(
                context, snapshot.data[index].anggotaKelompok)),
        Divider(
          height: 10.0,
        )
      ],
    );
  }

  Widget widgetTrailing(BuildContext context,
      AsyncSnapshot<List<KelompokModel>> snapshot, int index) {
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
                  _showKelompokEntryScreen(snapshot.data[index]);
                }),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AnggotaListScreen(
                              title: "Pilih Anggota",
                              onChosen: (anggotaDipilihList) {
                          
                                // addAnggota(anggotaDipilihList,snapshot.data[index], index);
                                setState(() {
                                  for (var item in anggotaDipilihList) {
                                    snapshot.data[index].anggotaKelompok
                                        .add(new KelompokAnggotaModel(
                                      id: item.id,
                                      idAnggota: item.id,
                                      jabatan: 'Anggota',
                                    ));
                                  }
                                });
                              })));
                }),
              ),
              IconButton(
                icon: (_expandedListIndexes[index])
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

  _showKelompokEntryScreen(KelompokModel kelompokModel) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => KelompokEntryScreen(
                  kelompokModel: kelompokModel,
                )));
  }

  bool addAnggota(
      AnggotaModel anggotaDipilih, KelompokModel kelompokDipilih, int index) {
    return true;
  }

  showConfirmDialog(BuildContext context) async {
    // 1, 2
    bool value = await Navigator.of(context)
        .push(new MaterialPageRoute<bool>(builder: (BuildContext context) {
      return new Padding(
          padding: const EdgeInsets.all(32.0),
          // 3
          child: new Column(children: [
            new GestureDetector(
                child: new Text('OK'),
                // 4, 5
                onTap: () {
                  Navigator.of(context).pop(true);
                }),
            new GestureDetector(
                child: new Text('NOT OK'),
                // 4, 5
                onTap: () {
                  Navigator.of(context).pop(false);
                })
          ]));
    }));
    // 6
    AlertDialog alert = new AlertDialog(
      content: new Text(
          (value != null) ? "OK was pressed" : "NOT OK or BACK was pressed"),
      actions: <Widget>[
        new FlatButton(
            child: new Text('OK'),
            // 7
            onPressed: () {
              Navigator.of(context).pop();
            })
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  Widget widgetKelompokKelompokEmpty(BuildContext context,
      AsyncSnapshot<List<KelompokModel>> snapshot, int index) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ListTile(
        contentPadding: EdgeInsets.only(top: 20.0, left: 10.0),
        title: Text(
          snapshot.data[index].namaKelompok,
          style: new TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        leading: new CircleAvatarLuna(
            imageNetworkUrl: kelompokApi
                .getNetWorkImageUrl(snapshot.data[index].fotoProfil)),
        trailing: widgetTrailing(context, snapshot, index),
      ),
    );
  }

  _buildExpandableContent(
    BuildContext context,
    List<KelompokAnggotaModel> kelompokAnggotaList,
  ) {
    List<Widget> columnContent = [];
    for (KelompokAnggotaModel content in kelompokAnggotaList) {
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
                        (content.rincianAnggota == null)
                            ? ""
                            : Functions.defValueString(
                                content.rincianAnggota.namaDepan),
                        style: new TextStyle(fontSize: 14.0),
                      ),
                      new Text(
                        (content.rincianAnggota == null)
                            ? ""
                            : Functions.defValueString(
                                content.rincianAnggota.namaKeluarga),
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
                              builder: (context) => AnggotaProfileScreen(
                                  anggota: content.rincianAnggota)));
                    }),
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.edit),
                  //   onPressed: (() {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => AnggotaListScreen(

                  //                 kelompokModel: content)));
                  //   }),
                  // )
                ],
              ),
            ),
            leading: new CircleAvatarLuna(
                imageNetworkUrl: kelompokApi.getNetWorkImageUrl(
                    (content.rincianAnggota == null)
                        ? ""
                        : Functions.defValueString(
                            content.rincianAnggota.fotoProfil))),
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
