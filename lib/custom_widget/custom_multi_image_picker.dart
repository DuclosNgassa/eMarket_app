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
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
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
          child: Text("Pick images"),
          onPressed: loadAssets,
        ),
        Expanded(
          child: buildGridView(),
        ),
      ],
    );
  }
}
