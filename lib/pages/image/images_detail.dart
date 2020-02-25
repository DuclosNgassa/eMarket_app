import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emarket_app/custom_component/custom_shape_clipper.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/post_image.dart';
import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ImageDetailPage extends StatefulWidget {
  final List<File> files;
  final List<PostImage> images;

  ImageDetailPage(this.files, this.images);

  @override
  _ImageDetailState createState() => new _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetailPage> {
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
        ),
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            height: SizeConfig.screenHeight / 3,
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                  colors: [colorDeepPurple400, colorDeepPurple300],
                  begin: const FractionalOffset(1.0, 1.0),
                  end: const FractionalOffset(0.2, 0.2),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.blockSizeHorizontal * 3,
                      top: SizeConfig.blockSizeVertical * 15),
                  child: Container(
                    height: SizeConfig.blockSizeVertical * 70,
                    width: SizeConfig.screenWidth * 0.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: buildPhotoGridView(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPhotoGridView() {
    if (widget.images != null) {
      return buildImagesGridView();
    } else if (widget.files != null) {
      return buildFilesGridView();
    } else {
      return Container(
        child: Text(
          AppLocalizations.of(context).translate('post_without_images'),
        ),
      );
    }
  }

  Widget buildImagesGridView() {
    return new Swiper(
      itemBuilder: (BuildContext context, int index) {
        return CachedNetworkImage(
          imageUrl: widget.images.elementAt(index).image_url,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
        );
      },
      itemCount: widget.images.length,
      viewportFraction: 0.8,
      scale: 0.9,
    );
  }

  Widget buildFilesGridView() {
    return new Swiper(
      itemBuilder: (BuildContext context, int index) {
        return Image.file(
          widget.files[index],
          width: SizeConfig.blockSizeHorizontal * 20,
            fit: BoxFit.scaleDown,
        );
      },
      itemCount: widget.files.length,
      viewportFraction: 0.8,
      scale: 0.9,
    );
  }
}
