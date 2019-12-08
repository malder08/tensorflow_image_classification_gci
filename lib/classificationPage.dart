import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'chooseImagePage.dart';
import 'main.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';

class Classification extends StatefulWidget {

  final File imageFile;

  const Classification({Key key, this.imageFile}) : super(key: key);

  @override
  _ClassificationState createState() => _ClassificationState();
}

class _ClassificationState extends State<Classification> {

  List recognitions;
  bool _busy = false;
  double _imageHeight;
  double _imageWidth;
  File _image;

  // load model information - using SSD MobileNet
  Future _loadSSDModel() async {
    Tflite.close();

    try {
      String res = await Tflite.loadModel(
        model: "assets/ssd_mobilenet.tflite",
        labels: "assets/ssd_mobilenet.txt",
        numThreads: 1
      );

      print(res);
    }
    on PlatformException {
      print('Failed to load model');
    }
  }

  // get the classifications using SSD MobileNet model
  Future _recognizeSSD(File image) async {
    var _recognitions = await Tflite.detectObjectOnImage(
      path: image.path,
      model: "SSDMobileNet",
      imageMean: 127.5,     
      imageStd: 127.5,      
      threshold: 0.5,  // only images 50% confidence or higher can be seen
      numResultsPerClass: 1,
      asynch: true          
    );

    // get the height and width of the image
    new FileImage(image)
        .resolve(new ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      setState(() {
        _imageHeight = info.image.height.toDouble();
        _imageWidth = info.image.width.toDouble();
      });
    }));

    // store the inputted image into a local file
    setState(() {
      recognitions = _recognitions;
      _image = image;
    });
  }

  // build the render boxes that what and where each classification is
  List<Widget> renderBoxes(Size screen) {
    if (recognitions == null) return [];
    if (_imageHeight == null || _imageWidth == null) return [];

    double factorX = screen.width;
    double factorY = _imageHeight / _imageWidth * screen.width;
    return recognitions.map((re) {
      return Positioned(
        left: re["rect"]["x"] * factorX,
        top: re["rect"]["y"] * factorY,
        width: re["rect"]["w"] * factorX,
        height: re["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          child: Text(
            "${re["detectedClass"]} with ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}% Confidence",
            style: TextStyle(
              background: Paint()..color = Theme.of(context).primaryColor,
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();

    // lets computer know logic is being performed
    _busy = true;

    // when page is loaded, load the model using the function
    _loadSSDModel().then((val) {
      setState(() {
        // lets computer know logic is not being performed
        _busy = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    // creat a list of widgets that will contain the render boxes and image to display to user
    List<Widget> stackChildren = [];

    // add the image to the list of widgets to be displayed
    stackChildren.add(Positioned(
      top: 0.0,
      left: 0.0,
      width: size.width,
      child: _image == null ? Text('No image selected.') : Image.file(_image),
    ));

    // add the render boxes to the list of widgets to be displayed
    stackChildren.addAll(renderBoxes(size));

    // make it so the button that classifies the image can only be seen when the image hasn't been classified yet
    Widget _classifyButton() {
      if (recognitions == null) {
        return RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          color: Theme.of(context).primaryColor,
          child: Text("Classify", style: buttonBig),
          onPressed: () async {
            await _recognizeSSD(widget.imageFile);
          },
        );
      } else {
        return Container();
      }
    }
    
    // make it so the screen can only be seen if no logic is being performed, otherwise it might throw an error
    if (!_busy)
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, 
          ),
          title: Text('TensorFlow Image Classification', style: TextStyle(color: Colors.white),),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // if the image has not been stored in the local file yet it has not been classified, so display the passed in image
            (_image == null)
             ? 
             Padding(
              padding: const EdgeInsets.all(15.0),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: _imageHeight,
                  width: _imageWidth,
                  child: Image.file(widget.imageFile, fit: BoxFit.fitWidth),
                ),
              ),
            )
            // otherwise display the stack containing the classified image and render boxes
            : 
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: MediaQuery.of(context).size.height - 200,
                child: Stack(
                  children: stackChildren,
                ),
              ),
            ),
            // display the classify button
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _classifyButton()
                ],
              )
            ),
            NextImage()
          ],
        )
      );
    // show a circular progress indicator if logic is being performed
    else
      return CircularProgressIndicator();
  }
}

// button that returns user to initial page so they can selected/take another picture
class NextImage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0),
      ),
      color: Theme.of(context).primaryColor,
      child: Text("Next Image", style: buttonBig),
      onPressed: () {
        Navigator.pop(
          context, 
          MaterialPageRoute(builder: (context) => ChooseImagePage()),
        );
      },
    );
  }
}