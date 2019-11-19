import 'package:emarket_app/model/login_source.dart';
import 'package:emarket_app/pages/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../form/post_form.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => new _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            FirebaseUser user = snapshot.data; // this is your user instance
            /// is because there is user already logged
            return new Container(
              key: _scaffoldKey,
              child: new SafeArea(
                top: false,
                bottom: false,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          PostForm(
                            scaffoldKey: _scaffoldKey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return new Login(LoginSource.postPage, null);

        });
  }
}
