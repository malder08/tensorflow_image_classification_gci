import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:io';

class Classification extends StatefulWidget {

  final File imageFile;

  static const String id = "CLASSIFICATION";

  const Classification({Key key, this.imageFile}) : super(key: key);

  @override
  _ClassificationState createState() => _ClassificationState(this.imageFile);
}

class _ClassificationState extends State<Classification> {

  final File imageFile;

  _ClassificationState(this.imageFile); 

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('TensorFlow Image Classification App'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 230,
            width: 350,
            child: Image.file(imageFile, fit: BoxFit.fitWidth),
          ),
          Container(
            child: Column(
              children: <Widget>[
                
              ],
            )
          ),
          NextImage()
        ],
      )
    );
  }
}

class NextImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Theme.of(context).primaryColor,
      child: Text("Next Image", style: buttonBig),
      onPressed: () {
        Navigator.pushNamed(context, "CHOOSE IMAGE");
      },
    );
  }
}