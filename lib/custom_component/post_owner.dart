import 'package:emarket_app/model/login_source.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/pages/login/login.dart';
import 'package:emarket_app/services/global.dart';
import 'package:flutter/material.dart';

import 'custom_button.dart';

class PostOwner extends StatelessWidget {
  bool logedIn = false; //TODO save login as sharedPreferencies

  PostOwner(
      {@required this.onPressed,
      @required this.fillColor,
      @required this.splashColor,
      @required this.textStyle,
      @required this.post});

  final GestureTapCallback onPressed;
  final Color fillColor;
  final Color splashColor;
  final TextStyle textStyle;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 10),
                  child: Column(
                    children: <Widget>[
                      ClipOval(
                        child: Container(
                          height: 40,
                          width: 40,
                          color: colorDeepPurple400,
                          child: Center(
                            child: Text(
                              'D',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: <Widget>[
                            Text('Duclos', style: titleDetailStyle),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: <Widget>[
                            Text('Utilisateur privé', style: greyDetailStyle),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.sentiment_satisfied),
                            Text('Satisfaction: TOP', style: greyDetailStyle),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Center(
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            child: Container(
                              color: colorDeepPurple400,
                              height: 20,
                              width: 20,
                              child: Center(
                                child: Text(
                                  '5',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: CustomButton(
                      fillColor: colorDeepPurple400,
                      icon: Icons.sms,
                      splashColor: Colors.white,
                      iconColor: Colors.white,
                      text: 'Fais moi un SMS',
                      textStyle: TextStyle(
                          color: Colors.white, fontSize: BUTTON_FONT_SIZE),
                      onPressed: () => _showNumber(context),
                    ),
                  ),
                  SizedBox(
                    width: 4.0,
                  ),
                  Expanded(
                    child: CustomButton(
                      fillColor: colorDeepPurple400,
                      icon: Icons.phone_iphone,
                      splashColor: Colors.white,
                      iconColor: Colors.white,
                      text: 'Appele moi',
                      textStyle: TextStyle(
                          color: Colors.white, fontSize: BUTTON_FONT_SIZE),
                      onPressed: null,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Icon(
                    Icons.share,
                    color: colorDeepPurple300,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showNumber(BuildContext context){
    if(logedIn){
      //TODO display number
    }else {
      Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => new Login(LoginSource.ownerPage, post),
        ),
      );
    }
  }
}
