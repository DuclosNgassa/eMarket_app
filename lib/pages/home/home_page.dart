import 'package:emarket_app/custom_component/custom_categorie_button.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/pages/search/datasearch.dart';
import 'package:emarket_app/services/favorit_service.dart';
import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../custom_component/home_card.dart';
import '../../model/post.dart';
import '../../services/post_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  final PostService _postService = new PostService();
  final FavoritService _favoritService = new FavoritService();

  List<Post> searchResult = new List();
  List<Post> postList = new List();
  List<Favorit> myFavorits = new List();

  @override
  void initState() {
    super.initState();
    _loadPost();
    _loadMyFavorits();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: SizeConfig.blockSizeVertical * 10,
            floating: true,
            snap: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              hintText: 'Entrer votre recherche',
                              labelText: 'Recherche',
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              showSearch(
                                context: context,
                                delegate: DataSearch(postList, myFavorits),
                              );
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          tooltip: 'rechercher',
                          onPressed: () {
                            showSearch(
                              context: context,
                              delegate: DataSearch(postList, myFavorits),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 5,
            ),
            delegate: SliverChildListDelegate([_buildCategorieGridView()]),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return HomeCard(
                    postList.elementAt(index),
                    myFavorits,
                    SizeConfig.blockSizeVertical * 15,
                    SizeConfig.screenWidth -
                        SizeConfig.blockSizeHorizontal * 10);
              },
              childCount: postList.length,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategorieGridView() {
    TextStyle _myTextStyle = TextStyle(
      color: Colors.black87,
      fontSize: SizeConfig.safeBlockHorizontal * 3,
    );
    return GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 1,
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        CustomCategorieButton(
          width: SizeConfig.blockSizeHorizontal * 30,
          height: SizeConfig.blockSizeVertical * 5,
          fillColor: colorDeepPurple400,
          icon: Icons.phone_iphone,
          splashColor: Colors.white,
          iconColor: Colors.white,
          text: 'Electromenager',
          textStyle: _myTextStyle,
          onPressed: null,
        ),
        CustomCategorieButton(
          width: SizeConfig.blockSizeHorizontal * 30,
          height: SizeConfig.blockSizeVertical * 5,
          fillColor: colorDeepPurple400,
          icon: Icons.weekend,
          splashColor: Colors.white,
          iconColor: Colors.white,
          text: 'Haus & Garten',
          textStyle: _myTextStyle,
          onPressed: null,
        ),
        CustomCategorieButton(
          width: SizeConfig.blockSizeHorizontal * 30,
          height: SizeConfig.blockSizeVertical * 5,
          fillColor: colorDeepPurple400,
          icon: Icons.home,
          splashColor: Colors.white,
          iconColor: Colors.white,
          text: 'Immobilier',
          textStyle: _myTextStyle,
          onPressed: null,
        ),
        CustomCategorieButton(
          width: SizeConfig.blockSizeHorizontal * 30,
          height: SizeConfig.blockSizeVertical * 5,
          fillColor: colorDeepPurple400,
          icon: Icons.local_play,
          splashColor: Colors.white,
          iconColor: Colors.white,
          text: 'Mode & Beauté',
          textStyle: _myTextStyle,
          onPressed: null,
        ),
        CustomCategorieButton(
          width: SizeConfig.blockSizeHorizontal * 30,
          height: SizeConfig.blockSizeVertical * 5,
          fillColor: colorDeepPurple400,
          icon: Icons.list,
          splashColor: Colors.white,
          iconColor: Colors.white,
          text: 'Autres Categories',
          textStyle: _myTextStyle,
          onPressed: null,
        ),
      ],
    );
  }

  void _loadPost() async {
    postList = await _postService.fetchPosts();
    for (var post in postList) {
      await post.getImageUrl();
    }
    setState(() {});
  }

  Future<void> _loadMyFavorits() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      myFavorits = await _favoritService.fetchFavoritByUserEmail(user.email);
      setState(() {});
    }
  }
}
