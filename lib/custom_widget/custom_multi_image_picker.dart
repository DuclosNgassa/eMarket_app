import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

class CustomMultiImagePicker extends StatefulWidget {
  @override
  CustomMultiImagePickerState createState() => CustomMultiImagePickerState();
}

class CustomMultiImagePickerState extends State<CustomMultiImagePicker> {

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 1,
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          child: Text("Image 1"),
          color: Colors.redAccent[200],
        ),
        Container(
          padding: EdgeInsets.all(16.0),
          child: Text("Image 2"),
          color: Colors.deepPurple[200],
        ),
        Container(
          padding: EdgeInsets.all(16.0),
          child: Text("Image 3"),
          color: Colors.blue[200],
        ),
        Container(
          padding: EdgeInsets.all(16.0),
          child: Text("Image 4"),
          color: Colors.green[200],
        ),
        Container(
          padding: EdgeInsets.all(16.0),
          child: Text("Image 5"),
          color: Colors.purpleAccent[200],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: buildGridView(),
        ),
        IconButton(
          icon: Icon(Icons.image, size: 50.0,color: Colors.lightBlueAccent,),
          onPressed: () => print("Load image or take a picture"),
        )
      ],
    );
  }
}
