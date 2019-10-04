import 'package:emarket_app/custom_component/custom_categorie_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../custom_component/custom_linear_gradient.dart';
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
  PostService _postService = new PostService();

  bool _isSearching;
  String _searchText = "";
  List<Post> searchResult = new List();
  List<Post> postList = new List();

  _HomePageState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _controller.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return Scaffold(
      //key: _scaffoldKey,
      body: CustomLinearGradient(
        myChild: new SafeArea(
          top: false,
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  //title: Text('Test'),
                  backgroundColor: Colors.deepPurple[400],
                  expandedHeight: size.height / 2 * 0.2,
                  floating: true,
                  snap: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    //title: Text("Search Page"),
                    background: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: Row(
                              children: <Widget>[
                                new Expanded(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      hintText: 'Entrer votre recherche',
                                      labelText: 'Recherche',
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                    ),
                                    onChanged: searchOperation,
                                    controller: _controller,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                  tooltip: 'rechercher',
                                  onPressed: (() {
                                    setState(() {
                                      _handleSearchStart();
                                    });
                                    print('Recherche en cours...');
                                    //_chooseDate(context, _controller.text);
                                  }),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 5,
                  ),
                  delegate:
                      SliverChildListDelegate([_buildCategorieGridView()]),
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: (itemWidth / itemHeight),
                  ),
                  delegate: SliverChildListDelegate(
                    [
                      _buildGridView(),
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

  Widget _buildGridView() {
    if (searchResult.length != 0 || _controller.text.isNotEmpty) {
      if (searchResult.length == 0 && _controller.text.isNotEmpty) {
        return Center(
          child: Text(
            "Aucun resultat pour votre recherche",
            textAlign: TextAlign.center,
          ),
        );
      }
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 5.0,
        children: searchResult
            .map(
              (data) => HomeCard(data),
            )
            .toList(),
      );
    }
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.all(8.0),
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 5.0,
      children: postList
          .map(
            (data) => HomeCard(data),
          )
          .toList(),
    );
  }

  Widget _buildCategorieGridView() {
    TextStyle _myTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 10,
    );
    return GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 1,
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        CustomCategorieButton(
          width: 50,
          height: 33,
          fillColor: Colors.deepPurple,
          icon: Icons.phone_iphone,
          splashColor: Colors.white,
          iconColor: Colors.white,
          text: 'Electromenager',
          textStyle: _myTextStyle,
          onPressed: null,
        ),
        CustomCategorieButton(
          width: 50,
          height: 33,
          fillColor: Colors.deepPurple,
          icon: Icons.weekend,
          splashColor: Colors.white,
          iconColor: Colors.white,
          text: 'Haus & Garten',
          textStyle: _myTextStyle,
          onPressed: null,
        ),
        CustomCategorieButton(
          width: 50,
          height: 33,
          fillColor: Colors.deepPurple,
          icon: Icons.home,
          splashColor: Colors.white,
          iconColor: Colors.white,
          text: 'Immobilier',
          textStyle: _myTextStyle,
          onPressed: null,
        ),
        CustomCategorieButton(
          width: 50,
          height: 33,
          fillColor: Colors.deepPurple,
          icon: Icons.local_play,
          splashColor: Colors.white,
          iconColor: Colors.white,
          text: 'Mode & Beauté',
          textStyle: _myTextStyle,
          onPressed: null,
        ),
        CustomCategorieButton(
          width: 50,
          height: 33,
          fillColor: Colors.deepPurple,
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

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPost();
    _isSearching = false;
  }

  void searchOperation(String searchText) {
    searchResult.clear();
    if (_isSearching != null) {
      for (int i = 0; i < postList.length; i++) {
        Post data = postList[i];
        if (data.title.toLowerCase().contains(searchText.toLowerCase())) {
          searchResult.add(data);
        }
      }
    }
  }

  void _loadPost() async {
    postList = await _postService.fetchPosts(http.Client());
    setState(() {
    });
  }
}
