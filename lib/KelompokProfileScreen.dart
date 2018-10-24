import 'package:flutter/material.dart';

import './api/KelompokModel.dart';
import './api/KelompokApi.dart';
import 'CustomWidgets/LunaTextDateField.dart';

class KelompokProfileScreen extends StatefulWidget {
  final KelompokModel kelompok;
  final String imageAssetName;
  KelompokProfileScreen(
      {Key key,
      @required this.kelompok,
      this.imageAssetName = 'assets/person.jpg'});
  @override
  _KelompokProfileScreenState createState() => _KelompokProfileScreenState();
}

class _KelompokProfileScreenState extends State<KelompokProfileScreen> {
  KelompokApi kelompokApi;
    void init() async {
  kelompokApi=new KelompokApi();
    await kelompokApi.init();
  }
  void initState() {
    init();
    renderKelompokPic();
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
            kelompokCard,
            new Positioned(top: 7.5, child: kelompokImage),
          ],
        ),
      ),
    );
  }

  String renderUrl;
  Widget get kelompokImage {
    var kelompokAvatar = new Container(
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
          //image: (this.widget.kelompok.fotoProfil!=null) ? new NetworkImage(this.widget.kelompok.fotoProfil ?? '') : AssetImage(this.widget.imageAssetName),
          image: (this.widget.kelompok.fotoProfil != null)
              ? getKelompokImage()
              : AssetImage(this.widget.imageAssetName),
        ),
      ),
    );

    return kelompokAvatar;
  }

  Widget get kelompokCard {
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
                  widget.kelompok.namaKelompok,
                  // Themes are set inthe MaterialApp widget at the root of your app.
                  // They have default values -- which we're using because we didn't set our own.
                  // They're great for having consistent, app wide styling that's easily changable.
                  style: Theme.of(context).textTheme.headline),
              // new Text(
              //     (widget.kelompok.pekerjaan == null)
              //         ? "Belum Bekerja"
              //         : widget.kelompok.pekerjaan,
              //     style: Theme.of(context).textTheme.subhead),
              new Row(
                children: <Widget>[
                  new Icon(
                    Icons.star,
                  ),
                  new LunaTextDateField(
                    initialDate: widget.kelompok.tglDibentuk,
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

  // void renderKelompokPic() async {
  //   // this makes the service call
  //   await kelompok.getImageUrl();
  //   // setState tells Flutter to rerender anything that's been changed.
  //   // setState cannot be async, so we use a variable that can be overwritten
  //   setState(() {
  //     renderUrl = kelompok.imageUrl;
  //   });
  // }
  void renderKelompokPic() async {
    // this makes the service call
    // await getImageUrl();
    // setState tells Flutter to rerender anything that's been changed.
    // setState cannot be async, so we use a variable that can be overwritten
    setState(() {});
  }

  getKelompokImage() {
    return NetworkImage(
        kelompokApi.getNetWorkImageUrl(this.widget.kelompok.fotoProfil) ?? '');
  }
}
