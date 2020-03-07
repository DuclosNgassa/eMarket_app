import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emarket_app/custom_component/custom_shape_clipper.dart';
import 'package:emarket_app/global/global_color.dart';
import 'package:emarket_app/global/global_styling.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/post_image.dart';
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
    SizeConfig().init(context);
    GlobalStyling().init(context);

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
                  colors: [
                    GlobalColor.colorDeepPurple400,
                    GlobalColor.colorDeepPurple300
                  ],
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
      pagination: SwiperPagination(),
      itemBuilder: (BuildContext context, int index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(
            imageUrl: widget.images.elementAt(index).image_url,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
      itemCount: widget.images.length,
      viewportFraction: 1,
      scale: 1,
    );
  }

  Widget buildFilesGridView() {
    return new Swiper(
      pagination: SwiperPagination(),
      itemBuilder: (BuildContext context, int index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.file(
              widget.files[index],
              fit: BoxFit.contain,
            ),
          ),
        );
      },
      itemCount: widget.files.length,
      viewportFraction: 0.8,
      scale: 0.9,
    );
  }
}
