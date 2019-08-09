import 'package:flutter/material.dart';
import 'package:emarket_app/pages/post/post_page.dart';
import '../account.dart';
import '../statistik.dart';
import '../configuration.dart';
import 'package:emarket_app/pages/search/search_page.dart';
import 'package:emarket_app/pages/home/home_page.dart';
import '../../component/custom_linear_gradient.dart';
import '../../model/post.dart';
import '../../model/posttyp.dart';
import '../../model/feetyp.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => new _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("My eMarket App"),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("Duclos Ngassa"),
              accountEmail: Text("ndanjid@yahoo.fr"),
              currentAccountPicture: GestureDetector(
                child: CircleAvatar(
                  backgroundImage: AssetImage('images/profil.JPG'),
                ),
                onTap: () {
                  print("Current User profil");
                },
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('images/background.jpeg'),
                ),
              ),
            ),
            Container(
              color: Colors.transparent,
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text("Inserer"),
                    trailing: Icon(Icons.edit),
                    onTap: _showPostForm,
                  ),
                  ListTile(
                    title: Text("Recherche"),
                    trailing: Icon(Icons.search),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              SearchPage(postList),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text("Configurer une recherche"),
                    trailing: Icon(Icons.build),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              Configuration("Configurer une recherche"),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Mon compte"),
                    trailing: Icon(Icons.account_circle),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              Account(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text("Statistik"),
                    trailing: Icon(Icons.insert_chart),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              Statistik(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text("Abmelden"),
                    trailing: Icon(Icons.directions_run),
                    onTap: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      body: CustomLinearGradient(
        myChild: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Rechercher'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text('Inserer'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Mon compte'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text('Message'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Future _showPostForm() async {
    Navigator.of(context).pop();
    Post post = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PostPage(),
      ),
    );
    if (post != null) {
      //insert new Post in the postList
      //send new Post to backend

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    SearchPage(postList),
    PostPage(),
    Account(),
    Statistik(),
  ];
}
