import 'package:flutter/material.dart';
import './api/KeluargaModel.dart';
import 'dart:async';
import './api/KeluargaApi.dart';

// import './globals/global.dart';
import 'CustomWidgets/CircleAvatarLuna.dart';
 
import 'CustomWidgets/SearchBoxLuna.dart';
 
class KeluargaScreen extends StatefulWidget {
  final String title;
  KeluargaScreen(this.title);
  @override
  _KeluargaScreenState createState() => _KeluargaScreenState();
}

class _KeluargaScreenState extends State<KeluargaScreen> {
  KeluargaApi keluargaApi ;

  
  TextEditingController namaSearchTextCtrl =
      new TextEditingController(text: '');
  Future<List<KeluargaModel>> _getData;
  String _namaSearch = '';
  @override
  void initState() {
    // _getData = null;// KeluargaApi.fetchKeluargaWithAnggota(_namaSearch);
    keluargaApi=new KeluargaApi( );
   
    super.initState();
  }

  _refreshData() async {
    setState(() {
      _namaSearch = namaSearchTextCtrl.text;
      _getData =  keluargaApi.fetchKeluargaWithAnggota(_namaSearch);
      // _namaSearch=namaSearchTextCtrl.text;
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
      future: _getData, // a previously-obtained Future<String> or null
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
              return createListView(context, snapshot);
            } else {
              return Center(
                child: Text('Keluarga "$_namaSearch" tidak ditemukan'),
              );
            }
        }
      },
    );
  }
  
Widget createListView(
    BuildContext context, AsyncSnapshot<List<KeluargaModel>> snapshot) {
  // List<String> values = snapshot.data;
  return ListView.builder(
    itemCount: snapshot.data.length,
    itemBuilder: (BuildContext context, int index) {
      return new Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: (index % 2 == 0) ? Colors.amber : Colors.lightGreen),
            child: ListTile(
                title: Text(snapshot.data[index].namaKeluarga),
                subtitle: Text(snapshot.data[index].alamat),
                // onTap: ()=> AlertDialog( title: Text("Tap"), content: Text(snapshot.data[index].namaKeluarga),
                // actions: <Widget>[RaisedButton(onPressed: ()=> Navigator.pop(context) , child: Text("Ok") ,elevation: 10.0,color: Colors.blue, )],),
                // leading: CircleAvatar(
                //   maxRadius: 24.0,
                //   child: (snapshot.data[index].fotoProfil == null)
                //       ? Text("")
                //       : Image.network(getNetWorkImageUrl(snapshot.data[index].fotoProfil)),
                //  // backgroundImage:  NetworkImage(getNetWorkImageUrl(snapshot.data[index].fotoProfil))
                // ),
                onTap: () {
                  _showSnackBar(context, snapshot.data[index]);
                },
                leading: CircleAvatarLuna(
                    imageNetworkUrl: keluargaApi.getNetWorkImageUrl(
                        snapshot.data[index].fotoProfil))),
          ),
          new Divider(
            height: 2.0,
          ),
        ],
      );
    },
  );
}

_showSnackBar(BuildContext context, KeluargaModel item) {
  final SnackBar objSnackbar = new SnackBar(
    content: new Text(
        "Keluarga ${item.namaKeluarga} memiliki ${item.anggotaKeluarga.length} anggota keluarga"),
    backgroundColor: Colors.amber,
  );
  Scaffold.of(context).showSnackBar(objSnackbar);
}
}

// Widget circleAvatar(String imageUrl) {
//   return new Container(
//   height: 60.0,
//   width: 60.0,
//   decoration: new BoxDecoration(
//     shape: BoxShape.circle,
//     border: Border.all(color: const Color(0x33A6A6A6)),
//     // image: new Image.asset(_image.)
//     image: new DecorationImage(
//       fit: BoxFit.fill,
//       image: (imageUrl==null) ?  AssetImage('assets/family.jpg') :NetworkImage(imageUrl),
//     )
//   ),
//   // child: (imageUrl==null) ? new Image(image:  AssetImage('assets/family.jpg')) : new Image.network(imageUrl),
// );
// }

// String getNetWorkImageUrl(String imagePartUrl) {
//   String url = "$SERVER_ADDR/$imagePartUrl";
//   if (imagePartUrl == null) {
//     return null;
//   }
//   //String fileName = url.substring(url.lastIndexOf('/') + 1);
//   url = url.replaceAll(new RegExp(r'\\'), '/');
//   return (url);
// }
