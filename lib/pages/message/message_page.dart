import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import '../../services/global.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => new _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  File imageFile;
  List<File> images = List<File>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  //static const baseUrl = 'http://192.168.2.120:3000/images';
  //static const downloadUrl = 'http://192.168.2.120:3000';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('Upload image'),
      ),
      body: new Column(
        children: <Widget>[
          _buildButtons(),
          Expanded(
            child: buildGridView(),
          ),
          // _buildPreviewImage(),
          //buildGridView(),
        ],
      ),
    );
  }

  Widget _buildPreviewImage() {
    return new Expanded(
      child: new Card(
        elevation: 3.0,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(
            new Radius.circular(4.0),
          ),
        ),
        child: new Stack(
          children: <Widget>[
            new Container(
              constraints: new BoxConstraints.expand(),
              child: imageFile == null
                  ? new Image.asset('images/profil.JPG',
                      colorBlendMode: BlendMode.darken,
                      color: Colors.black26,
                      fit: BoxFit.cover)
                  : new Image.file(imageFile, fit: BoxFit.cover),
            ),
            new Align(
              alignment: AlignmentDirectional.center,
              child: imageFile == null
                  ? new Text(
                      'No selected image',
                      style: Theme.of(context).textTheme.title,
                    )
                  : new Container(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        File asset = images[index];
        return new Container(
          constraints: new BoxConstraints.expand(),
          child: new Image.file(asset, fit: BoxFit.cover),
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Widget _buildButtons() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new IconButton(
            icon: Icon(Icons.camera),
            onPressed: _takePhoto,
            tooltip: 'Take photo',
          ),
          new IconButton(
            icon: Icon(Icons.file_upload),
            onPressed: _uploadImage,
            tooltip: 'Upload image',
          ),
          new IconButton(
            icon: Icon(Icons.image),
            onPressed: _selectGalleryImage,
            tooltip: 'Select from gallery',
          ),
        ],
      ),
    );
  }

  _takePhoto() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    images.add(imageFile);
    setState(() {});
  }

  _showSnackbar(String text) => scaffoldKey.currentState?.showSnackBar(
        new SnackBar(
          content: new Text(text),
        ),
      );

  _uploadImage() async {
/*
    if (imageFile == null) {
      return _showSnackbar('Please select image');
    }
*/
    if (images.isEmpty) {
      return _showSnackbar('Please select image');
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new Center(
          child: new CircularProgressIndicator(),
        );
      },
      barrierDismissible: false,
    );

    try {
      final url = Uri.parse(URL_IMAGES_UPLOAD);
      //BEGIN LOOP
      for (var file in images) {
        var fileName = path.basename(file.path);
        var bytes = await compute(compress, file.readAsBytesSync());

        var request = http.MultipartRequest('POST', url)
          ..files.add(
            new http.MultipartFile.fromBytes(
              'image',
              bytes,
              filename: fileName,
            ),
          );

        var response = await request.send();
        var decoded = await response.stream.bytesToString().then(json.decode);

        if (response.statusCode == HttpStatus.OK) {
          _showSnackbar(
              'Image uploaded, imageUrl = $URL_IMAGES/${decoded['path']}');
        } else {
          _showSnackbar('Image failed: ${decoded['message']}');
        }
      }
      Navigator.pop(context); //TODO Check this
      //END LOOP
    } catch (e) {
      //Navigator.pop(context); TODO Check this
      Navigator.pop(context);
      _showSnackbar('Image failed: $e');
    }
  }

  _selectGalleryImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    images.add(imageFile);
    setState(() {});
  }
}

List<int> compress(List<int> bytes) {
  var image = img.decodeImage(bytes);
  var resize = img.copyResize(image, height: 480, width: 480);
  return img.encodePng(resize, level: 1);
}
