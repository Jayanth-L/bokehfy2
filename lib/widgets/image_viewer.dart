import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewPage extends StatefulWidget {
  @override
  _ImageViewPageState createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  static final platform = MethodChannel("BokehfyImage");
  List bokehImagesList = [];
  var image = <PhotoViewGalleryPageOptions>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var image = <PhotoViewGalleryPageOptions>[];

    return Scaffold(
      backgroundColor: Colors.black,
        body: FutureBuilder(
      future: _getBokehImages(),
      builder: (BuildContext context, AsyncSnapshot asyncshapshot) {
        var opt = <PhotoViewGalleryPageOptions>[];
        bokehImagesList.sort();
        Iterable reversedImagesList = bokehImagesList.reversed;
        if (bokehImagesList.length > 0) {
          for (var images in reversedImagesList) {
            opt.add(PhotoViewGalleryPageOptions(
                imageProvider: FileImage(File(images))));
          }
          return PhotoViewGallery(
            pageOptions: opt,
          );
        } else {
          return Container(
            color: Colors.white,
            child: Center(
              child: Text("You don't have any portrait image, Add one :)")
            ),
          );
        }
      },
    ));
  }

  Future<List> _getBokehImages() async {
    bokehImagesList =
        await platform.invokeMethod("getBokehImages", {"images": "images"});
    bokehImagesList.sort();
    Iterable reversedImagesList = bokehImagesList.reversed;
    return reversedImagesList.toList();
  }
}
