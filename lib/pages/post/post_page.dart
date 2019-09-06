import 'package:emarket_app/custom_widget/custom_multi_image_picker.dart';
import 'package:flutter/material.dart';
import '../../form/post_form.dart';
import '../../component/custom_linear_gradient.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => new _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: CustomLinearGradient(
        myChild: new SafeArea(
          top: false,
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: CustomScrollView(
              slivers: <Widget>[
/*                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, childAspectRatio: 3.0),
                  delegate: SliverChildListDelegate([CustomMultiImagePicker()]),
                ),*/
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
        ),
      ),
    );
  }
}