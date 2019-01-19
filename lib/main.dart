import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'ocr.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;
 
void main() async {
  cameras = await availableCameras();
  FirebaseAnalytics analytics = FirebaseAnalytics();
  runApp(new MaterialApp(
    home: new MyApp(),
    theme: ThemeData.dark(),
    navigatorObservers: [
    FirebaseAnalyticsObserver(analytics: analytics),
  ],
  ));
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class Choise{

  String title;
  IconData icon;
  Widget body;
  Choise({this.title,this.icon,this.body}); //Default Constructor °L° such Dart Intensifies °L°

}

class _State extends State<MyApp> with SingleTickerProviderStateMixin{

  TabController _tabController;

  List<Choise> _choiseList = <Choise>[
    new Choise(title: 'OCR',icon: Icons.scanner,body: new OCR(cameras: cameras,)),
    ];
  
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: _choiseList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('ML Prova'),
      bottom: new PreferredSize(
            child: new Expanded(
                child: new TabPageSelector(
                  controller: _tabController,
                  selectedColor: Colors.deepOrange,
                )
            ),
            preferredSize:
            Size.fromHeight(48.0)
        ),
      ),
      body: new TabBarView(
        physics: PageScrollPhysics(),
        controller: _tabController,
          children: _choiseList.map((Choise item){
            return item.body;}
            ).toList()
      ),
    );
  }
}