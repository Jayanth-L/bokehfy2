import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bokehfyapp/widgets/image_viewer.dart';
import 'package:bokehfyapp/widgets/camera_imageviewer.dart';
import 'package:flutter/services.dart';
import 'package:bokehfyapp/widgets/progress_indicator.dart';
import 'package:bokehfyapp/widgets/all_portraitimagesviewer.dart';
import 'package:flare_flutter/flare_actor.dart';

/**
 * author: Jayanrh L
 * email: jayanthl@protonmail.com
 */

class PortraitPageClass extends StatefulWidget {
  @override
  _PortraitPageClassState createState() => _PortraitPageClassState();
}

class _PortraitPageClassState extends State<PortraitPageClass> {
  static final platform = MethodChannel("BokehfyImage");
  Color _top_app_bar_color = Colors.blue;
  int _current_bottom_nav_bar_index = 0;
  List bokehImagesList = [];

  var _isFlareSucessAnimation = false;

  var isLoadingflareanimation = true;

  @override
  Widget build(BuildContext context) {
    return PortraitPage();
  }

  Widget PortraitPage() {
    return ListView(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: 90.0,
              width: (MediaQuery.of(context).size.width - 30) / 2,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: GestureDetector(
                  child: Card(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Center(
                        child: Icon(Icons.add_a_photo,
                            color: Colors.white, size: 30.0),
                      ),
                    ),
                  ),
                  onTap: () {
                    print("tapped");
                    // TODO:// Here add new image action goes i.e; intent_action_get native code
                    _getImageToPortrait().then((_) {
                      // Got the Image path
                      print("image_path: " + _);
                      // Now send it for the bokehfycation

                      // show the dialog
                      if (_ != "") {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                title: Text("Convert to Portrait pic ?"),
                                content: Text(
                                    "Sure you want to convert to portrait image ?"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("No"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("Yes"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      showDialog(
                                        builder: (BuildContext context) {
                                          isLoadingflareanimation = true;
                                          _sendImageForBokehfycation(_)
                                              .then((_response) {
                                            print(_response);
                                            if (_response == "success") {
                                              setState(() {
                                                isLoadingflareanimation = false;
                                              });
                                              Navigator.of(context).pop();
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (BuildContext
                                                      successContext) {
                                                    return FlareActor(
                                                      'assets/success.flr',
                                                      animation: "Untitled",
                                                      alignment:
                                                          Alignment.center,
                                                      callback: (_) {
                                                        print("Animation Done");
                                                        Navigator.of(
                                                                successContext)
                                                            .pop();
                                                      },
                                                    );
                                                  });
                                            } else {
                                              try {
                                                Navigator.of(context).pop();
                                              } catch (e, s) {

                                              }
                                            }
                                            // Introduce flare here
                                          });
                                          return FlareActor(
                                            isLoadingflareanimation
                                                ? 'assets/line_circles.flr'
                                                : 'assets/success.flr',
                                            alignment: Alignment.center,
                                            animation: isLoadingflareanimation
                                                ? "Loading"
                                                : "Untitled",
                                            callback: (_) {
                                              print("The animation completed");
                                              Navigator.of(context).pop();
                                            },
                                          );
                                          //return Center(child: Material(child: Row(children: <Widget>[ CircularProgressIndicator(),Text("Bokehfying", style: TextStyle(color: Colors.black),),], mainAxisSize: MainAxisSize.min,)));
                                        },
                                        context: context,
                                        barrierDismissible: false,
                                      );
                                    },
                                  )
                                ],
                              );
                            });
                      }
                    });
                  },
                ),
              ),
            ),
            Container(
              height: 90.0,
              width: (MediaQuery.of(context).size.width - 30) / 2,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: GestureDetector(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    elevation: 10.0,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.green),
                      child: Center(
                          child: Icon(
                        Icons.camera,
                        color: Colors.white,
                        size: 30.0,
                      )),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      builder: (BuildContext context) {
                        _getCameraImageToPortraitAndPortrify().then((_) {
                          Navigator.of(context).pop();
                          if (_ == "success") {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext successContext) {
                                  return FlareActor(
                                    'assets/success.flr',
                                    animation: "Untitled",
                                    callback: (_) {
                                      print("Success animation done");
                                      Navigator.of(successContext).pop();
                                    },
                                  );
                                });
                          }
                        });
                        return FlareActor(
                          isLoadingflareanimation
                              ? 'assets/line_circles.flr'
                              : 'assets/success.flr',
                          alignment: Alignment.center,
                          animation:
                              isLoadingflareanimation ? "Loading" : "Untitled",
                          callback: (_) {
                            print("The animation completed");
                            Navigator.of(context).pop();
                          },
                        );
                        //return Center(child: Material(child: Row(children: <Widget>[ CircularProgressIndicator(),Text("Bokehfying", style: TextStyle(color: Colors.black),),], mainAxisSize: MainAxisSize.min,)));
                      },
                      context: context,
                      barrierDismissible: false,
                    );
                  },
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 15.0,
        ),
        GestureDetector(
          child: imageWidget("assets/img8.jpg", "Bokehfyed pics"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ImageViewPage()));
          },
        ),
        GestureDetector(
          child: imageWidget("assets/img7.jpg", "Camera pics"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => CameraImageViewPage()));
          },
        ),
        GestureDetector(
          child: imageWidget("assets/img6.jpg", "Everything you have!"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    AllPortraitImagesViewpage()));
          },
        )
      ],
    );
  }

  Widget listItem(String image) {
    return Column(
      children: <Widget>[
        Card(
          elevation: 5.0,
          shape: CircleBorder(),
          child: Container(
            height: 70.0,
            width: 70.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35.0),
                image: DecorationImage(
                    image: AssetImage(image), fit: BoxFit.fill)),
          ),
        )
      ],
    );
  }

  Widget imageWidget(String filename, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 10.0,
        color: Colors.white,
        child: Container(
          height: 250.0,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                        image: AssetImage(filename),
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.6),
                            BlendMode.luminosity),
                        fit: BoxFit.cover)),
              ),
              Container(
                height: 250.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 15.0),
                      child: Text(text,
                          style:
                              TextStyle(color: Colors.white, fontSize: 15.0)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Platform channels methods.

  // Function to get the imagepath

  Future<String> _getImageToPortrait() async {
    var response = await platform
        .invokeMethod("getImagepathToPortrait", {"images": "images"});
    return response;
  }

  Future<String> _getCameraImageToPortraitAndPortrify() async {
    var response = await platform.invokeMethod(
        "getCameraImagepathToPortraitAndPortrify", {"imagepath": "images"});
    return response;
  }

  Future<String> _sendImageForBokehfycation(String imagepath) async {
    var response = await platform
        .invokeMethod("sendImageForBokehfycation", {"imagepath": imagepath});
    return response;
  }

  Future<String> _sendCameraImageForBokehfycation(String imagepath) async {
    var response = await platform.invokeMethod(
        "sendCameraImageForBokehfycation", {"imagepath": imagepath});
    return response;
  }
}
