import 'package:flutter/material.dart';

import '../model/post.dart';
import '../pages/post/post_detail_page.dart';

class PostCard extends StatefulWidget {
  final Post post;

  PostCard(this.post);

  @override
  _PostCardState createState() => _PostCardState(post);
}

class _PostCardState extends State<PostCard> {
  Post post;
  String renderUrl;

  _PostCardState(this.post);

  Widget get dogImage {
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
          height: 100.0,
          width: 100.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
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
      height: 100.0,
      width: 100.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.black54, Colors.black, Colors.blueGrey[600]],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
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

  Widget _buildPostCard(BuildContext context, double width) {
    // A new container
    // The height and width are arbitrary numbers for styling.
    return Container(
      width: width,
      height: 150.0,
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(right: 20, bottom: 30, top: 30),
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
                child: Container(),
                //backgroundImage: NetworkImage(widget.post.imageUrl),
              )
            ],
          )
        ],
      ),
/*
      child: Card(
        color: lightBlueIsh,
        //Wrap children in a Padding widget in order to give padding.
        child: Padding(
          // The class that controls padding is called 'EdgeInsets'
          // The EdgeInsets.only constructor is used to set
          // padding explicitly to each side of the child.
          padding: const EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
            left: 64.0,
          ),
          child: Column(
            // These alignment properties function exactly like
            // CSS flexbox properties.
            // The main axis of a column is the vertical axis,
            // `MainAxisAlignment.spaceAround` is equivalent of
            // CSS's 'justify-content: space-around' in a vertically
            // laid out flexbox.
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              Text(
                widget.post.city,
                style: TextStyle(color: Colors.white),
              ),
              Text(
                widget.post.fee.toString(),
                style: TextStyle(color: Colors.white),
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
              Text(
                widget.post.post_typ.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
*/
    );
  }

  void initState() {
    super.initState();
    renderDogPic();
  }

  @override
  Widget build(BuildContext context) {
    var divWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: showDogDetailPage,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Container(
          height: 115.0,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 50.0,
                child: _buildPostCard(context, divWidth),
              ),
/*
              Positioned(
                top: 7.5,
                child: dogImage,
              )
*/
            ],
          ),
        ),
      ),
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
