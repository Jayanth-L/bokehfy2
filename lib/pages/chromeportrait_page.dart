import 'package:flutter/material.dart';
import 'package:bokehfyapp/widgets/image_viewer.dart';
import 'package:flutter/services.dart';

class ChromePortraitPageClass {

  static final platform = MethodChannel("BokehfyImage");
  Color _top_app_bar_color = Colors.blue;
  int _current_bottom_nav_bar_index = 0;
  List bokehImagesList = [];

  BuildContext context;
  ChromePortraitPageClass({
    this.context
  });

  Widget ChromportraitPage() {
    return ListView(
        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
        children: <Widget>[
          Container(
            height: 125.0,
            width: double.infinity,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(10.0),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Card(
                      shape: CircleBorder(),
                      color: Colors.white,
                      elevation: 5.0,
                      child: Container(
                        height: 70.0,
                        width: 70.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35.0),
                            color: Colors.orange),
                        child: IconButton(
                          icon: Icon(Icons.add),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    ),
                    SizedBox(height: 7.0),
                    Text("Add to",
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.black))
                  ],
                ),
                Column(
                  children: <Widget>[
                    Card(
                      shape: CircleBorder(),
                      color: Colors.white,
                      elevation: 5.0,
                      child: Container(
                        height: 70.0,
                        width: 70.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35.0),
                            color: Colors.green),
                        child: IconButton(
                          icon: Icon(Icons.add),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    ),
                    SizedBox(height: 7.0),
                    Text("Take pic",
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.black))
                  ],
                ),
                SizedBox(
                  width: 15.0,
                ),
                listItem("assets/img1.jpg"),
                SizedBox(
                  width: 15.0,
                ),
                listItem("assets/img2.jpg"),
                SizedBox(
                  width: 15.0,
                ),
                listItem("assets/img3.jpg"),
                SizedBox(
                  width: 15.0,
                ),
                listItem("assets/img4.jpg"),
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          GestureDetector(
            child: imageWidget("assets/img5.jpg", "Bokehfyed pics"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ImageViewPage()
              ));
            },
          ),
          GestureDetector(
            child: imageWidget("assets/img4.jpg", "Camera pics"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ImageViewPage()
              ));
            },
          ),
           GestureDetector(
            child: imageWidget("assets/img2.jpg", "Everything you have!"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ImageViewPage()
              ));
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
                image: AssetImage(image),
                fit: BoxFit.fill
              )
            ),
          ),
        )
      ],
    );
  }

  Widget imageWidget(String filename, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        elevation: 5.0,
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
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.luminosity),
                    fit: BoxFit.cover
                  )
                ),
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
                      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 15.0)),
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

  // GetImages list
  Future<List> _getBokehImages() async {
    bokehImagesList = await platform.invokeMethod("getBokehImages", {"images": "images"});
    return bokehImagesList;
  }
}