import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/**
 * author: Jayanrh L
 * email: jayanthl@protonmail.com
 */

class AboutPageClass {
  BuildContext context;
  AboutPageClass({this.context});

  Widget AboutPage() {
    return Container(
        child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 5.0,
              child: Container(
                height: 400.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                    padding: const EdgeInsets.all(17.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                            "Hello Guys\n\nWelcome to the Bokehfy app, where the AI beautifys your pics by converting it to portrait and mono chrome color. \n\nThe app is in continuous development, stay tuned for more updates \n\nIf you love this app please consider buying me a coffee :)",
                            style:
                                TextStyle(fontSize: 17.0, color: Colors.black)),
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: RaisedButton(
                            child: Text("Rate us :-)",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17.0)),
                            color: Colors.blue,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35.0)),
                            onPressed: () {
                              _launchTheUrl("market://details?id=com.bitcryptorapp.jayanthl.bitcryptorapp");
                            },
                          ),
                        )
                      ],
                    )),
              ),
            ),
          )
        ],
      ),
    ));
  }

  Future _launchTheUrl(url) async {
    try {
      if(await canLaunch(url)) {
        await launch(url);
      }
    } catch(exception, stacktrace) {
      print(exception);
      print(stacktrace);
    }
  }
}
