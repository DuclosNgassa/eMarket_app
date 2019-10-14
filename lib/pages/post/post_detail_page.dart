import 'package:cached_network_image/cached_network_image.dart';
import 'package:emarket_app/custom_component/custom_button.dart';
import 'package:emarket_app/data.dart';
import 'package:emarket_app/model/posttyp.dart';
import 'package:emarket_app/pages/post/images_detail.dart';
import 'package:emarket_app/services/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../model/post_image.dart';
import '../../services/post_service.dart';
import '../../custom_component/custom_linear_gradient.dart';
import '../../model/post.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;

  PostDetailPage(this.post);

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  List<CachedNetworkImage> postImages = new List();
  PostService _postService = new PostService();

  @override
  void initState() {
    super.initState();
    //_loadImages();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = size.height;
    final double itemWidth = size.width;

    return Container(
      child: Scaffold(
        body: Column(
          //padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 10, top: 25),
                  constraints: BoxConstraints.expand(height: itemHeight / 4),
                  decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [deepPurple400, deepPurple300],
                          begin: const FractionalOffset(1.0, 1.0),
                          end: const FractionalOffset(0.2, 0.2),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  child: Container(
                    //padding: EdgeInsets.only(top: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'eMarket',
                          style: titleStyleWhite,
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 55),
                  constraints: BoxConstraints.expand(height: itemHeight * 0.90),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                           height: 125.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: buildImageGridView(),
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Text(widget.post.title,
                                      style: titleDetailStyle)),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  widget.post.fee.toString() + ' FCFA',
                                  style: priceDetailStyle,
                                ),
                              ),
                              Text(
                                Post.convertFeeTypToDisplay(
                                    widget.post.fee_typ),
                                style: priceDetailStyle,
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: _buildRating(widget.post.rating),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Text(
                                Post.convertPostTypToStringForDisplay(
                                    widget.post.post_typ),
                                style: titleDetailStyle,
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  widget.post.description,
                                  style: normalDetailStyle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRating(int rating) {
    List<Widget> widgetList = new List();
    Widget location = Icon(Icons.location_on, color: deepPurple300);
    Widget city = Expanded(
      child: Text(
        widget.post.city + ', ' + widget.post.quarter,
        style: cityDetailStyle,
      ),
    );

    widgetList.add(location);
    widgetList.add(city);

    for (var i = 0; i < rating; i++) {
      Icon icon = Icon(
        Icons.star,
        color: deepPurple300,
        size: 10,
      );

      widgetList.add(icon);
    }
    return widgetList;
  }

  Widget buildImageGridView() {
    if (postImages.isEmpty) {
      return Container(
        height: 15.0,
        child: CustomButton(
          fillColor: deepPurple400,
          icon: Icons.file_download,
          splashColor: Colors.white,
          iconColor: Colors.white,
          text: 'Télécharger les images',
          textStyle: TextStyle(color: Colors.white, fontSize: 10),
          onPressed: () => _loadImages(),
        ),
      );
    }
    return GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 1,
      scrollDirection: Axis.horizontal,
      children: List.generate(
        postImages.length,
        (index) {
          CachedNetworkImage asset = postImages[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return ImageDetailPage(null, postImages);
                  },
                  fullscreenDialog: true,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(3.0, 6.0),
                        blurRadius: 10.0)
                  ]),
                  child: AspectRatio(
                    aspectRatio: 0.5,
                    child: asset != null ? asset : null,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _loadImages() async {
    postImages = await _postService.fetchImages(widget.post.id);
    setState(() {});
  }
}
