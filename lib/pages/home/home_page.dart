import 'package:emarket_app/component/custom_categorie_button.dart';
import 'package:flutter/material.dart';
import '../../model/post.dart';
import '../../model/posttyp.dart';
import '../../model/feetyp.dart';
import '../../component/home_card.dart';
import '../../component/custom_linear_gradient.dart';

class HomePage extends StatefulWidget {
  final String pageTitle;

  HomePage(this.pageTitle);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  bool _isSearching;
  String _searchText = "";
  List<Post> searchResult = new List();

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
                      padding: const EdgeInsets.all(15.0),
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
        return Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Aucun resultat pour votre recherche",
                textAlign: TextAlign.center,
              ),
            ],
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

  static List<Post> postList = []
    ..add(Post(
        'Telephone',
        new DateTime(2011, 9, 7, 17, 30),
        '00237633333',
        'ndanjid@yahoo.fr',
        'Electromenager',
        PostTyp.offer,
        'description Telephone',
        540000,
        FeeTyp.negotiable,
        'Douala',
        'Deido',
        5))
    ..add(Post(
        'Friteuse',
        new DateTime(2012, 9, 7, 17, 30),
        '002376444447',
        'ndanjid@yahoo.fr',
        'Electromenager',
        PostTyp.offer,
        'description Friteuse',
        250000,
        FeeTyp.negotiable,
        'Mbouda',
        'centre',
        6))
    ..add(Post(
        'Bouteille de gaz',
        new DateTime(2013, 9, 7, 17, 30),
        '002375555577',
        'ndanjid@yahoo.fr',
        'Electromenager',
        PostTyp.offer,
        'description Bouteille de gaz',
        120000,
        FeeTyp.negotiable,
        'Yaounde',
        'Nvog Beti',
        5))
    ..add(Post(
        'Telephone',
        new DateTime(2014, 9, 7, 17, 30),
        '002376766677',
        'ndanjid@yahoo.fr',
        'Electromenager',
        PostTyp.offer,
        'description Telephone',
        80000,
        FeeTyp.negotiable,
        'Bafoussam',
        'Sokada',
        6))
    ..add(Post(
        'Sac à main',
        new DateTime(2015, 9, 7, 17, 30),
        '0023788888',
        'ndanjid@yahoo.fr',
        'Electromenager',
        PostTyp.offer,
        'description Sac à main',
        670000,
        FeeTyp.negotiable,
        'Bandjoun',
        'Tobeu',
        5))
    ..add(Post(
        'Voiture',
        new DateTime(2016, 9, 7, 17, 30),
        '00237676999',
        'ndanjid@yahoo.fr',
        'Electromenager',
        PostTyp.offer,
        'description Voiture',
        340000,
        FeeTyp.negotiable,
        'Bangangte',
        'Lycee technique',
        6))
    ..add(Post(
        'Televiseur',
        new DateTime(2017, 9, 7, 17, 30),
        '0023763333',
        'ndanjid@yahoo.fr',
        'Electromenager',
        PostTyp.offer,
        'description Televiseur',
        230000,
        FeeTyp.negotiable,
        'Douala',
        'Bonamoussadi',
        7))
    ..add(Post(
        'Livre de math',
        new DateTime(2018, 9, 7, 17, 30),
        '002376767677',
        'ndanjid@yahoo.fr',
        'Electromenager',
        PostTyp.offer,
        'description Livre de math',
        120000,
        FeeTyp.negotiable,
        'Yaounde',
        'Mokolo',
        8))
    ..add(Post(
        'Pantalon',
        new DateTime(2019, 9, 7, 17, 30),
        '002376767677',
        'ndanjid@yahoo.fr',
        'Electromenager',
        PostTyp.offer,
        'description Pantalon',
        50000,
        FeeTyp.negotiable,
        'Bangangte',
        'Centre',
        5))
    ..add(Post(
        'Sac de classe',
        new DateTime(2020, 9, 7, 17, 30),
        '002376767677',
        'ndanjid@yahoo.fr',
        'Electromenager',
        PostTyp.offer,
        'description Sac de classe',
        90000,
        FeeTyp.negotiable,
        'Bandjoun',
        'Centre',
        7))
    ..add(
        Post('Salle à manger', new DateTime(2021, 9, 7, 17, 30), '002376767677', 'ndanjid@yahoo.fr', 'Electromenager', PostTyp.offer, 'description Salle à manger', 80000, FeeTyp.negotiable, 'Yaounde', 'Mokolo', 5))
    ..add(Post('Chargeur', new DateTime(2022, 9, 7, 17, 30), '002376767677', 'ndanjid@yahoo.fr', 'Electromenager', PostTyp.offer, 'description Chargeur', 60000, FeeTyp.negotiable, 'Ngaoundal', 'Ville', 8))
    ..add(Post('Moto', new DateTime(2017, 9, 7, 17, 30), '002376767677', 'ndanjid@yahoo.fr', 'Electromenager', PostTyp.offer, 'description Moto', 40000, FeeTyp.negotiable, 'Mbouda', 'Mokolo', 8))
    ..add(Post('Trouce mecanique', new DateTime(2012, 9, 7, 17, 30), '002376767677', 'ndanjid@yahoo.fr', 'Electromenager', PostTyp.offer, 'description Trouce mecanique', 30000, FeeTyp.negotiable, 'Yaounde', 'Madagascar', 5))
    ..add(Post('Vélo', new DateTime(2013, 9, 7, 17, 30), '002376767677', 'ndanjid@yahoo.fr', 'Electromenager', PostTyp.offer, 'description Vélo', 250000, FeeTyp.negotiable, 'Ngaoundal', 'Gare', 6));
}
