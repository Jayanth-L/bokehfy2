import 'package:flutter/material.dart';
import 'main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

/**
 * author: Jayanrh L
 * email: jayanthl@protonmail.com
 */

void main() => runApp(MyBokehfyApp());

class MyBokehfyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Intro slider",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: IntroSlider(),
    );
  }
}

class IntroSlider extends StatefulWidget {
  @override
  _IntroSliderState createState() => _IntroSliderState();
}

class _IntroSliderState extends State<IntroSlider> {
  static final platform = MethodChannel("BokehfyImage");

  bool _isTheAppFirstTime;
  var pages = [Page1(), Page2(), Page3()];

  var _isPageVisible = true;
  var _currentPage = 0;

  var _isNextButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    _isFirstTimeAndPermission().then((_) {
      if (_ == "true") {
        setState(() {
          this._isTheAppFirstTime = true;
        });
      } else {
        setState(() {
          _isTheAppFirstTime = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isTheAppFirstTime == null) {
      return Container(
        color: Colors.white,
      );
    } else if (_isTheAppFirstTime) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "BOKEHFY",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: AnimatedOpacity(
                      duration: Duration(seconds: 1),
                      opacity: _isPageVisible ? 1.0 : 0.0,
                      child: pages[_currentPage]),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  MaterialButton(
                    child: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      print("Pressed current page");
                      if (_currentPage > 0) {
                        setState(() {
                          _isPageVisible = false;
                          Future.delayed(Duration(seconds: 1), () {
                            setState(() {
                              _currentPage = _currentPage - 1;
                              _isPageVisible = true;
                            });
                          });
                        });
                      }
                      print("going back");
                    },
                  ),
                  MaterialButton(
                    child: Icon(Icons.send),
                    onPressed: () {
                      if (_isNextButtonEnabled) {
                        _isNextButtonEnabled = false;
                        if (_currentPage == 1) {
                          _checkPermission().then((_) {
                            if (_ == "true") {
                              setState(() {
                                _isPageVisible = false;
                                Future.delayed(Duration(seconds: 1), () {
                                  setState(() {
                                    _currentPage = _currentPage + 1;
                                    _isPageVisible = true;
                                    _isNextButtonEnabled = true;
                                  });
                                });
                              }
                              
                              );} else {
                                _isNextButtonEnabled = true;
                              }
                          });
                        } else if (_currentPage < 2) {
                          setState(() {
                            _isPageVisible = false;
                            Future.delayed(Duration(seconds: 1), () {
                              setState(() {
                                _currentPage = _currentPage + 1;
                                _isPageVisible = true;
                                _isNextButtonEnabled = true;
                              });
                            });
                          });
                        } else {
                          _setTheInitFlag().then((_) {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext progressContext) {
                                  _decryptTensorflowModel().then((_) {
                                    if (_ == "success") {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  BokehfyApp()));
                                    }
                                  });
                                  return Center(
                                      child: Container(
                                    child: CircularProgressIndicator(),
                                    width: 50.0,
                                    height: 50.0,
                                  ));
                                });
                          });
                        }
                        print("Pressed");
                      }
                    },
                  )
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return BokehfyApp();
    }
  }

  Future<String> _decryptTensorflowModel() async {
    var res = await platform
        .invokeMethod("decryptTensorflowModel", {"decrypt": "decrypt"});
    return res;
  }

  Future<String> _checkPermission() async {
    var res = await platform
        .invokeMethod('checkStoragePermission', {"check": "check"});
    return res;
  }

  Future<String> _isFirstTimeAndPermission() async {

    // implementing the below with the native code

    var firstTime = await platform.invokeMethod("isFirstTimeAndCheckPermission", {"firstpermission": "firstpermission"});
    return firstTime;

    /*
    bool firstTime;
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    bool notFirst = _preferences.getBool('first') ?? false;
    if (notFirst) {
      print("not first time");
      firstTime = false;
    } else {
      print('firstTime');
      firstTime = true;
    }
    return firstTime; */
  }

  Future<String> _setTheInitFlag() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    await _preferences.setBool('first', true);
    await _preferences.commit();
    return "done";
  }
}

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.card_giftcard, size: 100.0, color: Colors.black),
            Text(
              "BOKEHFY APP",
              style: TextStyle(fontSize: 17.0, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  static final platform = MethodChannel("BokehfyImage");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.local_car_wash, size: 100.0, color: Colors.black),
            Text(
              "Magically convert to Portrait photos with AI",
              style: TextStyle(
                fontSize: 17.0,
                color: Colors.black,
              ),
            ),
            MaterialButton(
              child: Text(
                "Give Permission",
                style: TextStyle(color: Colors.black),
              ),
              elevation: 5.0,
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Storage Permission"),
                        content: Text(
                            "We need storage permission to be able to write images to disk"),
                        actions: <Widget>[
                          MaterialButton(
                            child: Text("No"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          RaisedButton(
                            child: Text(
                              "Yes",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              _getStoragePermission();
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    });
              },
            )
          ],
        ),
      ),
    );
  }

  Future<String> _getStoragePermission() async {
    var res = await platform
        .invokeMethod("getStoragePermission", {"permission": "permission"});
    return res;
  }
}

class Page3 extends StatefulWidget {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.cake, size: 100.0, color: Colors.black),
            Text(
              "Happy Birthday",
              style: TextStyle(fontSize: 17.0, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
