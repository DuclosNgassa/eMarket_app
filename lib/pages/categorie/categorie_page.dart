import 'package:emarket_app/model/categorie.dart';
import 'package:emarket_app/model/categorie_tile.dart';
import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/services/global.dart' as prefix0;
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
    return WillPopScope(
      onWillPop: _backPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("Choisissez une categorie"),
          ),
          backgroundColor: colorDeepPurple400,
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

  Widget _buildCategories(CategorieTile categorie) {
    if (categorie.children == null)
      return new ListTile(
          dense: true,
          enabled: true,
          isThreeLine: false,
          onLongPress: () => print("long press"),
          onTap: () => submitCategorie(categorie),
          selected: true,
          title: new Text(categorie.title));

    return new ExpansionTile(
      key: PageStorageKey<CategorieTile>(categorie),
      title: new Text(categorie.title),
      leading: Icon(
        IconData(int.parse(categorie.icon), fontFamily: 'MaterialIcons'),
        color: Colors.deepPurple,
      ),
      children: categorie.children.map(_buildCategories).toList(),
    );
  }

  void submitCategorie(CategorieTile categorieTile) {
    Navigator.of(context).pop(categorieTile);
  }

  Future<void> _loadCategorie() async {
    categories = await _categorieService.fetchCategories();
    categoriesTiles =
        await _categorieService.mapCategorieToCategorieTile(categories);
    setState(() {});
  }
}
