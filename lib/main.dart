import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/portrait_page.dart';
import 'pages/chromeportrait_page.dart';
import 'pages/about_page.dart';
import 'helpers/privacy_policy.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

void main() => runApp(BokehfyApp());

class BokehfyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Bokehfy",
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
      home: BokehfyAppPage(),
    );
  }
}

class BokehfyAppPage extends StatefulWidget {
  @override
  _BokehfyAppPageState createState() => _BokehfyAppPageState();
}

class _BokehfyAppPageState extends State<BokehfyAppPage> with SingleTickerProviderStateMixin {

  List<Widget> pages;
  int _current_page_index = 0;

  TabController _tabController;


  static final platform = MethodChannel("BokehfyImage");
  int _current_bottom_nav_bar_index = 0;
  List bokehImagesList = [];

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
  @override
  Widget build(BuildContext context) {

    pages = [
      PortraitPageClass(context: context).PortraitPage(), 
      ChromePortraitPageClass(context: context).ChromportraitPage(),
      //ProModePageClass(context: context).ProModePage(),
      AboutPageClass(context: context).AboutPage()
    ];

     _tabController = TabController(vsync: this, length: pages.length);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "BOKEHFY",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.black,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) => _openDrawer()
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sentiment_very_satisfied),
            color: Colors.black,
            onPressed: () {},
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _current_bottom_nav_bar_index,
          onTap: (int index) {
            setState(() {
              _current_bottom_nav_bar_index = index;
              _current_page_index = index;
              _tabController.animateTo(index);
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.person, color: Colors.blue,),
                title: Text("Portrait", style: TextStyle(color: Colors.blue),),
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.colorize, color: Colors.green,),
                title: Text("Highlight", style: TextStyle(color: Colors.green)),
                backgroundColor: Colors.white),
            /*BottomNavigationBarItem(
                icon: Icon(Icons.portrait, color: Colors.orange,),
                title: Text("Pro mode", style: TextStyle(color: Colors.orange)),
                backgroundColor: Colors.white), */
            BottomNavigationBarItem(
                icon: Icon(Icons.info, color: Colors.deepPurple,),
                title: Text("About", style: TextStyle(color: Colors.deepPurple)),
                backgroundColor: Colors.white)
          ]),
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: pages,
      )
    );
  }

  Widget _openDrawer() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.home, color: Colors.green,),
          title: Text("About"),
          onTap: () {
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Magically convert your pics to Portrait pics!"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Wow!"),
                      onPressed: () => Navigator.of(context).pop()
                    ),
                    FlatButton(
                      child: Text("Good"),
                      onPressed: () => Navigator.of(context).pop()
                    )
                  ],
                );
              }
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.security, color: Colors.orange,),
          title: Text("Privacy Policy"),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => PrivacyPolicyPage()
              )
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.share, color: Colors.blue,),
          title: Text("Share App"),
          onTap: () {
            Navigator.of(context).pop();

            Share.share("Checkout the AI Powered Bokeh converter app");
            // TODO:// Implement share app.
          },
        ),
        ListTile(
          leading: Icon(Icons.thumb_up, color: Colors.deepPurple),
          title: Text("Rate us :)"),
          onTap: () {
            Navigator.of(context).pop();
            _launchUrl("market://details?id=com.bitcryptorapp.jayanthl.bitcryptorapp");
          },
        )
      ],
    );
  }

  void _launchUrl(url) async {
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
