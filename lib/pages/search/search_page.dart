import 'package:emarket_app/global/global_color.dart';
import 'package:emarket_app/global/global_styling.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/categorie.dart';
import 'package:emarket_app/model/enumeration/feetyp.dart';
import 'package:emarket_app/model/enumeration/posttyp.dart';
import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/model/searchparameter.dart';
import 'package:emarket_app/pages/search/search_parameter_page.dart';
import 'package:emarket_app/pages/search/search_result_page.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';

class SearchPage extends SearchDelegate<Post> {
  final List<Post> postList;
  final List<Favorit> myFavorits;
  final String userEmail;
  final String searchLabel;
  SearchParameter searchParameter;
  List<int> childCategories;
  bool showPictures = false;
  Categorie parentCategory;

  SearchPage(this.postList, this.myFavorits, this.userEmail, this.searchLabel,
      this.searchParameter, this.childCategories, this.parentCategory);

  @override
  String get searchFieldLabel => searchLabel;

  @override
  ThemeData appBarTheme(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: GlobalColor.colorDeepPurple300,
      primaryIconTheme: theme.primaryIconTheme,
      primaryColorBrightness: theme.primaryColorBrightness,
      primaryTextTheme: theme.primaryTextTheme,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: Theme.of(context)
            .textTheme
            .title
            .copyWith(color: GlobalColor.colorWhite),
        labelStyle: Theme.of(context)
            .textTheme
            .title
            .copyWith(color: GlobalColor.colorWhite),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    return [
      IconButton(
        icon: Icon(Icons.clear),
        color: GlobalColor.colorWhite,
        onPressed: () => _clearFormSearch(),
      ),
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 2,
        ),
        child: IconButton(
          icon: Icon(Icons.build),
          color: GlobalColor.colorWhite,
          onPressed: () => showSearchParameterPage(context),
        ),
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
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    final List<Post> searchResultList =
        query.isEmpty && searchParameter == null && childCategories == null
            ? postList
            : postList.where((post) => isSelected(post)).toList();

    if (searchResultList.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
          child: Text(
            AppLocalizations.of(context).translate('no_result_found'),
            style: GlobalStyling.styleTitleBlack,
          ),
        ),
      );
    }

    return SearchResultPage(
        searchResultList: searchResultList,
        myFavorits: myFavorits,
        userEmail: userEmail,
        parentCategory: parentCategory);
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
  bool _compareString(String valuePost, String valueSearchParam) {
    // Please don´t change parameter´s order!!!
    if (valueSearchParam == null || valueSearchParam.isEmpty) return true;
    if (valuePost == null || valuePost.isEmpty) return false;

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
    if (feeMinSearchParam == null && feeMaxSearchParam == null) return true;
    if (feeMaxSearchParam == null && feeMinSearchParam != null) {
      return postFee >= feeMinSearchParam;
    }

    if (feeMaxSearchParam != null && feeMinSearchParam == null) {
      return postFee <= feeMaxSearchParam;
    }

    if (feeMaxSearchParam != null && feeMinSearchParam != null) {
      return postFee >= feeMinSearchParam && postFee <= feeMaxSearchParam;
    }

    return false;
  }

  ///  This method compare the postFeeTyp value of a post with the corresponding postFeeTyp value of the searchparameter
  ///  @param postFeeTyp
  ///  @param searchParamFeeTyp
  ///  Please don´t change parameter´s order!!!
  bool _compareFeeTyp(FeeTyp postFeeTyp, FeeTyp searchParamFeeTyp) {
    if (searchParamFeeTyp == null) return true;

    return postFeeTyp == searchParamFeeTyp;
  }

  ///  This method compare the postTyp value of a post with the corresponding postTyp value of the searchparameter
  ///  @param postTyp
  ///  @param searchParamPostTyp
  ///  Please don´t change parameter´s order!!!
  bool _comparePostTyp(PostTyp postTyp, PostTyp searchParamPostTyp) {
    if (searchParamPostTyp == null || searchParamPostTyp == PostTyp.all)
      return true;

    return postTyp == searchParamPostTyp;
  }

  Future showSearchParameterPage(BuildContext context) async {
    searchParameter = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchParameterPage(),
      ),
    );
  }

  void _clearFormSearch() {
    query = "";
    searchParameter = null;
    childCategories = null;
    parentCategory = null;
  }
}
