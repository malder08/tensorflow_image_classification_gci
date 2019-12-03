import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ChooseImage extends StatefulWidget {

  static const String id = "CHOOSE IMAGE";

  @override
  _ChooseImageState createState() => _ChooseImageState();
}

class _ChooseImageState extends State<ChooseImage> {

  File imageFile;

  Future<void> _selectImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      imageFile = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('TensorFlow Image Classification App'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Choose an Image to Get Started", style: title),
            Row(
              children: <Widget>[
                ImageButton(icon: Icons.camera, label: 'Camera', function: _selectImage(ImageSource.camera)),
                ImageButton(icon: Icons.image, label: 'Gallery', function: _selectImage(ImageSource.gallery))
              ],
            )
          ],
        )
      )
    );
  }
}

class ImageButton extends StatelessWidget {

  final icon;
  final label;
  final function;

  const ImageButton({Key key, this.icon, this.label, this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 70.0,),
          Text(label, style: buttonSmall)
        ],
      ),
      onPressed: () { 
        function().then(Navigator.pushNamed(context, "CLASSIFICATION"));
      }
    );
  }
}

