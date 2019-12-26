import 'dart:io';

import 'package:emarket_app/model/post_image.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';

class ImageDetailPage extends StatefulWidget {
  final List<File> files;
  final List<PostImage> images;

  ImageDetailPage(this.files, this.images);

  @override
  _ImageDetailState createState() => new _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Colors.deepPurple[400],
            Colors.deepPurple[300],
            Colors.deepPurple[400],
            Colors.deepPurple[300],
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal * 3, top: SizeConfig.blockSizeVertical * 15),
                child: Container(
                  height: SizeConfig.blockSizeVertical * 70,
                  width: SizeConfig.screenWidth * 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: buildImageGridView(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImageGridView() {
    return GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 1,
      scrollDirection: Axis.horizontal,
      children: List.generate(
        widget.images.length,
            (index) {
          PostImage asset = widget.images[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: AspectRatio(
              aspectRatio: 0.5,
              child: asset != null ? Image.network(asset.image_url, width: SizeConfig.blockSizeHorizontal * 20,) : null,
            ),
          );
        },
      ),
    );
  }

}
