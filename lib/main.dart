import 'package:flutter/material.dart';
import 'chooseImagePage.dart';
import 'classificationPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFF9B3E),
        fontFamily: 'Oxygen',
      ),
      initialRoute: ChooseImage.id,
      routes: {
        ChooseImage.id: (context) => ChooseImage(),
        Classification.id: (context) => Classification(),
      },
      home: ChooseImage()
    );
  }
}

// fonts
TextStyle title = new TextStyle(color: Colors.black, fontSize: 24.0, fontFamily: 'Oxygen');
TextStyle subtitle = new TextStyle(color: Colors.black, fontSize: 20.0, fontFamily: 'Oxygen', fontWeight: FontWeight.bold);
TextStyle body = new TextStyle(color: Colors.black, fontSize: 18.0, fontFamily: 'Oxygen');
TextStyle buttonSmall = new TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'Oxygen');
TextStyle buttonBig = new TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'Oxygen');
