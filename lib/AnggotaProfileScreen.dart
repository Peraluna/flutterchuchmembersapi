import 'package:flutter/material.dart';

import './api/AnggotaModel.dart';
import './api/AnggotaApi.dart';
import 'CustomWidgets/LunaTextDateField.dart';

class AnggotaProfileScreen extends StatefulWidget {
  final AnggotaModel anggota;
  final String imageAssetName;
  AnggotaProfileScreen(
      {Key key,
      @required this.anggota,
      this.imageAssetName = 'assets/person.jpg'});
  @override
  _AnggotaProfileScreenState createState() => _AnggotaProfileScreenState();
}

class _AnggotaProfileScreenState extends State<AnggotaProfileScreen> {
  AnggotaApi anggotaApi;
    void init() async {
  anggotaApi=new AnggotaApi();
    await anggotaApi.init();
  }
  void initState() {
    init();
    renderAnggotaPic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: mainProfileWidget());
  }

  Widget mainProfileWidget() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: new Container(
        height: 150.0,
        child: new Stack(
          children: <Widget>[
            anggotaCard,
            new Positioned(top: 7.5, child: anggotaImage),
          ],
        ),
      ),
    );
  }

  String renderUrl;
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
        border:  Border.all(color: Colors.white,width: 4.0),
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
          image: (this.widget.anggota.fotoProfil != null)
              ? getAnggotaImage()
              : AssetImage(this.widget.imageAssetName),
        ),
      ),
    );

    return anggotaAvatar;
  }

  Widget get anggotaCard {
    // A new container
    // The height and width are arbitrary numbers for styling
    return new Container(
      color: Colors.black87,
      //decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
      padding: EdgeInsets.only(left: 40.0),
      width: MediaQuery.of(context).size.width ,// 290.0,
       height: 145.0,
      child: new Card(
        color: Colors.white70,
        // Wrap children in a Padding widget in order to give padding.
        child: new Padding(
          // The class that controls padding is called 'EdgeInsets'
          // The EdgeInsets.only constructor is used to set
          // paddings explicitly to each side of the child.
          padding: const EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
            left: 80.0,
          ),
          // Column is another layout widget -- like stack -- that
          // takes a list of widgets as children, and lays the
          // widgets out from top to bottom
          child: new Column(
            // these alignment properties function exactly like
            // CSS flexbox properties.
            // The main axis of a column is the vertical axis,
            // `MainAxisAlignment.spaceAround` is equivelent of
            // CSS's 'justify-content: space-around' in a vertically
            // laid out flexbox.
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Text(
                  widget.anggota.namaDepan + " " + widget.anggota.namaKeluarga,
                  // Themes are set inthe MaterialApp widget at the root of your app.
                  // They have default values -- which we're using because we didn't set our own.
                  // They're great for having consistent, app wide styling that's easily changable.
                  style: Theme.of(context).textTheme.headline),
              new Text(
                  (widget.anggota.pekerjaan == null)
                      ? "Belum Bekerja"
                      : widget.anggota.pekerjaan,
                  style: Theme.of(context).textTheme.subhead),
              new Row(
                children: <Widget>[
                  new Icon(
                    Icons.star,
                  ),
                  new LunaTextDateField(
                    initialDate: widget.anggota.tglLahir,
                    enabled: false,
                    showPickButton: false,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // void renderAnggotaPic() async {
  //   // this makes the service call
  //   await anggota.getImageUrl();
  //   // setState tells Flutter to rerender anything that's been changed.
  //   // setState cannot be async, so we use a variable that can be overwritten
  //   setState(() {
  //     renderUrl = anggota.imageUrl;
  //   });
  // }
  void renderAnggotaPic() async {
    // this makes the service call
    // await getImageUrl();
    // setState tells Flutter to rerender anything that's been changed.
    // setState cannot be async, so we use a variable that can be overwritten
    setState(() {});
  }

  getAnggotaImage() {
    return NetworkImage(
        anggotaApi.getNetWorkImageUrl(this.widget.anggota.fotoProfil) ?? '');
  }
}
