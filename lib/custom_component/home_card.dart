import 'package:emarket_app/services/global.dart';
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

  _HomeCardState(this.post);

  Widget get postImage {
    var dogAvatar;
    if (renderUrl == null) {
      dogAvatar = Hero(
        child: Container(),
        tag: post,
      );
    } else {
      dogAvatar = Hero(
        tag: post,
        child: Container(
          height: 200.0,
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
      height: 200.0,
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
      secondChild: dogAvatar,
      //Then, you pass it a ternary that should be passed on your state
      //If the renderUrl is null tell the widget to use the placeholder,
      //otherwise use the dogAvatar.
      crossFadeState: renderUrl == null
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      //Finally, pass in the amount of time the fade should take.
      duration: Duration(milliseconds: 5000),
    );
  }

// IRL, we'd want the Dog class itself to get the image
// but this is a simpler way to explain Flutter basics
  void renderDogPic() async {
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
/*
    return Container(
      decoration: new BoxDecoration(
        color: lightBlueIsh,
        //shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.only(
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        ),
      ),
      width: width,
      height: 70.0,
      child: Card(
        color: Colors.transparent,
        //Wrap children in a Padding widget in order to give padding.
        child: Column(
          // These alignment properties function exactly like
          // CSS flexbox properties.
          // The main axis of a column is the vertical axis,
          // `MainAxisAlignment.spaceAround` is equivalent of
          // CSS's 'justify-content: space-around' in a vertically
          // laid out flexbox.
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              direction: Axis.vertical,
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  widget.post.title,
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  widget.post.fee_typ.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.star,
                  color: Colors.white,
                ),
                Text(
                  ': ${widget.post.rating} / 10',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ],
        ),
      ),
    );
*/

    return Container(
      width: width,
      height: 150.0,
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
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(widget.post.imageUrl),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(widget.post.title, style: jobCardTitileStyleBlue),
              ),
            ],
          ),
          Text(
            widget.post.fee_typ.toString(),
            style: jobCardTitileStyleBlack,
          ),
          Text(
            widget.post.city,
            style: salaryStyle,
          ),
          Text(
            widget.post.fee.toString(),
            style: salaryStyle,
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.star,
                color: Colors.black,
              ),
              Text(
                ': ${widget.post.rating} / 10',
                style: salaryStyle,
              )
            ],
          ),
          Text(
            widget.post.post_typ.toString(),
            style: salaryStyle,
          ),
        ],
      ),
    );
  }

  void initState() {
    super.initState();
    renderDogPic();
  }

  @override
  Widget build(BuildContext context) {
    //var divWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: showDogDetailPage,
      child: _buildHomeCard(context, 163),
    );
  }

  // This is the builder method that creates a new page
  showDogDetailPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return PostDetailPage(post);
        },
      ),
    );
  }
}
