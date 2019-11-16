import 'package:emarket_app/custom_component/home_card.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/services/global.dart';
import 'package:flutter/material.dart';

class PostUserPage extends StatefulWidget {
  final List<Post> posts;

  PostUserPage(this.posts);

  @override
  _PostUserPageState createState() => _PostUserPageState();
}

class _PostUserPageState extends State<PostUserPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double deviceHeight = size.height;
    final double deviceWidth = size.width;

    return Container(
      child: Scaffold(
        body: Column(
          //padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 10, top: 25),
                  constraints: BoxConstraints.expand(height: deviceHeight / 6),
                  decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [colorDeepPurple400, colorDeepPurple300],
                          begin: const FractionalOffset(1.0, 1.0),
                          end: const FractionalOffset(0.2, 0.2),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  child: _buildTitle(),
                ),
                Container(
                  margin: EdgeInsets.only(top: 130),
                  constraints: BoxConstraints.expand(height: deviceHeight * 0.72),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                            constraints: BoxConstraints.expand(
                                height: deviceHeight * 0.72),
                            child: buildMyPostListView(),
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

  Container _buildTitle() {
    return Container(
        child: Padding(
          padding: EdgeInsets.only(top: 10, left: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: new Text(
                      "List des annonces de " + widget.posts.elementAt(0).useremail,
                      style: styleTitleWhite,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }

  Widget buildMyPostListView() {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double deviceHeight = size.height;
    final double deviceWidth = size.width;

    return ListView.separated(
        itemBuilder: (context, index) => HomeCard(widget.posts.elementAt(index), new List(), 100, deviceWidth - 20),
        separatorBuilder: (context, index) => Divider(),
        itemCount: widget.posts.length);
  }

}
