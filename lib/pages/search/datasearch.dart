import 'package:emarket_app/custom_component/home_card.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/categorie_tile.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/feetyp.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/model/posttyp.dart';
import 'package:emarket_app/model/searchparameter.dart';
import 'package:emarket_app/pages/categorie/categorie_page.dart';
import 'package:emarket_app/pages/search/searchparameter.dart';
import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate<Post> {

  final List<Post> postList;
  final List<Favorit> myFavorits;
  final String userEmail;
  SearchParameter searchParameter;
  List<int> childCategories;

  DataSearch(this.postList, this.myFavorits, this.userEmail, this.searchParameter,
      this.childCategories);

  @override
  String get searchFieldLabel => getSearch();

  String getSearch(){
    return "Search";
    //AppLocalizations.of(context).translate('search');
  }

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
        onPressed: () => _clearFormSearch(),
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

    final resultList =
        query.isEmpty && searchParameter == null && childCategories == null
            ? postList
            : postList.where((post) => isSelected(post)).toList();

    if (resultList.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
          child: Text(
            AppLocalizations.of(context).translate('no_result_found'),
            style: SizeConfig.styleTitleBlack,
          ),
        ),
      );
    }

    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: 2,
      mainAxisSpacing: 0,
      crossAxisSpacing: 0,
      childAspectRatio: 1.5,

      children: List.generate(resultList.length, (index) {
        return Padding(
          padding: EdgeInsets.only(
              left: index % 2 == 0 ? SizeConfig.blockSizeHorizontal * 2 : 0),
          child: HomeCard(
            resultList[index],
            myFavorits,
            userEmail,
            SizeConfig.blockSizeVertical * 18,
            SizeConfig.screenWidth * 0.5 - 10,
          ),
        );
      }),
    );
  }

  bool isSelected(Post post) {
    if (childCategories != null) {
      return childCategories.contains(post.categorieid);
    }

    if (query.isNotEmpty) {
      return post.title.toLowerCase().contains(query.toLowerCase());
    }

    return _compareString(post.title, searchParameter.title) &&
        _compareInt(post.categorieid, searchParameter.category) &&
        _compareFee(post.fee, searchParameter.feeMin, searchParameter.feeMax) &&
        _compareFeeTyp(post.fee_typ, searchParameter.feeTyp) &&
        _comparePostTyp(post.post_typ, searchParameter.postTyp) &&
        _compareString(post.city, searchParameter.city);
  }

  ///  This method compare a string value of a post with the corresponding string value of the searchparameter
  ///  @param valuePost a string value of a post
  ///  @param valueSearchParam a string value of the searchparameter
  ///  Please don´t change parameter´s order!!!
  bool _compareString(String valuePost, String valueSearchParam) { // Please don´t change parameter´s order!!!
    if(valueSearchParam == null || valueSearchParam.isEmpty)
      return true;
    if (valuePost == null || valuePost.isEmpty)
      return false;

    return valuePost.toLowerCase().contains(valueSearchParam.toLowerCase());
  }

  ///  This method compare a int value of a post with the corresponding int value of the searchparameter
  ///  @param valuePost a int value of a post
  ///  @param valueSearchParam a int value of the searchparameter
  ///  Please don´t change parameter´s order!!!
  bool _compareInt(int valuePost, int valueSearchParam) {
    if (valueSearchParam == null) return true;
    if (valuePost == null) return false;

    return valuePost == valueSearchParam;
  }

  ///  This method compare the postfee value of a post with the corresponding postfee value of the searchparameter
  ///  @param postFee
  ///  @param feeMinSearchParam
  ///  @param feeMaxSearchParam
  ///  Please don´t change parameter´s order!!!
  bool _compareFee(int postFee, int feeMinSearchParam, int feeMaxSearchParam) {
    if(feeMinSearchParam == null && feeMaxSearchParam == null)
      return true;
    if (feeMaxSearchParam == null && feeMinSearchParam != null) {
      return postFee >= feeMinSearchParam;
    }

    if (feeMaxSearchParam != null && feeMinSearchParam == null) {
      return postFee <= feeMaxSearchParam;
    }

    if (feeMaxSearchParam != null && feeMinSearchParam != null) {
      return postFee >= feeMinSearchParam &&
          postFee <= feeMaxSearchParam;
    }

    return false;
  }

  ///  This method compare the postFeeTyp value of a post with the corresponding postFeeTyp value of the searchparameter
  ///  @param postFeeTyp
  ///  @param searchParamFeeTyp
  ///  Please don´t change parameter´s order!!!
  bool _compareFeeTyp(FeeTyp postFeeTyp, FeeTyp searchParamFeeTyp) {
    if(searchParamFeeTyp == null)
      return true;

    return postFeeTyp == searchParamFeeTyp;
  }

  ///  This method compare the postTyp value of a post with the corresponding postTyp value of the searchparameter
  ///  @param postTyp
  ///  @param searchParamPostTyp
  ///  Please don´t change parameter´s order!!!
  bool _comparePostTyp(PostTyp postTyp, PostTyp searchParamPostTyp) {
    if(searchParamPostTyp == null || searchParamPostTyp == PostTyp.all)
      return true;

    return postTyp == searchParamPostTyp;
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
    searchParameter = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchParameterPage(),
      ),
    );
    if (searchParameter.city != null) {
      print('Ville: ${searchParameter.city}');
    }

  }

  void _clearFormSearch() {
    query = "";
    searchParameter = null;
    childCategories = null;
  }
}
