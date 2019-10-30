import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/services/global.dart' as prefix0;
import 'package:flutter/material.dart';

import '../model/post.dart';
import '../pages/post/post_detail_page.dart';

class HomeCard extends StatefulWidget {
  final Post post;

  HomeCard(this.post);

  @override
  _HomeCardState createState() => _HomeCardState(post);
}

class _HomeCardState extends State<HomeCard> {
  Post post;
  String renderUrl;
  Icon favorit = Icon(Icons.star_border, size: 30);

  _HomeCardState(this.post);

  Widget get postImage {
    var postAvatar;
    if (renderUrl == null) {
      postAvatar = Hero(
        child: Container(),
        tag: post,
      );
    } else {
      postAvatar = Hero(
        tag: post,
        child: Container(
          height: 155.0,
          width: 200.0,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15.0),
            image: DecorationImage(
              image: NetworkImage(renderUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    // Placeholder is a static container the same size as the dog image
    var placeholder = Container(
      height: 155.0,
      width: 200.0,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15.0),
          gradient: LinearGradient(
            colors: [Colors.black54, Colors.black, Colors.blueGrey[600]],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
      alignment: Alignment.center,
      child: Text(
        'POSTS',
        textAlign: TextAlign.center,
      ),
    );

    // This is an animated widget build into Flutter
    return AnimatedCrossFade(
      // You pass it the starting widget and the ending widget.
      firstChild: placeholder,
      secondChild: postAvatar,
      //Then, you pass it a ternary that should be passed on your state
      //If the renderUrl is null tell the widget to use the placeholder,
      //otherwise use the postAvatar.
      crossFadeState: renderUrl == null
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      //Finally, pass in the amount of time the fade should take.
      duration: Duration(milliseconds: 5000),
    );
  }

// IRL, we'd want the Dog class itself to get the image
// but this is a simpler way to explain Flutter basics
  void renderPostPic() async {
    // this makes the service call
    await post.getImageUrl();
    // setState tells Flutter to rerender anything that's been changed.
    // setState cannot be async, so we use a variable that can be overwritten
    if (mounted) {
      // Avoid calling `setState` if the widget is no longer in the widget tree.
      setState(() {
        renderUrl = post.imageUrl;
      });
    }
  }

  Widget _buildHomeCard(BuildContext context, double width) {
    // A new container
    // The height and width are arbitrary numbers for styling.
    return Container(
      width: width,
      height: 155.0,
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(right: 20, bottom: 10, top: 10),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.post.fee.toString() + ' FCFA',
                style: priceStyle,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(child: Text(widget.post.title, style: titleStyle)),
            ],
          ),
          Row(
            children: _buildRating(widget.post.rating),
          ),
          Text(
            Post.convertPostTypToStringForDisplay(widget.post.post_typ),
            style: titleStyle,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRating(int rating) {
    List<Widget> widgetList = new List();
    Widget city = Expanded(
      child: Text(
        widget.post.city,
        style: cityStyle,
      ),
    );

    widgetList.add(city);

    for (var i = 0; i < rating; i++) {
      Icon icon = Icon(
        Icons.star,
        color: colorDeepPurple300,
        size: 10,
      );

      widgetList.add(icon);
    }
    return widgetList;
  }

  ImageProvider getImage() {
    return NetworkImage(widget.post.imageUrl);
/*
    if (widget.post.imageUrl != null) {
      return NetworkImage(widget.post.imageUrl);
    } else
      return NetworkImage(
          "http://192.168.2.120:3000/images/scaled_image_picker7760936399678163578-1567804687023.jpg");
*/
  }

  void initState() {
    super.initState();
    renderPostPic();
  }

  @override
  Widget build(BuildContext context) {
    //var divWidth = MediaQuery.of(context).size.width;

    return Stack(children: <Widget>[
      InkWell(
        onTap: showPostDetailPage,
        child: _buildHomeCard(context, 200),
      ),
      Positioned(
        top: 10,
        right: 15,
        child: InkWell(
          onTap: () => updateFavorit(widget.post),
          child: CircleAvatar(
            backgroundColor: colorDeepPurple300,
            child: favorit,
            //backgroundImage: getImage(),
          ),
        ),
      ),
    ]);
  }

  // This is the builder method that creates a new page
  showPostDetailPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return PostDetailPage(post);
        },
      ),
    );
  }

  Future<void> updateFavorit(Post post) async {
    if (favorit.icon == Icons.star) {
      favorit = Icon(Icons.star_border, size: 30);
    } else {
      favorit = Icon(
        Icons.star,
        color: Colors.yellow[600],
        size: 30,
      );
    }
    setState(() {});
    print("Favorit updated!");
  }
}
