import 'package:cached_network_image/cached_network_image.dart';
import 'package:emarket_app/converter/date_converter.dart';
import 'package:emarket_app/custom_component/custom_button.dart';
import 'package:emarket_app/custom_component/post_owner.dart';
import 'package:emarket_app/model/user.dart';
import 'package:emarket_app/pages/post/images_detail.dart';
import 'package:emarket_app/pages/post/post_user_page.dart';
import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/services/image_service.dart';
import 'package:emarket_app/services/post_service.dart';
import 'package:flutter/material.dart';

import '../../model/post.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;

  PostDetailPage(this.post);

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  List<CachedNetworkImage> postImages = new List();
  ImageService _imageService = new ImageService();
  User user = new User();
  List<Post> posts = new List();
  final PostService _postService = new PostService();

  @override
  void initState() {
    super.initState();
    _loadPosts();
    _updatePostView();
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
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 10, top: 25),
                  constraints: BoxConstraints.expand(height: itemHeight / 5),
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [colorDeepPurple400, colorDeepPurple300],
                        begin: const FractionalOffset(1.0, 1.0),
                        end: const FractionalOffset(0.2, 0.2),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 55),
                  constraints: BoxConstraints.expand(height: itemHeight * 0.84),
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
                              Expanded(
                                child: Text(
                                  Post.convertFeeTypToDisplay(
                                      widget.post.fee_typ),
                                  style: priceDetailStyle,
                                ),
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
                          Divider(height: 20),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Icon(Icons.calendar_today,
                                              color: colorDeepPurple300),
                                        ),
                                        Text(DateConverter.convertToString(
                                            widget.post.created_at)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Icon(Icons.remove_red_eye,
                                            color: colorDeepPurple300),
                                      ),
                                      Text(widget.post.count_view.toString()),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                          Divider(
                            height: 20,
                          ),
                          PostOwner(
                            postCount: posts.length,
                            showAllUserPost: () => showPostUserPage(),
                            fillColor: Colors.transparent,
                            post: widget.post,
                            splashColor: colorDeepPurple300,
                            textStyle: titleDetailStyle,
                          )
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

  showPostUserPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return PostUserPage(posts);
        },
      ),
    );
  }

  List<Widget> _buildRating(int rating) {
    List<Widget> widgetList = new List();
    Widget location = Icon(Icons.location_on, color: colorDeepPurple300);
    Widget city = Expanded(
      child: Text(
        widget.post.city + ', ' + widget.post.quarter,
        style: greyDetailStyle,
      ),
    );

    widgetList.add(location);
    widgetList.add(city);

    for (var i = 0; i < rating; i++) {
      Icon icon = Icon(
        Icons.star,
        color: colorDeepPurple300,
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
          fillColor: colorDeepPurple400,
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

  Future<void> _loadImages() async {
    postImages =
        await _imageService.fetchCachedNetworkImageByPostId(widget.post.id);
    setState(() {});
  }

  Future<void> _loadPosts() async {
    posts = await _postService.fetchPostByUserEmail(widget.post.useremail);
    setState(() {});
  }

  Future<Post> _updatePostView() async {
    Post post = widget.post;
    post.count_view++;

    Map<String, dynamic> postParams = post.toMapUpdate(post);
    Post updatedPost = await _postService.update(postParams);

    return updatedPost;
  }

}
