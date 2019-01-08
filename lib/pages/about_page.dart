import 'package:flutter/material.dart';

class AboutPageClass {
  BuildContext context;
  AboutPageClass({this.context});

  Widget AboutPage() {
    return Container(
        child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
                    Text("Hello Guys\n\nWelcome to the Bokehfy app, where the AI beautifys your pics by converting it to portrait and mono chrome color. \n\nThe app is in continuous development, stay tuned for more updates \n\nIf you love this app please consider buying me a coffee :)",
                 style: TextStyle(fontSize: 17.0, color: Colors.black)),

                 Padding(
                   padding: const EdgeInsets.only(top: 50.0),
                   child: RaisedButton(
                     child: Text("Buy me a Coffee  ₹50", style: TextStyle(color: Colors.white, fontSize: 17.0)),
                     color: Colors.blue,
                     textColor: Colors.white,
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0)),
                     onPressed: () {
                       
                     },
                   ),
                 )
                  ],
                )
              ),
            ),
          ),
        )
      ],
    ));
  }
}
