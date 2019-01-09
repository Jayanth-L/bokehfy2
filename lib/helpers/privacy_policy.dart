import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text("hello", style: TextStyle(fontSize: 15.0)),
            Center(
              child: RaisedButton(
                color: Colors.blue,
                onPressed: () {

                },
                child: Text("see on internet"),
              ),
            )
          ],
        ),
      ),
    );
  }
}