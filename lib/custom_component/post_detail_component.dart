import 'package:emarket_app/converter/date_converter.dart';
import 'package:emarket_app/global/global_color.dart';
import 'package:emarket_app/global/global_styling.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';

class PostDetailComponent extends StatefulWidget {
  PostDetailComponent({@required this.setFavorit, @required this.post});

  final GestureTapCallback setFavorit;
  final Post post;

  @override
  PostDetailComponentState createState() => PostDetailComponentState();
}

class PostDetailComponentState extends State<PostDetailComponent> {
  Icon favoritIcon = Icon(
    Icons.favorite_border,
    size: 30,
    color: GlobalColor.colorGrey400,
  );

  @override
  void initState() {
    super.initState();
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
              onTap: widget.setFavorit,
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
}
