import 'package:emarket_app/custom_widget/custom_multi_image_picker.dart';
import 'package:flutter/material.dart';
import '../form/post_form.dart';
class Post extends StatefulWidget {
  Post({Key key, this.pageTitle}) : super(key: key);
  final String pageTitle;

  @override
  _PostPageState createState() => new _PostPageState();
}

class _PostPageState extends State<Post> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.pageTitle),
        backgroundColor: Colors.redAccent,
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 3.0
                ),
                delegate: SliverChildListDelegate([CustomMultiImagePicker()]),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    PostForm(scaffoldKey: _scaffoldKey,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

