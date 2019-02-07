import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/**
 * author: Jayanrh L
 * email: jayanthl@protonmail.com
 */

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text("Privacy Policy", style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text("Here goes the privacy policy", style: TextStyle(fontSize: 17.0)),
            Center(
              child: RaisedButton(
                color: Colors.white,
                onPressed: () {
                  _launchTheUrl("market://details?id=com.bitcryptorapp.jayanthl.bitcryptorapp");
                },
                child: Text("Read on internet", style: TextStyle(color: Colors.black),),
              ),
            )
          ],
        ),
      ),
    );
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