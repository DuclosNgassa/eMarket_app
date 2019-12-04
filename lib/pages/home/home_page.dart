import 'package:emarket_app/custom_component/custom_categorie_button.dart';
import 'package:emarket_app/model/categorie.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/pages/search/datasearch.dart';
import 'package:emarket_app/services/categorie_service.dart';
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
  final CategorieService _categorieService = new CategorieService();

  List<Post> searchResult = new List();
  List<Post> postList = new List();
  List<Favorit> myFavorits = new List();
  List<Categorie> categories = new List();
  List<Categorie> parentCategories = new List();

  @override
  void initState() {
    super.initState();
    _loadPost();
    _loadMyFavorits();
    _loadMyCategories();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      height: SizeConfig.screenHeight,
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
                    padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 2),
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
                                delegate: DataSearch(
                                    postList, myFavorits, null, null),
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
                              delegate:
                                  DataSearch(postList, myFavorits, null, null),
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
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              childAspectRatio: 1.5,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(
                      left: index % 2 == 0
                          ? SizeConfig.blockSizeHorizontal * 2
                          : 0),
                  child: HomeCard(
                      postList.elementAt(index),
                      myFavorits,
                      SizeConfig.blockSizeVertical * 20,
                      SizeConfig.screenWidth * 0.5 - 10),
                );
              },
              childCount: postList.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorieGridView() {
    TextStyle _myTextStyle = TextStyle(
      color: Colors.black87,
      fontSize: SizeConfig.safeBlockHorizontal * 2.6,
    );

    double heightCustomCategorieButton = SizeConfig.blockSizeVertical * 5;
    return GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 1,
      scrollDirection: Axis.horizontal,
      children: List.generate(parentCategories.length, (index) {
        return CustomCategorieButton(
            width: SizeConfig.blockSizeHorizontal * 32,
            height: heightCustomCategorieButton,
            fillColor: colorDeepPurple400,
            icon: IconData(int.parse(parentCategories[index].icon),
                fontFamily: 'MaterialIcons'),
            splashColor: Colors.white,
            iconColor: Colors.white,
            text: parentCategories[index].title,
            textStyle: _myTextStyle,
            onPressed: () =>
                showSearchWithParentCategorie(parentCategories[index].id),
        );
      }),
    );
  }

  void showSearchWithParentCategorie(int parentCategorie) async {
    List<int> childCategories = new List();

    for (Categorie categorie in categories) {
      if (categorie.parentid == parentCategorie) {
        childCategories.add(categorie.id);
      }
    }

    showSearch(
      context: context,
      delegate: DataSearch(postList, myFavorits, null, childCategories),
    );
  }

  void _loadPost() async {
    postList = await _postService.fetchActivePosts();
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

  Future<void> _loadMyCategories() async {
    categories = await _categorieService.fetchCategories();
    for (var _categorie in categories) {
      if (_categorie.parentid == null) {
        parentCategories.add(_categorie);
      }
    }
    setState(() {
      parentCategories.sort( (a,b) => a.title.compareTo(b.title));
      Categorie categorie = parentCategories.firstWhere((categorie) => categorie.title == 'Autres');
      parentCategories.removeWhere((categorie) => categorie.title == 'Autres');
      parentCategories.add(categorie);

    });
  }
}
