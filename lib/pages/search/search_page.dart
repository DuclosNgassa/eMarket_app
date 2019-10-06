import 'package:emarket_app/custom_component/custom_linear_gradient.dart';
import 'package:emarket_app/custom_component/home_card.dart';
import 'package:emarket_app/model/categorie_tile.dart';
import 'package:emarket_app/pages/categorie/categorie_page.dart';
import 'package:emarket_app/pages/search/searchparameter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../custom_component/custom_button.dart';
import '../../model/post.dart';
import '../../model/searchparameter.dart';
import '../../services/post_service.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Post> postList = new List();
  PostService _postService = new PostService();

  SearchParameter _searchParameter;
  final TextEditingController _controller = new TextEditingController();
  bool _isSearching;
  String _searchText = "";
  List<Post> searchResult = new List();
  CategorieTile _categorieTile = new CategorieTile('', 0);

  _SearchPageState() {
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
                                    //controller: _controller,
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
                  delegate: SliverChildListDelegate([_buildButtonLeiste()]),
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
      floatingActionButton: CustomButton(
        fillColor: Colors.deepPurple,
        icon: Icons.build,
        splashColor: Colors.white,
        iconColor: Colors.white,
        text: 'Filtre',
        textStyle: TextStyle(color: Colors.white),
        onPressed: () => showSearchParameterPage(context),
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

  Widget _buildButtonLeiste() {
    return Center(
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 4,
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          CustomButton(
            fillColor: Colors.deepPurple,
            icon: Icons.build,
            splashColor: Colors.white,
            iconColor: Colors.white,
            text: 'Filtre',
            textStyle: TextStyle(color: Colors.white),
            onPressed: () => showSearchParameterPage(context),
          ),
          CustomButton(
            fillColor: Colors.deepPurple,
            icon: Icons.apps,
            splashColor: Colors.white,
            iconColor: Colors.white,
            text: 'Categorie',
            textStyle: TextStyle(color: Colors.white),
            onPressed: showCategoriePage,
          ),
          CustomButton(
            fillColor: Colors.deepPurple,
            icon: Icons.location_on,
            splashColor: Colors.white,
            iconColor: Colors.white,
            text: 'Cameroun',
            textStyle: TextStyle(color: Colors.white),
            onPressed: () => showSearchParameterPage(context),
          ),
        ],
      ),
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

  Future showCategoriePage() async {
    _categorieTile = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return CategoriePage();
        },
      ),
    );
    setState(() {
      print("Categorie choisie: " + _categorieTile.title);
    });
  }

  Future showSearchParameterPage(BuildContext context) async {
    // SearchParameter transmitedSearchParameter = await Navigator.push(context,
    SearchParameter transmitedSearchParameter = new SearchParameter();
    transmitedSearchParameter = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchParameterPage(
          pageTitle: "Search",
        ),
      ),
    );
    if (transmitedSearchParameter.city != null) {
      print('Ville: ${transmitedSearchParameter.city}');
    }

    setState(() {
      _searchParameter = transmitedSearchParameter;
      print("Searchparameter Categorie: " + _searchParameter.category);
    });
  }

  void _loadPost() async {
    postList = await _postService.fetchPosts(http.Client());
    setState(() {});
  }

}
