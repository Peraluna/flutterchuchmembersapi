import 'package:flutter/material.dart';

class CircleAvatarLuna extends StatelessWidget {
  final String imageNetworkUrl;
  final String imageAssetName;
  final double width;
  final double height;
  CircleAvatarLuna(
      {Key key,
      this.imageNetworkUrl,
      this.imageAssetName = "assets/family.jpg",
      this.width = 60.0,
      this.height = 60.0})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: this.height,
      width: this.width,
      decoration: new BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0x33A6A6A6)),
          // image: new Image.asset(_image.)
          image: new DecorationImage(
            fit: BoxFit.fill,
            image: (imageNetworkUrl == null)
                ? AssetImage(imageAssetName)
                : NetworkImage(imageNetworkUrl),
          )),
      // child: (imageUrl==null) ? new Image(image:  AssetImage('assets/family.jpg')) : new Image.network(imageUrl),
    );
  }
}
