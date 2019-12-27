import 'package:emarket_app/converter/date_converter.dart';
import 'package:emarket_app/custom_component/custom_button.dart';
import 'package:emarket_app/custom_component/post_owner.dart';
import 'package:emarket_app/form/post_edit_form.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/post_image.dart';
import 'package:emarket_app/model/user.dart';
import 'package:emarket_app/pages/image/images_detail.dart';
import 'package:emarket_app/pages/post/post_user_page.dart';
import 'package:emarket_app/services/favorit_service.dart';
import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/services/image_service.dart';
import 'package:emarket_app/services/post_service.dart';
import 'package:emarket_app/services/user_service.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/post.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;

  PostDetailPage(this.post);

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  List<PostImage> postImages = new List();
  ImageService _imageService = new ImageService();
  List<Post> posts = new List();
  List<Favorit> myFavorits = new List();
  final PostService _postService = new PostService();
  final UserService _userService = new UserService();
  final FavoritService _favoritService = new FavoritService();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  String userEmail;
  bool _isDownloaded = false;
  User _postOwner;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadPosts();
    _loadMyFavorits();
    _getUserByEmail();
    _updatePostView();
    _loadPostImages();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      left: SizeConfig.blockSizeHorizontal * 10,
                      top: SizeConfig.blockSizeVertical * 25),
                  //constraints: BoxConstraints.expand(height: itemHeight / 5),
                  constraints: BoxConstraints.expand(
                      height: SizeConfig.screenHeight / 5),
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
                  margin:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
                  constraints: BoxConstraints.expand(
                      height: SizeConfig.screenHeight * 0.9),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 2,
                          vertical: SizeConfig.blockSizeVertical),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _isPostOwner()
                              ? Container(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    icon: new Icon(
                                      Icons.edit,
                                      color: colorWhite,
                                    ),
                                    tooltip: AppLocalizations.of(context)
                                        .translate('change'),
                                    onPressed: () =>
                                        showPostEditForm(widget.post),
                                  ),
                                )
                              : new Container(),
                          Container(
                            height: SizeConfig.blockSizeVertical * 20,
                            //height: 125.0,
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
                                child: Text(
                                  widget.post.title,
                                  style: SizeConfig.styleTitleBlack,
                                  //style: titleDetailStyle,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  widget.post.fee.toString() +
                                      ' ' +
                                      AppLocalizations.of(context)
                                          .translate('fcfa'),
                                  style: SizeConfig.stylePrice,
                                ),
                              ),
                              Text(
                                Post.convertFeeTypToDisplay(
                                    widget.post.fee_typ),
                                style: SizeConfig.stylePrice,
                              ),
                            ],
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical),
                          Row(
                            children: _buildAddress(widget.post.rating),
                          ),
                          //SizedBox(height: SizeConfig.blockSizeVertical),
                          Divider(
                            height: SizeConfig.blockSizeVertical * 3,
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    right: SizeConfig.blockSizeHorizontal * 5),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                            right:
                                                SizeConfig.blockSizeHorizontal,
                                          ),
                                          child: Icon(Icons.calendar_today,
                                              color: colorDeepPurple300),
                                        ),
                                        Text(DateConverter.convertToString(
                                            widget.post.created_at, context)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: SizeConfig.blockSizeHorizontal),
                                child: Icon(Icons.remove_red_eye,
                                    color: colorDeepPurple300),
                              ),
                              Text(widget.post.count_view.toString()),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    Post.convertPostTypToStringForDisplay(
                                        widget.post.post_typ, context),
                                    style: SizeConfig.styleTitleBlack,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: SizeConfig.blockSizeVertical * 3,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context)
                                    .translate('description'),
                                style: SizeConfig.styleTitleBlack,
                                //style: titleDetailStyle,
                              ),
                            ],
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  widget.post.description,
                                  style: SizeConfig.styleNormalBlack,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: SizeConfig.blockSizeVertical * 4,
                          ),
                          PostOwner(
                            postCount: posts.length,
                            showAllUserPost: () => showPostUserPage(),
                            fillColor: Colors.transparent,
                            post: widget.post,
                            user: _postOwner,
                            splashColor: colorDeepPurple300,
                            textStyle: SizeConfig.styleTitleBlack,
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

  showPostEditForm(Post post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return PostEditForm(post, _scaffoldKey);
        },
      ),
    ).then((value) {
      _loadPostImages();
      setState(() {});
    });
  }

  Future<void> _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _userEmail = prefs.getString(USER_EMAIL);
    if (_userEmail != null) {
      userEmail = _userEmail;
      setState(() {});
    }
  }

  showPostUserPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return PostUserPage(posts, _postOwner.name, myFavorits);
        },
      ),
    );
  }

  List<Widget> _buildAddress(int rating) {
    List<Widget> widgetList = new List();
    Widget location = Icon(Icons.location_on, color: colorDeepPurple300);
    Widget city = Expanded(
      child: Text(
        widget.post.city + ', ' + widget.post.quarter,
        style: SizeConfig.styleGreyDetail,
      ),
    );

    widgetList.add(location);
    widgetList.add(city);

    return widgetList;
  }

  Widget buildImageGridView() {
    if (postImages.isNotEmpty && !_isDownloaded) {
      return Container(
        height: 15.0,
        child: CustomButton(
          fillColor: colorDeepPurple400,
          icon: Icons.file_download,
          splashColor: Colors.white,
          iconColor: Colors.white,
          text: AppLocalizations.of(context).translate('download_images'),
          textStyle: SizeConfig.styleNormalWhite,
          onPressed: () => _downloadPictures(),
        ),
      );
    }
    if (postImages.isEmpty) {
      return Container(
        height: 15.0,
        child: CustomButton(
          fillColor: colorDeepPurple400,
          icon: Icons.sentiment_satisfied,
          splashColor: Colors.white,
          iconColor: Colors.white,
          text: AppLocalizations.of(context).translate('no_images'),
          textStyle: SizeConfig.styleNormalWhite,
          onPressed: null,
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
          PostImage asset = postImages[index];
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
              padding:
                  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 2),
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
                    child: asset != null
                        ? Image.network(
                            asset.image_url,
                            fit: BoxFit.fill,
                          )
                        : null,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _loadPostImages() async {
    postImages = await _imageService.fetchImagesByPostID(widget.post.id);

    setState(() {});
  }

  void _downloadPictures() {
    setState(() {
      _isDownloaded = true;
    });
  }

  Future<void> _loadPosts() async {
    posts = await _postService.fetchPostByUserEmail(widget.post.useremail);
    setState(() {});
  }

  Future<void> _loadMyFavorits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _userEmail = prefs.getString(USER_EMAIL);
    myFavorits = await _favoritService.fetchFavoritByUserEmail(_userEmail);

    setState(() {});
  }

  Future<void> _getUserByEmail() async {
    _postOwner = await _userService.fetchUserByEmail(widget.post.useremail);
    setState(() {});
  }

  Future<Post> _updatePostView() async {
    Post post = widget.post;
    post.count_view++;

    Map<String, dynamic> postParams = post.toMapUpdate(post);
    Post updatedPost = await _postService.update(postParams);

    return updatedPost;
  }

  bool _isPostOwner() {
    return userEmail == widget.post.useremail;
  }
}
