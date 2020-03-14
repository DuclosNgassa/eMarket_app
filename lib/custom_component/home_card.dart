import 'package:emarket_app/global/global_color.dart';
import 'package:emarket_app/global/global_styling.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/enumeration/status.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/services/favorit_service.dart';
import 'package:emarket_app/util/global.dart';
import 'package:emarket_app/util/notification.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';

import '../model/post.dart';
import '../pages/post/post_detail_page.dart';

class HomeCard extends StatefulWidget {
  final Post post;
  final List<Favorit> myFavorits;
  final String userEmail;
  final double width;
  final double height;

  HomeCard(this.post, this.myFavorits, this.userEmail, this.height, this.width);

  @override
  _HomeCardState createState() => _HomeCardState(post, myFavorits);
}

class _HomeCardState extends State<HomeCard> {
  Post post;
  List<Favorit> myFavorits;
  Favorit myFavoritToAdd;
  Favorit myFavoritToRemove;
  String renderUrl;
  Icon favoritIcon = Icon(
    Icons.favorite_border,
    size: 30,
    color: GlobalColor.colorGrey400,
  );

  FavoritService _favoritService = new FavoritService();

  _HomeCardState(this.post, this.myFavorits);

  void initState() {
    super.initState();
    setFavoritIcon();
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

    return Stack(children: <Widget>[
      InkWell(
        onTap: showPostDetailPage,
        child: _buildHomeCard(context, widget.height, widget.width),
      ),
      Positioned(
        top: SizeConfig.blockSizeVertical,
        right: SizeConfig.blockSizeHorizontal,
        child: InkWell(
          onTap: () => updateIconFavorit(),
          child: CircleAvatar(
            backgroundColor: GlobalColor.colorGrey100,
            child: favoritIcon,
          ),
        ),
      ),
    ]);
  }

  // This is the builder method that creates a new page
  showPostDetailPage() {
    if (post.status == Status.active) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return PostDetailPage(post);
          },
        ),
      ).then((_) {
        setState(() {});
      });
    } else {
      MyNotification.showInfoFlushbar(
          context,
          AppLocalizations.of(context).translate('info'),
          AppLocalizations.of(context).translate('no_longer_available'),
          Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.blue.shade300,
          ),
          Colors.blue.shade300,
          2);
      setState(() {});
    }
  }

  Future<void> updateIconFavorit() async {
    if (widget.userEmail != null) {
      if (favoritIcon.icon == Icons.favorite) {
        for (Favorit item in myFavorits) {
          if (item.useremail == widget.userEmail && item.postid == post.id) {
            myFavoritToRemove = item;
          }
        }
        removeFavorit();
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

  Widget _buildHomeCard(BuildContext context, double height, double width) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 2,
          vertical: SizeConfig.blockSizeVertical),
      margin: EdgeInsets.only(
          right: SizeConfig.blockSizeHorizontal * 2,
          top: SizeConfig.blockSizeVertical * 2),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          new BoxShadow(
            color: Colors.grey,
            blurRadius: 20.0,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Text(widget.post.title,
                      style: GlobalStyling.styleTitleBlackCard)),
            ],
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.post.fee.toString() +
                      ' ' +
                      AppLocalizations.of(context).translate('fcfa'),
                  style: GlobalStyling.stylePriceCard,
                ),
              ),
              Text(
                Post.convertPostTypToStringForDisplay(
                    widget.post.post_typ, context),
                style: GlobalStyling.styleNormalBlackCard,
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _buildRating(widget.post.rating),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRating(int rating) {
    List<Widget> widgetList = new List();
    Widget icon = Icon(Icons.location_on, color: GlobalColor.colorGrey400);

    Widget city = Expanded(
      child: Text(
        widget.post.city,
        style: GlobalStyling.styleNormalBlack3,
      ),
    );

    widgetList.add(icon);
    widgetList.add(city);

    for (var i = 0; i < MAX_RATING; i++) {
      Icon icon = Icon(
        Icons.star,
        color: i < rating ? GlobalColor.colorBlue : GlobalColor.colorGrey300,
        size: SizeConfig.BUTTON_FONT_SIZE,
      );

      widgetList.add(icon);
    }

    return widgetList;
  }

  Future<void> setFavoritIcon() async {
    if (widget.userEmail != null) {
      for (Favorit item in myFavorits) {
        if (item.useremail == widget.userEmail && item.postid == post.id) {
          addFavorit(null);
        }
      }
    }
  }
}
