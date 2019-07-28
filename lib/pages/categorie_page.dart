import 'package:flutter/material.dart';
import '../model/contact.dart';

class CategoriePage extends StatefulWidget {
  @override
  _CategoriePageState createState() => _CategoriePageState();
}

class _CategoriePageState extends State<CategoriePage> {
  String _categorieChoosed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Choisissez une categorie"),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return _buildTiles(listOfTiles[index]);
        },
        itemCount: listOfTiles.length,
      ),
    );
  }

  Widget _buildTiles(MyTile t) {
    if (t.children.isEmpty)
      return new ListTile(
          dense: true,
          enabled: true,
          isThreeLine: false,
          onLongPress: () => print("long press"),
          onTap: () => submitCategorie(t),
          subtitle: new Text("Subtitle"),
          leading: new Text("Leading"),
          selected: true,
          trailing: new Text("trailing"),
          title: new Text(t.title));

    return new ExpansionTile(
      key: new PageStorageKey<int>(3),
      title: new Text(t.title),
      children: t.children.map(_buildTiles).toList(),
    );
  }

  void submitCategorie(MyTile t) {
    Navigator.of(context).pop(t.title);
  }
}

/*
class CategorieInTiles extends StatelessWidget{
  final MyTile myTile;

  CategorieInTiles(this.myTile);
  @override
  Widget build(BuildContext context) {

    return _buildTiles(myTile);
  }

  Widget _buildTiles(MyTile t){
    if (t.children.isEmpty)
      return new ListTile(
          dense: true,
          enabled: true,
          isThreeLine: false,
          onLongPress: () => print("long press"),
          onTap: () => print(t.title),
          subtitle: new Text("Subtitle"),
          leading: new Text("Leading"),
          selected: true,
          trailing: new Text("trailing"),
          title: new Text(t.title));

    return new ExpansionTile(
      key: new PageStorageKey<int>(3),
      title: new Text(t.title),
      children: t.children.map(_buildTiles).toList(),
    );
  }
}
*/

class MyTile {
  String title;
  List<MyTile> children;

  MyTile(this.title, [this.children = const <MyTile>[]]);
}

List<MyTile> listOfTiles = <MyTile>[
  new MyTile(
    'Animals',
    <MyTile>[
      new MyTile(
        'Dogs',
        <MyTile>[
          new MyTile('Coton de Tulear'),
          new MyTile('German Shepherd'),
          new MyTile('Poodle'),
        ],
      ),
      new MyTile('Cats'),
      new MyTile('Birds'),
    ],
  ),
  new MyTile(
    'Cars',
    <MyTile>[
      new MyTile('Tesla'),
      new MyTile('Toyota'),
    ],
  ),
  new MyTile(
    'Phones',
    <MyTile>[
      new MyTile('Google'),
      new MyTile('Samsung'),
      new MyTile(
        'OnePlus',
        <MyTile>[
          new MyTile('1'),
          new MyTile('2'),
          new MyTile('3'),
          new MyTile('4'),
          new MyTile('5'),
          new MyTile('6'),
          new MyTile('7'),
          new MyTile('8'),
          new MyTile('9'),
          new MyTile('10'),
          new MyTile('11'),
          new MyTile('12'),
        ],
      ),
    ],
  ),
];
