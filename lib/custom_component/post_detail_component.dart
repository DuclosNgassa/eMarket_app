import 'package:emarket_app/converter/date_converter.dart';
import 'package:emarket_app/global/global_color.dart';
import 'package:emarket_app/global/global_styling.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/services/favorit_service.dart';
import 'package:emarket_app/services/sharedpreferences_service.dart';
import 'package:emarket_app/util/global.dart';
import 'package:emarket_app/util/notification.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';

class PostDetailComponent extends StatefulWidget {
  PostDetailComponent(
      {@required this.post, @required this.userEmail, this.myFavorits});

  //final GestureTapCallback setFavorit;
  final Post post;
  final String userEmail;
  final List<Favorit> myFavorits;

  @override
  _PostDetailComponentState createState() =>
      _PostDetailComponentState(myFavorits, post);
}

class _PostDetailComponentState extends State<PostDetailComponent> {
  final FavoritService _favoritService = new FavoritService();
  final SharedPreferenceService _sharedPreferenceService =
      new SharedPreferenceService();
  Post post;
  List<Favorit> myFavorits;
  String userEmail;
  Favorit myFavoritToAdd;
  Favorit myFavoritToRemove;

  Icon favoritIcon = Icon(
    Icons.favorite_border,
    size: 30,
    color: GlobalColor.colorGrey400,
  );

  _PostDetailComponentState(this.myFavorits, this.post);

  @override
  void initState() {
    super.initState();
    readUser();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                widget.post.title,
                style: GlobalStyling.styleTitleBlack,
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
                    AppLocalizations.of(context).translate('fcfa'),
                style: GlobalStyling.stylePrice,
              ),
            ),
            Text(
              Post.convertFeeTypToDisplay(widget.post.fee_typ, context),
              style: GlobalStyling.stylePrice,
            ),
          ],
        ),
        SizedBox(height: SizeConfig.blockSizeVertical),
        Row(
          children: _buildAddress(widget.post.rating),
        ),
        Divider(
          height: SizeConfig.blockSizeVertical * 3,
        ),
        Row(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 5),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          right: SizeConfig.blockSizeHorizontal,
                        ),
                        child: Icon(Icons.calendar_today,
                            color: GlobalColor.colorDeepPurple300),
                      ),
                      Text(DateConverter.convertToString(
                          widget.post.created_at, context)),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal),
              child: Icon(Icons.remove_red_eye,
                  color: GlobalColor.colorDeepPurple300),
            ),
            Text(_buildViews()),
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
              AppLocalizations.of(context).translate('description'),
              style: GlobalStyling.styleTitleBlack,
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
        )
      ],
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

  String _buildViews() {
    if (widget.post.count_view > 1) {
      return widget.post.count_view.toString() +
          " " +
          AppLocalizations.of(context).translate('views');
    }
    return widget.post.count_view.toString() +
        " " +
        AppLocalizations.of(context).translate('view');
  }

  Future<void> updateIconFavorit() async {
    if (widget.userEmail != null) {
      if (favoritIcon.icon == Icons.favorite) {
        for (Favorit item in myFavorits) {
          if (item.useremail == widget.userEmail && item.postid == post.id) {
            myFavoritToRemove = item;
          }
        }
        _removeFavorit();
      } else {
        Favorit favorit = new Favorit();
        favorit.postid = post.id;
        favorit.useremail = widget.userEmail;
        favorit.created_at = DateTime.now();

        for (Favorit item in myFavorits) {
          if (!(item.useremail == widget.userEmail && item.postid == post.id)) {
            myFavoritToAdd = favorit;
          }
        }

        _addFavorit(favorit);
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

  Future<void> readUser() async {
    if (widget.userEmail == null) {
      userEmail = await _sharedPreferenceService.read(USER_EMAIL);
    } else {
      userEmail = widget.userEmail;
    }

    await setFavoritIcon();

    setState(() {});
  }

  Future<void> setFavoritIcon() async {
    if (userEmail != null) {
      for (Favorit item in myFavorits) {
        if (item.useremail == userEmail && item.postid == post.id) {
          _addFavorit(null);
        }
      }
    }
  }

  void _addFavorit(Favorit favorit) {
    if (myFavorits.isEmpty) {
      myFavoritToAdd = favorit;
    }

    favoritIcon = Icon(
      Icons.favorite,
      color: Colors.redAccent,
      size: 30,
    );
  }

  Future<void> deleteFavorit(Favorit favorit) async {
    await _favoritService.delete(favorit.id);
  }

  void _removeFavorit() {
    if (myFavoritToAdd != null) {
      myFavoritToAdd = null;
    }

    favoritIcon = Icon(
      Icons.favorite_border,
      size: 30,
      color: GlobalColor.colorGrey400,
    );
  }

  Future<Favorit> _saveFavorit(Favorit favorit) async {
    Map<String, dynamic> favoritParams = favorit.toMap(favorit);
    Favorit savedFavorit = await _favoritService.save(favoritParams);

    return savedFavorit;
  }

  @override
  void deactivate() {
    super.deactivate();

    if (myFavoritToAdd != null) {
      _saveFavorit(myFavoritToAdd);
    }

    if (myFavoritToRemove != null) {
      deleteFavorit(myFavoritToRemove);
    }
  }
}
