import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/services/favorit_service.dart';
import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/util/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/post.dart';
import '../pages/post/post_detail_page.dart';

class HomeCard extends StatefulWidget {
  final Post post;
  final List<Favorit> myFavorits;
  final double width;
  final double height;


  HomeCard(this.post, this.myFavorits, this.width, this.height, );

  @override
  _HomeCardState createState() => _HomeCardState(post, myFavorits);
}

class _HomeCardState extends State<HomeCard> {
  Post post;
  List<Favorit> myFavorits;
  Favorit myFavoritToAdd = null;
  Favorit myFavoritToRemove = null;
  String renderUrl;
  Icon favoritIcon = Icon(Icons.star_border, size: 30);

  FavoritService _favoritService = new FavoritService();

  _HomeCardState(this.post, this.myFavorits);

  void initState() {
    super.initState();
    setFavoritIcon();
    renderPostPic();
  }

  @override
  void deactivate() {
    super.deactivate();

    if (myFavoritToAdd != null) {
      saveFavorit(myFavoritToAdd);
    }

    if (myFavoritToRemove != null) {
      deleteFavorit(myFavoritToRemove);
    }
  }

  @override
  Widget build(BuildContext context) {
    //var divWidth = MediaQuery.of(context).size.width;

    return Stack(children: <Widget>[
      InkWell(
        onTap: showPostDetailPage,
        child: _buildHomeCard(context, widget.height, widget.width),
      ),
      Positioned(
        top: 10,
        right: 15,
        child: InkWell(
          onTap: () => updateIconFavorit(),
          child: CircleAvatar(
            backgroundColor: colorDeepPurple300,
            child: favoritIcon,
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

  Future<void> updateIconFavorit() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      if (favoritIcon.icon == Icons.star) {
        myFavorits.forEach((item) => {
              if (item.useremail == user.email && item.postid == post.id)
                {myFavoritToRemove = item}
            });

        removeFavorit();
      } else {
        Favorit favorit = new Favorit();
        favorit.postid = post.id;
        favorit.useremail = user.email;
        favorit.created_at = DateTime.now();
        myFavorits.forEach((item) => {
              if (!(item.useremail == user.email && item.postid == post.id))
                {myFavoritToAdd = favorit}
            });

        addFavorit(favorit);
      }
      setState(() {});
    } else {
      MyNotification.showInfoFlushbar(
          context,
          "Info",
          "Connectez vous pour enregistrer les annonces qui vous interessent",
          Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.blue.shade300,
          ),
          Colors.blue.shade300,
          8);
    }
  }

  void removeFavorit() {
    if (myFavoritToAdd != null) {
      myFavoritToAdd = null;
    }

    favoritIcon = Icon(
      Icons.star_border,
      size: 30,
    );
  }

  void addFavorit(Favorit favorit) {
    if (myFavorits.isEmpty) {
      myFavoritToAdd = favorit;
    }

    favoritIcon = Icon(
      Icons.star,
      color: Colors.yellow[600],
      size: 30,
    );
  }

  Future<Favorit> saveFavorit(Favorit favorit) async {
    Map<String, dynamic> favoritParams = favorit.toMap(favorit);
    Favorit savedFavorit = await _favoritService.save(favoritParams);

    return savedFavorit;
  }

  Future<void> deleteFavorit(Favorit favorit) async {
    await _favoritService.delete(favorit.id);
  }

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
          height: widget.height,
          width: widget.width,
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
      height: widget.height,
      width: widget.width,
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

  Widget _buildHomeCard(BuildContext context, double width, double height) {
    // A new container
    // The height and width are arbitrary numbers for styling.
    return Padding(
      padding: const EdgeInsets.only(left:15.0),
      child: Container(
        height: height,
        width: width,
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

  Future<void> setFavoritIcon() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      myFavorits.forEach((item) => {
            if (item.useremail == user.email && item.postid == post.id)
              {addFavorit(null)}
          });
    }
  }

}
