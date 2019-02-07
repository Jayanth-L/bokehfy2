import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/**
 * author: Jayanrh L
 * email: jayanthl@protonmail.com
 */

class CameraImageViewPage extends StatefulWidget {
  @override
  _CameraImageViewPageState createState() => _CameraImageViewPageState();
}

class _CameraImageViewPageState extends State<CameraImageViewPage> {
  static final platform = MethodChannel("BokehfyImage");
  List bokehImagesList = List<String>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    var _currentPageIndex = 0;
    PageController _pageController = PageController(initialPage: _currentPageIndex);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Chromy Images"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              var reversedList = [];
              for (var images in bokehImagesList.reversed) {
                reversedList.add(images);
              }
              _shareImageFile(reversedList[_currentPageIndex]);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              var reversedList = [];
              for(var images in bokehImagesList.reversed) {
                reversedList.add(images);
              }

              print("Deleting ${reversedList[_currentPageIndex]}");
              File(reversedList[_currentPageIndex]).delete();
              setState(() {
                var setting_state = true;
                _pageController = PageController(initialPage: _currentPageIndex -1);
              });
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
        body: FutureBuilder(
      future: _getBokehImages(),
      builder: (BuildContext context, AsyncSnapshot asyncshapshot) {
        var opt = <Widget>[];
        bokehImagesList.sort();
        Iterable reversedImagesList = bokehImagesList.reversed;
        if (bokehImagesList.length > 0) {
          for (var images in reversedImagesList) {
            opt.add(Container(child: Image(image: FileImage(File(images)),),));
          }
          return PageView(
            controller: _pageController,
            children: opt,
            onPageChanged: (index) {
              _currentPageIndex = index;
            } ,
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
        await platform.invokeMethod("getBokehImagesCamera", {"images": "images"});
    bokehImagesList.sort();
    Iterable reversedImagesList = bokehImagesList.reversed;
    return reversedImagesList.toList();
  }

  Future<String> _shareImageFile(imagepath) async {
    var res = await platform.invokeMethod("shareImageFile", {"imagepath": imagepath});
    return res;
  }
}
