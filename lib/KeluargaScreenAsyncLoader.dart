import 'package:flutter/material.dart';
import 'package:async_loader/async_loader.dart';
import './api/KeluargaModel.dart';
import './api/KeluargaApi.dart';
import 'dart:async';

import './CustomWidgets/SearchBoxLuna.dart';
 
import 'CustomWidgets/CircleAvatarLuna.dart';

class KeluargaScreenAsyncLoader extends StatefulWidget {
   final String title;
  KeluargaScreenAsyncLoader(this.title);
  @override
  _KeluargaScreenAsyncLoaderState createState() => _KeluargaScreenAsyncLoaderState();
}

class _KeluargaScreenAsyncLoaderState extends State<KeluargaScreenAsyncLoader> {


    KeluargaApi keluargaApi ;
  final TextEditingController namaSearchEditingController =
      new TextEditingController();

  final GlobalKey<AsyncLoaderState> asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();
  // String _namaSearch = "";
@override
initState() {
     keluargaApi=new KeluargaApi( );
  
  super.initState();
}  
 
  Widget getNoConnectionWidget() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 60.0,
          child: new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage('assets/no-wifi.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        new Text("No Internet Connection"),
        new FlatButton(
            color: Colors.red,
            child: new Text(
              "Retry",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => asyncLoaderState.currentState.reloadState())
      ],
    );
  }

  Widget getListView(List<KeluargaModel> items) {
    return new ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => repoListItem(items[index]));
  }

  Widget repoListItem(KeluargaModel item) {
    return new Card(
      clipBehavior: Clip.none,
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
          padding: new EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  CircleAvatarLuna(
                      imageNetworkUrl:
                          keluargaApi.getNetWorkImageUrl(item.fotoProfil))
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0 ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  
                  children: <Widget>[
                      Text(
                      item.namaKeluarga,
                      style: TextStyle(color: Colors.black87, fontSize: 18.0),
                    ),
                    
                      Text(
                      
                      item.alamat,
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.grey, fontSize: 15.0),
                    ),
                    
                  ],
                ),
              )
            ],
          )),
    );
  }

  Future<Null> _handleRefreshFuture() async {
    asyncLoaderState.currentState.reloadState();
    return null;
  }

  _handleRefresh2(String searchString) {
    asyncLoaderState.currentState.reloadState();
    return null;
  }

  
 
  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
      key: asyncLoaderState,
      initState: () async => await keluargaApi.fetchKeluargaWithAnggotaSimple(
          this.namaSearchEditingController.text),
      renderLoad: () => Center(child: new CircularProgressIndicator()),
      renderError: ([error]) => getNoConnectionWidget(),
      renderSuccess: ({data}) => getListView(data),
    );

    return Scaffold(
      appBar: new AppBar(title: buildAppBarTitle(this.widget.title)),
      body: Column(
        children: <Widget>[
          SearchBoxLuna(
              editingControllerSearch: namaSearchEditingController,
              onRefreshButtonClick: (String value) => _handleRefresh2(value)),
          Expanded(
            child: Scrollbar(
              child: RefreshIndicator(
                  onRefresh: () => _handleRefreshFuture(), child: _asyncLoader),
            ),
          ),
        ],
      ),
    );
  }
}

buildAppBarTitle(String title) {
  return new Padding(
    padding: new EdgeInsets.all(10.0),
    child: new Text(title),
  );
}
 
 