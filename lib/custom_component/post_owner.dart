import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/services/global.dart';
import 'package:flutter/material.dart';

class PostOwner extends StatelessWidget {
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
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 10),
                child: Column(
                  children: <Widget>[
                    ClipOval(
                      child: Container(
                        height: 40,
                        width: 40,
                        color: Colors.deepPurple,
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
                      padding: const EdgeInsets.only(top:8.0),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.sms, color: colorDeepPurple300,),
                                    Text('Faire un SMS'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.phone_iphone, color: colorDeepPurple300,),
                                    Text('Appeler'),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          child: Container(
                            color: Colors.deepPurple,
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
        ),
    );
  }
}
