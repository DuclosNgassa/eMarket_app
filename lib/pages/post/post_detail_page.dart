import 'package:cached_network_image/cached_network_image.dart';
import 'package:emarket_app/converter/date_converter.dart';
import 'package:emarket_app/custom_component/custom_button.dart';
import 'package:emarket_app/custom_component/custom_shape_clipper.dart';
import 'package:emarket_app/custom_component/post_category.dart';
import 'package:emarket_app/custom_component/post_owner.dart';
import 'package:emarket_app/form/post_edit_form.dart';
import 'package:emarket_app/global/global_color.dart';
import 'package:emarket_app/global/global_styling.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/post_image.dart';
import 'package:emarket_app/model/user.dart';
import 'package:emarket_app/pages/image/images_detail.dart';
import 'package:emarket_app/pages/post/post_user_page.dart';
import 'package:emarket_app/services/favorit_service.dart';
import 'package:emarket_app/services/image_service.dart';
import 'package:emarket_app/services/post_service.dart';
import 'package:emarket_app/services/sharedpreferences_service.dart';
import 'package:emarket_app/services/user_service.dart';
import 'package:emarket_app/util/global.dart';
import 'package:emarket_app/util/notification.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:emarket_app/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

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
  SharedPreferenceService _sharedPreferenceService =
      new SharedPreferenceService();

  String userEmail;

  //bool _isDownloaded = false;
  User _postOwner;
  Favorit myFavoritToAdd;
  Favorit myFavoritToRemove;
  bool showPictures = true;

  Icon favoritIcon = Icon(
    Icons.favorite_border,
    size: 30,
    color: GlobalColor.colorGrey400,
  );

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void deactivate() {
    super.deactivate();

    if (myFavoritToAdd != null) {
      saveFavorit(myFavoritToAdd);
    }

    if (myFavoritToRemove != null) {
      deleteFavorit(myFavoritToRemove);
    }
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
                          horizontal: SizeConfig.blockSizeHorizontal * 2,
                          vertical: SizeConfig.blockSizeVertical),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                    onPressed: () =>
                                        showPostEditForm(widget.post),
                                  ),
                                )
                              : new Container(),
                              buildImageGridViewShowPicture(),
                          Divider(),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  widget.post.title,
                                  style: GlobalStyling.styleTitleBlack,
                                  //style: titleDetailStyle,
                                ),
                              ),
                              InkWell(
                                onTap: () => updateIconFavorit(),
                                child: CircleAvatar(
                                  backgroundColor: GlobalColor.colorGrey100,
                                  child: favoritIcon,
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
                                  style: GlobalStyling.stylePrice,
                                ),
                              ),
                              Text(
                                Post.convertFeeTypToDisplay(
                                    widget.post.fee_typ, context),
                                style: GlobalStyling.stylePrice,
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
                                              color: GlobalColor
                                                  .colorDeepPurple300),
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
                                    color: GlobalColor.colorDeepPurple300),
                              ),
                              Text(widget.post.count_view.toString()),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    Post.convertPostTypToStringForDisplay(
                                        widget.post.post_typ, context),
                                    style: GlobalStyling.styleTitleBlack,
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
                                style: GlobalStyling.styleTitleBlack,
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
                                  style: GlobalStyling.styleNormalBlack,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: SizeConfig.blockSizeVertical * 5,
                          ),
                          PostOwner(
                            postCount: posts.length,
                            showAllUserPost: () => showPostUserPage(),
                            fillColor: Colors.transparent,
                            post: widget.post,
                            user: _postOwner,
                            splashColor: GlobalColor.colorDeepPurple300,
                            textStyle: GlobalStyling.styleTitleBlack,
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 2,
                          ),
                          Container(
                              height: SizeConfig.screenHeight * 0.75,
                              child: PostCategory(
                                  categoryId: widget.post.categorieid,
                                  actualPostId: widget.post.id,
                                  myFavorits: myFavorits,
                                  userEmail: userEmail))
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

  Widget buildImageGridViewShowPicture() {
    if(postImages != null && postImages.isEmpty){
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
    if(showPictures && postImages != null && postImages.isNotEmpty){
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
    if(!showPictures && postImages != null && postImages.isNotEmpty){
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
              onPressed: () => _downloadPictures(),
            ),
          ),
        );
      }
    }
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
    }
  }

  showPostUserPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return PostUserPage(
              posts, _postOwner.name, _postOwner.email, myFavorits, userEmail);
        },
      ),
    );
  }

  List<Widget> _buildAddress(int rating) {
    List<Widget> widgetList = new List();
    Widget location =
        Icon(Icons.location_on, color: GlobalColor.colorDeepPurple300);
    Widget city = Expanded(
      child: Text(
        widget.post.city + ', ' + widget.post.quarter,
        style: GlobalStyling.styleGreyDetail,
      ),
    );

    widgetList.add(location);
    widgetList.add(city);

    return widgetList;
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
    postImages = await _imageService.fetchImagesByPostID(widget.post.id);
  }

  void _downloadPictures() async {
    _changeShowPictures();
    setState(() {
    });
  }

  Future<void> _loadPosts() async {
    posts = await _postService.fetchPostByUserEmail(widget.post.useremail);

    //fetch image to display
    for (var post in posts) {
      await post.getImageUrl();
    }

  }

  Future<void> _loadMyFavorits() async {
    if (userEmail == null || userEmail.isEmpty) {
      userEmail = await _sharedPreferenceService.read(USER_EMAIL);
    }

    if (userEmail != null && userEmail.isNotEmpty) {
      myFavorits = await _favoritService.fetchFavoritByUserEmail(userEmail);

      setFavoritIcon();

    }
  }

  Future<void> _getUserByEmail() async {
    _postOwner = await _userService.fetchUserByEmail(widget.post.useremail);
  }

  Future<Post> _updatePostView() async {
    Post post = widget.post;
    post.count_view++;

    Post updatedPost = await _postService.updateView(widget.post.id);

    return updatedPost;
  }

  bool _isPostOwner() {
    return userEmail == widget.post.useremail;
  }

  Future<void> updateIconFavorit() async {
    if (userEmail != null) {
      if (favoritIcon.icon == Icons.favorite) {
        for (Favorit item in myFavorits) {
          if (item.useremail == userEmail && item.postid == widget.post.id) {
            myFavoritToRemove = item;
          }
        }
        removeFavorit();
      } else {
        Favorit favorit = new Favorit();
        favorit.postid = widget.post.id;
        favorit.useremail = userEmail;
        favorit.created_at = DateTime.now();

        for (Favorit item in myFavorits) {
          if (!(item.useremail == userEmail && item.postid == widget.post.id)) {
            myFavoritToAdd = favorit;
          }
        }

        addFavorit(favorit);
      }
      setState(() {});
    } else {
      MyNotification.showInfoFlushbar(
          context,
          AppLocalizations.of(context).translate('info'),
          AppLocalizations.of(context).translate('connect_to_save_advert'),
          Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.blue.shade300,
          ),
          Colors.blue.shade300,
          2);
    }
  }

  void removeFavorit() {
    if (myFavoritToAdd != null) {
      myFavoritToAdd = null;
    }

    favoritIcon = Icon(
      Icons.favorite_border,
      size: 30,
      color: GlobalColor.colorGrey400,
    );
  }

  void addFavorit(Favorit favorit) {
    if (myFavorits.isEmpty) {
      myFavoritToAdd = favorit;
    }

    favoritIcon = Icon(
      Icons.favorite,
      color: Colors.redAccent,
      size: 30,
    );
  }

  Future<Favorit> saveFavorit(Favorit favorit) async {
    Map<String, dynamic> favoritParams = favorit.toMap(favorit);
    Favorit savedFavorit = await _favoritService.save(favoritParams);

    return savedFavorit;
  }

  Future<void> deleteFavorit(Favorit favorit) async {
    await _favoritService.delete(favorit.id);
  }

  Future<void> setFavoritIcon() async {
    if (userEmail != null) {
      for (Favorit item in myFavorits) {
        if (item.useremail == userEmail && item.postid == widget.post.id) {
          addFavorit(null);
        }
      }
    }
  }

  _readShowPictures() async {
    showPictures = await Util.readShowPictures(_sharedPreferenceService);
  }

  _changeShowPictures() async {
    showPictures = !showPictures;
    await Util.saveShowPictures(showPictures, _sharedPreferenceService);
  }

  initData() async {
    await _loadUser();
    await _loadPosts();
    await _loadMyFavorits();
    await _getUserByEmail();
    await _updatePostView();
    await _loadPostImages();
    await _readShowPictures();

    setState(() {

    });
  }
}
