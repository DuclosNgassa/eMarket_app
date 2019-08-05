import 'package:flutter/material.dart';
import '../../component/custom_linear_gradient.dart';
import '../../form/searchparameter_form.dart';

class SearchParameterPage extends StatefulWidget {
  SearchParameterPage({Key key, this.pageTitle}) : super(key: key);
  final String pageTitle;

  @override
  _SearchParameterPageState createState() => new _SearchParameterPageState();
}

class _SearchParameterPageState extends State<SearchParameterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.pageTitle),
        backgroundColor: Colors.deepPurple,
      ),
      body: CustomLinearGradient(
        myChild: new SafeArea(
          top: false,
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(
                    [SearchParameterForm(context)],
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
