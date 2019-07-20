import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class CustomMultiImagePicker extends StatefulWidget {
  @override
  CustomMultiImagePickerState createState() => CustomMultiImagePickerState();
}

class CustomMultiImagePickerState extends State<CustomMultiImagePicker> {
  List<Asset> images = List<Asset>();
  String _error;

  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 1,
      scrollDirection: Axis.horizontal,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 100,
          height: 100,
        );
      }),
    );
  }

  Widget buildGridView1() {
    return GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 1,
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          child: Text("Test1"),
          color: Colors.grey[200],
        ),
        Container(
          padding: EdgeInsets.all(16.0),
          child: Text("Test1"),
          color: Colors.deepPurple[200],
        ),
        Container(
          padding: EdgeInsets.all(16.0),
          child: Text("Test1"),
          color: Colors.grey[200],
        ),
        Container(
          padding: EdgeInsets.all(16.0),
          child: Text("Test1"),
          color: Colors.deepPurple[200],
        ),
      ],
    );
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        enableCamera: true,
        maxImages: 3,
      );
    } on PlatformException catch (e) {
      error = e.message;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) {
        _error = 'No error detected';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: Text('Error: $_error'),
        ),
        RaisedButton(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.image,
                  color: Colors.blue,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text("Pick images"),
              ],
            ),
          ),
          onPressed: loadAssets,
        ),
        Expanded(
          child: buildGridView1(),
        ),
      ],
    );
  }
}
