import 'package:emarket_app/custom_component/custom_button.dart';
import 'package:emarket_app/model/categorie.dart';
import 'package:emarket_app/model/categorie_tile.dart';
import 'package:emarket_app/pages/contact/contact_page.dart';
import 'package:emarket_app/services/categorie_service.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';

import '../../services/global.dart';

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => new _FaqPageState();
}

class _FaqPageState extends State<FaqPage> with TickerProviderStateMixin {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _textEditingController =
      new TextEditingController();

  final TextEditingController _textController = new TextEditingController();

  CategorieService _categorieService = new CategorieService();
  List<Categorie> categories = new List();
  List<CategorieTile> categoriesTiles = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comment ça marche"),
        backgroundColor: colorDeepPurple400,
      ),
      body: buildListTile(),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadCategorie();
  }

  Widget buildListTile() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return _buildCategories(categoriesTiles[index]);
            },
            itemCount: categoriesTiles.length,
          ),
        ),
        Divider(
          height: SizeConfig.blockSizeVertical * 2,
        ),
        Container(
          width: SizeConfig.screenWidth * 0.9,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CustomButton(
              fillColor: colorDeepPurple400,
              splashColor: Colors.white,
              iconColor: Colors.white,
              text: 'Autres questions? Contactez nous',
              textStyle: SizeConfig.styleButtonWhite,
              onPressed: () => showContactPage(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategories(CategorieTile categorie) {
    if (categorie.children == null)
      return new ListTile(
          dense: true,
          enabled: true,
          isThreeLine: false,
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

  showContactPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ContactPage();
        },
      ),
    );
  }

  Future<void> _loadCategorie() async {
    categories = await _categorieService.fetchCategories();
    categoriesTiles =
        await _categorieService.mapCategorieToCategorieTile(categories);
    setState(() {});
  }
}
