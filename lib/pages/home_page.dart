import 'package:flutter/material.dart';
import 'post.dart';
import 'account.dart';
import 'statistik.dart';
import 'configuration.dart';
import 'search.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("My eMarket App"),
        backgroundColor: Colors.redAccent,
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
            ListTile(
              title: Text("Inserer"),
              trailing: Icon(Icons.edit),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => Post("Poster une annonce"),
                  ),
                );
              },
            ),
            ListTile(
              title: Text("Recherche"),
              trailing: Icon(Icons.search),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => Search("Recherche"),
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
                    builder: (BuildContext context) => Configuration("Configurer une recherche"),
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
                    builder: (BuildContext context) => Account("Mon compte"),
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
                    builder: (BuildContext context) => Statistik("Statistik"),
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
      ),
      body: new Center(
        child: Text(
          "HomePage",
          style: TextStyle(fontSize: 35.0),
        ),
      ),
    );
  }
}
