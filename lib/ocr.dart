import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';


class OCR extends StatefulWidget {
  List<CameraDescription> cameras;
  OCR({this.cameras});
  @override
  _OCRState createState() => _OCRState(cameras: cameras);
}

class _OCRState extends State<OCR> {

  String fotoScattata;
  String _testoML;
  CameraController controller;
  List<CameraDescription> cameras;
  
  _OCRState({this.cameras});

  @override
  void initState() {
      super.initState();
      _testoML='';
      fotoScattata='';
      controller = CameraController(cameras[0], ResolutionPreset.high);
      controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  void takeFoto() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${DateTime.now()}.jpeg';
    await controller.takePicture(filePath);
    print("Foto salvata su ${filePath}");
    setState(() {
      fotoScattata = filePath;
    });
    MLTextreader();
  }

  void MLTextreader() async {
    final File imageFile = new File(fotoScattata);
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.detectInImage(visionImage);
    setState(() {
          _testoML = visionText.text;
        });
  }



  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
      new Text('Scatta una foto per iniziare a leggere il contenuto'),
                new AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: CameraPreview(controller)),
                new IconButton(icon: new Icon(Icons.camera,size: 50.0,),onPressed: takeFoto,),
                new Text("ML Output"),
                new Text(_testoML)
      ],
    );
  }
}

