import 'package:emarket_app/global/global_color.dart';
import 'package:emarket_app/global/global_styling.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/categorie.dart';
import 'package:emarket_app/model/categorie_tile.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:emarket_app/util/util.dart';
import 'package:flutter/material.dart';

import '../../services/categorie_service.dart';

class CategoriePage extends StatefulWidget {
  @override
  _CategoriePageState createState() => _CategoriePageState();
}

class _CategoriePageState extends State<CategoriePage> {
  CategorieService _categorieService = new CategorieService();
  List<Categorie> categories = new List();
  List<CategorieTile> categoriesTiles = new List();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);
    return WillPopScope(
      onWillPop: _backPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child:
                Text(AppLocalizations.of(context).translate('choose_category')),
          ),
          backgroundColor: GlobalColor.colorDeepPurple400,
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return _buildCategories(categoriesTiles[index]);
          },
          itemCount: categoriesTiles.length,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadCategorie();
  }

  Future<bool> _backPressed() {
    Navigator.of(context).pop(new CategorieTile('', 0));
  }

  Widget _buildCategories(CategorieTile categorieTile) {
    if (categorieTile.children == null)
      return new ListTile(
          dense: true,
          enabled: true,
          isThreeLine: false,
          onLongPress: () => print("long press"),
          onTap: () => submitCategorie(categorieTile),
          selected: true,
          title: new Text(categorieTile.title));

    return new ExpansionTile(
      key: PageStorageKey<CategorieTile>(categorieTile),
      title: new Text(categorieTile.title),
      leading: Icon(
        Util.getCategoryIcon(categorieTile.id, categorieTile.icon),
        color: Colors.deepPurple,
      ),
      children: categorieTile.children.map(_buildCategories).toList(),
    );
  }

  void submitCategorie(CategorieTile categorieTile) {
    Navigator.of(context).pop(categorieTile);
  }

  Future<void> _loadCategorie() async {
    categories = await _categorieService.fetchCategories();
    List<Categorie> translatedcategories =
        _categorieService.translateCategories(categories, context);

    translatedcategories.sort((a, b) => a.title.compareTo(b.title));

    //put other category at the end of the list
    Categorie categorieTemp = translatedcategories.firstWhere((categorie) =>
        categorie.title == 'Other categories' ||
        categorie.title == 'Autre categories');
    translatedcategories.removeWhere((categorie) =>
        categorie.title == 'Other categories' ||
        categorie.title == 'Autre categories');
    translatedcategories.add(categorieTemp);

    categoriesTiles = await _categorieService
        .mapCategorieToCategorieTile(translatedcategories);
    setState(() {});
  }
}
