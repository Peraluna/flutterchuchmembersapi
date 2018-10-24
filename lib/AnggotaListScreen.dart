import 'package:flutter/material.dart';
import './api/AnggotaModel.dart';
 
import 'dart:async';
import './api/AnggotaApi.dart';

// import './globals/global.dart';
// import 'CustomWidgets/CircleAvatarLuna.dart';

import 'CustomWidgets/SearchBoxLuna.dart';
//import 'AnggotaProfileScreen.dart';
//import 'AnggotaEntryScreen.dart';

class AnggotaListScreen extends StatefulWidget {
  final String title;

  final ValueChanged<List<AnggotaModel>> onChosen;
  AnggotaListScreen({this.title, @required this.onChosen});
  @override
  _AnggotaListScreenState createState() => _AnggotaListScreenState();
}

class _AnggotaListScreenState extends State<AnggotaListScreen> {
  TextEditingController namaSearchTextCtrl =
      new TextEditingController(text: '');
  Future<List<AnggotaModel>> _futureData;
  String _namaSearch = '';
  AnggotaApi anggotaApi;
  @override
  void initState() {
    // _getData = null;// AnggotaApi.fetchAnggotaWithAnggota(_namaSearch);
    anggotaApi = new AnggotaApi();

    super.initState();
  }

  void _refreshData() {
    if (anggotaApi == null) {
      anggotaApi = new AnggotaApi();
    }

    setState(() {
      _futureData = anggotaApi.fetchAnggotaList(namaSearchTextCtrl.text);
    });
    _futureData.then((List<AnggotaModel> val) {
      setState(() {
        _selectedListIndexes.clear();
        int count = val.length;
        for (var i = 0; i < count; i++) {
          _selectedListIndexes.add(null);
        }
      });
    });
  }

  List<AnggotaModel> _selectedListIndexes = [];

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
        title: new Text("List Anggota"),
      ),
      body: dataLayout(),
    );
  }

  Widget dataLayout() {
    return Container(
        child: Column(
      children: <Widget>[
        IconButton(
          onPressed: () {
            List<AnggotaModel> anggotaChosenList;
            for (var i = 0; i < _selectedListIndexes.length; i++) {
              if (_selectedListIndexes[i]!=null) {
                anggotaChosenList.add(_selectedListIndexes[i]);
              }
            }
            widget.onChosen(anggotaChosenList);
          },
          icon: Icon(Icons.add),
        ),
        SearchBoxLuna(
            editingControllerSearch: namaSearchTextCtrl,
            hintText: "isi nama anggota di sini...",
            onRefreshButtonClick: (String value) => _refreshData()),
        Expanded(
          child: futureAnggota(),
        )
      ],
    ));
  }

  Widget futureAnggota() {
    return FutureBuilder<List<AnggotaModel>>(
      future: _futureData, // a previously-obtained Future<String> or null
      builder:
          (BuildContext context, AsyncSnapshot<List<AnggotaModel>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
                child: Text("Silahkan isi nama anggota yang ingin dicari"));
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
                child: Text('Anggota "$_namaSearch" tidak ditemukan'),
              );
            }
        }
      },
    );
  }

  Widget widgetListExpansion(
      BuildContext context, AsyncSnapshot<List<AnggotaModel>> snapshot) {
    // List<String> values = snapshot.data;
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        return widgetAnggotaList(context, snapshot, index);
      },
    );
  }

  Widget widgetTrailing(BuildContext context,
      AsyncSnapshot<List<AnggotaModel>> snapshot, int index) {
    return Column(
      children: <Widget>[
        Container(
          height: 40.0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // IconButton(
              //   icon: Icon(Icons.add),
              //   onPressed: (() {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => AnggotaEntryScreen(
              //                   idAnggota: snapshot.data[index].id,
              //                   namaDepan: snapshot.data[index].namaDepan,
              //                 )));
              //   }),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget widgetAnggotaList(BuildContext context,
      AsyncSnapshot<List<AnggotaModel>> snapshot, int index) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: CheckboxListTile(
        value: _selectedListIndexes[index] != null,
        onChanged: (selected) {
          if (selected) {
            setState(() {
              _selectedListIndexes[index] = snapshot.data[index];
            });
          } else {
            setState(() {
              _selectedListIndexes[index] = null;
            });
          }
        },

        title: Text(
          "${snapshot.data[index].namaDepan} ${snapshot.data[index].namaKeluarga}",
          style: new TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        // leading: new CircleAvatarLuna(
        //     imageNetworkUrl: anggotaApi
        //         .getNetWorkImageUrl(snapshot.data[index].fotoProfil)),
      ),
    );
  }

  // _buildExpandableContent(BuildContext context, List<AnggotaModel> anggotaList,
  //     String idAnggota, String namaDepan) {
  //   List<Widget> columnContent = [];
  //   for (AnggotaModel content in anggotaList) {
  //     columnContent.add(Divider(
  //       height: 10.0,
  //     ));
  //     columnContent.add(
  //       Padding(
  //         padding: const EdgeInsets.only(left: 60.0),
  //         child: new ListTile(
  //           title: Container(
  //             decoration: BoxDecoration(
  //                 color: Colors.white10,
  //                 borderRadius: BorderRadius.circular(5.0)),
  //             child: Row(
  //               children: <Widget>[
  //                 Column(
  //                   children: <Widget>[
  //                     new Text(
  //                       content.namaDepan,
  //                       style: new TextStyle(fontSize: 14.0),
  //                     ),
  //                     new Text(
  //                       content.statusDalamAnggota,
  //                       style: new TextStyle(
  //                           fontSize: 12.0, color: Colors.lightBlue),
  //                     ),
  //                   ],
  //                 ),
  //                 IconButton(
  //                   icon: Icon(Icons.more),
  //                   onPressed: (() {
  //                     Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (context) =>
  //                                 AnggotaProfileScreen(anggota: content)));
  //                   }),
  //                 ),
  //                 IconButton(
  //                   icon: Icon(Icons.edit),
  //                   onPressed: (() {
  //                     Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (context) => AnggotaEntryScreen(
  //                                 idAnggota: idAnggota,
  //                                 namaDepan: namaDepan,
  //                                 anggotaModelEdit: content)));
  //                   }),
  //                 )
  //               ],
  //             ),
  //           ),
  //           leading: new CircleAvatarLuna(
  //               imageNetworkUrl:
  //                   anggotaApi.getNetWorkImageUrl(content.fotoProfil)),
  //         ),
  //       ),
  //     );
  //   }
  //   columnContent.add(Divider(
  //     height: 10.0,
  //   ));
  //   return columnContent;
  // }
}
