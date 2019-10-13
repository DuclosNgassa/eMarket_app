import 'package:emarket_app/data.dart';
import 'package:emarket_app/model/posttyp.dart';
import 'package:emarket_app/pages/post/images_detail.dart';
import 'package:emarket_app/services/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../model/post_image.dart';
import '../../services/post_service.dart';
import '../../custom_component/custom_linear_gradient.dart';
import '../../model/post.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;

  PostDetailPage(this.post);

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  List<Image> postImages = new List();
  PostService _postService = new PostService();

/*

  Widget get rating {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.star,
          size: 40.0,
        ),
        Text(' ${widget.post.rating} / 10',
            style: Theme.of(context).textTheme.display2),
      ],
    );
  }

  Widget get postProfile {
    return CustomLinearGradient(
      myChild: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          postImage,
          Text(
            '${widget.post.title} 🎾',
            style: TextStyle(fontSize: 20.0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 16.0,
            ),
            child: Text(widget.post.description),
          ),
          rating
        ],
      ),
    );
  }

  Widget get addYourRating {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // In a row, column, listview, etc., a Flexible widget is a wrapper
              // that works much like CSS's flex-grow property.
              //
              // Any room left over in the main axis after
              // the widgets are given their width
              // will be distributed to all the flexible widgets
              // at a ratio based on the flex property you pass in.
              // Because this is the only Flexible widget,
              // it will take up all the extra space.
              //
              // In other words, it will expand as much as it can until
              // the all the space is taken up.
              Flexible(
                flex: 1,
                // A slider, like many form elements, needs to know its
                // own value and how to update that value.
                //
                // The slider will call onChanged whenever the value
                // changes. But it will only repaint when its value property
                // changes in the state using setState.
                //
                // The workflow is:
                // 1. User drags the slider.
                // 2. onChanged is called.
                // 3. The callback in onChanged sets the sliderValue state.
                // 4. Flutter repaints everything that relies on sliderValue,
                // in this case, just the slider at its new value.
                child: Slider(
                  activeColor: Colors.indigoAccent,
                  min: 0.0,
                  max: 15.0,
                  onChanged: (newRating) {
                    setState(() {
                      _sliderValue = newRating;
                    });
                  },
                  value: _sliderValue,
                ),
              ),
              // This is the part that displays the value of the slider.
              Container(
                width: 50.0,
                alignment: Alignment.center,
                child: Text(
                  '${_sliderValue.toInt()}',
                  style: Theme.of(context).textTheme.display1,
                ),
              )
            ],
          ),
        ),
        submitRatingButton,
      ],
    );
  }

  Widget get submitRatingButton {
    return RaisedButton(
      onPressed: updateRating,
      child: Text('Submit'),
      color: Colors.indigoAccent,
    );
  }

  void updateRating() {
    if (_sliderValue < 10) {
      _rattingErrorDialog();
    } else {
      setState(() {
        widget.post.rating = _sliderValue.toInt();
      });
    }
  }

  Future<Null> _rattingErrorDialog() async {
// showDialog is a built-in Flutter method
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error!'),
          content: Text("They're good posts, Brant. "),
          //This action uses the Navigator to dismiss the dialog.
          //This is where you could return information if you wanted to.
          actions: <Widget>[
            FlatButton(
              child: Text('Try Again'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text('${widget.post.title}'),
        ),
        body: ListView(
          children: <Widget>[
            postProfile,
            addYourRating,
          ],
        ));
  }
*/

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = size.height;
    final double itemWidth = size.width;

    return Container(
      child: Scaffold(
        body: Column(
          //padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 10, top: 25),
                  constraints: BoxConstraints.expand(height: itemHeight / 4),
                  decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [deepPurple400, deepPurple300],
                          begin: const FractionalOffset(1.0, 1.0),
                          end: const FractionalOffset(0.2, 0.2),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  child: Container(
                    //padding: EdgeInsets.only(top: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'eMarket',
                          style: titleStyleWhite,
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 55),
                  constraints: BoxConstraints.expand(height: itemHeight * 0.90),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 125.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: buildImageGridView(),
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Text(widget.post.title,
                                      style: titleDetailStyle)),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  widget.post.fee.toString() + ' FCFA',
                                  style: priceDetailStyle,
                                ),
                              ),
                              Text(
                                Post.convertFeeTypToString(widget.post.fee_typ),
                                style: priceDetailStyle,
                              ),
                            ],
                          ),
                          Row(
                            children: _buildRating(widget.post.rating),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                Post.convertPostTypToString(widget.post.post_typ),
                                style: titleStyle,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  widget.post.description,
                                  style: normalDetailStyle,
                                ),
                              ),
                            ],
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

  List<Widget> _buildRating(int rating) {
    List<Widget> widgetList = new List();
    Widget location = Icon(Icons.location_on, color: deepPurple300);
    Widget city = Expanded(
      child: Text(
        widget.post.city + ', ' + widget.post.quarter,
        style: cityDetailStyle,
      ),
    );

    widgetList.add(location);
    widgetList.add(city);

    for (var i = 0; i < rating; i++) {
      Icon icon = Icon(
        Icons.star,
        color: deepPurple300,
        size: 10,
      );

      widgetList.add(icon);
    }
    return widgetList;
  }

  Widget buildImageGridView() {
    return GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 1,
      scrollDirection: Axis.horizontal,
      children: List.generate(
        postImages.length,
        (index) {
          Image asset = postImages[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return ImageDetailPage(null, postImages);
                  },
                  fullscreenDialog: true,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(3.0, 6.0),
                        blurRadius: 10.0)
                  ]),
                  child: AspectRatio(
                    aspectRatio: 0.5,
                    child: asset != null ? asset : null,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _loadImages() async {
    postImages = await _postService.fetchImages(widget.post.id);
    setState(() {});
  }
}
