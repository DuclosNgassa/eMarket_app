import 'package:cached_network_image/cached_network_image.dart';
import 'package:emarket_app/custom_component/custom_button.dart';
import 'package:emarket_app/custom_component/custom_shape_clipper.dart';
import 'package:emarket_app/custom_component/post_category_component.dart';
import 'package:emarket_app/custom_component/post_detail_component.dart';
import 'package:emarket_app/custom_component/post_owner_component.dart';
import 'package:emarket_app/form/post_edit_form.dart';
import 'package:emarket_app/global/global_color.dart';
import 'package:emarket_app/global/global_styling.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/post_image.dart';
import 'package:emarket_app/model/user.dart';
import 'package:emarket_app/pages/image/images_detail.dart';
import 'package:emarket_app/pages/post/post_user_page.dart';
import 'package:emarket_app/services/image_service.dart';
import 'package:emarket_app/services/post_service.dart';
import 'package:emarket_app/services/sharedpreferences_service.dart';
import 'package:emarket_app/services/user_service.dart';
import 'package:emarket_app/util/global.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:emarket_app/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../../model/post.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;
  final List<Favorit> myFavorits;

  PostDetailPage(this.post, this.myFavorits);

  @override
  _PostDetailPageState createState() =>
      _PostDetailPageState(this.post, this.myFavorits);
}

class _PostDetailPageState extends State<PostDetailPage> {
  Post _post;
  List<PostImage> postImages = new List();
  ImageService _imageService = new ImageService();
  List<Post> posts = new List();
  List<Favorit> myFavorits = new List();
  final PostService _postService = new PostService();
  final UserService _userService = new UserService();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  SharedPreferenceService _sharedPreferenceService =
      new SharedPreferenceService();

  //final FavoritService _favoritService = new FavoritService();

  String userEmail;
  User _postOwner;
  bool showPictures = false;

  Icon favoritIcon = Icon(
    Icons.favorite_border,
    size: 30,
    color: GlobalColor.colorGrey400,
  );

  _PostDetailPageState(this._post, this.myFavorits);

  @override
  void initState() {
    super.initState();
    _readShowPictures();
    _loadUser();
    //_loadMyFavorits();
    _loadPosts();
    _getUserByEmail();
    _updatePostView();
    _loadPostImages();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    return Container(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipPath(
                  clipper: CustomShapeClipper(),
                  child: Container(
                    height: SizeConfig.screenHeight / 4,
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
                Container(
                  margin:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
                  constraints: BoxConstraints.expand(
                      height: SizeConfig.screenHeight * 0.95),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockSizeVertical),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _isPostOwner()
                              ? Container(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    icon: new Icon(
                                      Icons.edit,
                                      color: GlobalColor.colorWhite,
                                    ),
                                    tooltip: AppLocalizations.of(context)
                                        .translate('change'),
                                    onPressed: () => showPostEditForm(_post),
                                  ),
                                )
                              : new Container(),
                          buildImageGridViewShowPicture(),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.blockSizeHorizontal * 2),
                            child: PostDetailComponent(
                              userEmail: userEmail,
                              post: _post,
                              myFavorits: myFavorits,
                            ),
                          ),
                          Divider(
                            height: SizeConfig.blockSizeVertical * 5,
                          ),
                          PostOwnerComponent(
                              postCount: posts.length,
                              showAllUserPost: () => showPostUserPage(),
                              fillColor: Colors.transparent,
                              post: _post,
                              user: _postOwner,
                              splashColor: GlobalColor.colorDeepPurple300,
                              textStyle: GlobalStyling.styleTitleBlack,
                              myFavorits: myFavorits),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 2,
                          ),
                          Divider(
                            height: SizeConfig.blockSizeVertical * 5,
                          ),
                          Container(
                            height: SizeConfig.screenHeight * 0.75,
                            child: PostCategoryComponent(
                              categoryId: _post.categorieid,
                              actualPostId: _post.id,
                              myFavorits: myFavorits,
                              userEmail: userEmail,
                            ),
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
    String _userEmail = await _sharedPreferenceService.read(USER_EMAIL);
    if (_userEmail != null && _userEmail.isNotEmpty) {
      userEmail = _userEmail;
      setState(() {});
    }
  }

  showPostUserPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return PostUserPage(posts, _postOwner.name, _postOwner.email,
              myFavorits, userEmail, showPictures);
        },
      ),
    );
  }

  Widget buildImageGridViewShowPicture() {
    if (showPictures && postImages != null && postImages.isNotEmpty) {
      return Container(
        height: SizeConfig.blockSizeVertical * 50,
        //height: 125.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: buildImagesGridView(),
            ),
          ],
        ),
      );
    }
    if (!showPictures && postImages != null && postImages.isNotEmpty) {
      if (postImages.isNotEmpty && !showPictures) {
        return Padding(
          padding: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 10),
          child: Container(
            height: SizeConfig.blockSizeVertical * 10,
            child: CustomButton(
              fillColor: GlobalColor.colorDeepPurple400,
              icon: Icons.file_download,
              splashColor: Colors.white,
              iconColor: Colors.white,
              text: AppLocalizations.of(context).translate('download_images'),
              textStyle: GlobalStyling.styleNormalWhite,
              onPressed: () => _changeShowPictures(),
            ),
          ),
        );
      }
    }
    if (postImages != null && postImages.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 10),
        child: Container(
          height: SizeConfig.blockSizeVertical * 10,
          child: CustomButton(
            fillColor: GlobalColor.colorDeepPurple400,
            icon: Icons.sentiment_satisfied,
            splashColor: Colors.white,
            iconColor: Colors.white,
            text: AppLocalizations.of(context).translate('post_without_images'),
            textStyle: GlobalStyling.styleNormalWhite,
            onPressed: null,
          ),
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
          child: GestureDetector(
            onTap: _showImagedetail,
            child: CachedNetworkImage(
              imageUrl: postImages[index].image_url,
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
          ),
        );
      },
      itemCount: postImages.length,
      viewportFraction: 1,
      scale: 1,
    );
  }

  void _showImagedetail() {
    Navigator.push(
      context,
      MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return ImageDetailPage(null, postImages);
        },
        fullscreenDialog: true,
      ),
    );
  }

  Future<void> _loadPostImages() async {
    postImages = await _imageService.fetchImagesByPostID(_post.id);

    setState(() {});
  }

  Future<void> _loadPosts() async {
    posts = await _postService.fetchPostByUserEmail(_post.useremail);

    //fetch image to display
    for (var post in posts) {
      await post.getImageUrl();
    }

    setState(() {});
  }

/*
  Future<void> _loadMyFavorits() async {
    if (userEmail == null || userEmail.isEmpty) {
      userEmail = await _sharedPreferenceService.read(USER_EMAIL);
    }

    if (userEmail != null && userEmail.isNotEmpty) {
      myFavorits = await _favoritService.fetchFavoritByUserEmail(userEmail);

      //setFavoritIcon();

      setState(() {});
    }
  }
*/

  Future<void> _getUserByEmail() async {
    _postOwner = await _userService.fetchUserByEmail(_post.useremail);
    setState(() {});
  }

  Future<Post> _updatePostView() async {
    Post postToUpdate = _post;
    postToUpdate.count_view++;

    Post updatedPost = await _postService.updateView(postToUpdate.id);

    return updatedPost;
  }

  bool _isPostOwner() {
    return userEmail == _post.useremail;
  }

  _readShowPictures() async {
    showPictures = await Util.readShowPictures(_sharedPreferenceService);
    setState(() {});
  }

  _changeShowPictures() async {
    showPictures = !showPictures;
    await Util.saveShowPictures(showPictures, _sharedPreferenceService);
    setState(() {});
  }
}
