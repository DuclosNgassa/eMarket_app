import 'package:emarket_app/custom_component/home_card.dart';
import 'package:emarket_app/model/categorie_tile.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/model/searchparameter.dart';
import 'package:emarket_app/pages/categorie/categorie_page.dart';
import 'package:emarket_app/pages/search/searchparameter.dart';
import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate<Post> {
  DataSearch(this.postList, this.myFavorits);

  final List<Post> postList;
  final List<Favorit> myFavorits;

  @override
  String get searchFieldLabel => 'Recherche';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: colorDeepPurple300,
      primaryIconTheme: theme.primaryIconTheme,
      primaryColorBrightness: theme.primaryColorBrightness,
      primaryTextTheme: theme.primaryTextTheme,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle:
            Theme.of(context).textTheme.title.copyWith(color: Colors.white),
        labelStyle:
            Theme.of(context).textTheme.title.copyWith(color: Colors.white),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        color: colorWhite,
        onPressed: () {
          query = "";
        },
      ),
      IconButton(
        icon: Icon(Icons.build),
        color: colorWhite,
        onPressed: () => showSearchParameterPage(context),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    //_postService.fetchPosts().then((result) => postList = result);

    // TODO: implement buildResults
    //return PostDetailPage(context);
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    SizeConfig().init(context);

    final resultList = query.isEmpty
        ? postList
        : postList
            .where((post) =>
                post.title.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: 2,
      mainAxisSpacing: 0,
      crossAxisSpacing: 0,
      childAspectRatio: 1.5,

      children: List.generate(resultList.length, (index) {
        return HomeCard(
            resultList[index],
            myFavorits,
            SizeConfig.blockSizeVertical * 18,
            SizeConfig.screenWidth * 0.5 - 10);
      }),
    );
  }

  Future showCategoriePage(BuildContext context) async {
    CategorieTile _categorieTile = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return CategoriePage();
        },
      ),
    );
    print("Categorie: " + _categorieTile.title);
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

    var _searchParameter = transmitedSearchParameter;
    print("Searchparameter Categorie: " + _searchParameter.category);
  }
}
