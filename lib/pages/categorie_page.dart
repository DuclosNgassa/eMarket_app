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
          return _buildTiles(categories[index]);
        },
        itemCount: categories.length,
      ),
    );
  }

  Widget _buildTiles(Categorie t) {
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

      title: new Text(t.title),
      children: t.children.map(_buildTiles).toList(),
    );
  }

  void submitCategorie(Categorie t) {
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

class Categorie {
  String title;
  List<Categorie> children;

  Categorie(this.title, [this.children = const <Categorie>[]]);
}

List<Categorie> categories = <Categorie>[
  new Categorie(
    'Animals',
    <Categorie>[
      new Categorie(
        'Dogs',
        <Categorie>[
          new Categorie('Coton de Tulear'),
          new Categorie('German Shepherd'),
          new Categorie('Poodle'),
        ],
      ),
      new Categorie('Cats'),
      new Categorie('Birds'),
    ],
  ),
  new Categorie(
    'Autos, Rad & Boot',
    <Categorie>[
      new Categorie('Autos', <Categorie>[
        new Categorie('Toyota', <Categorie>[
          new Categorie('Carina 2'),
          new Categorie('Rav4'),
          new Categorie('Prado')
        ]),
        new Categorie('Audi', <Categorie>[
          new Categorie('A4'),
          new Categorie('Desperate'),
          new Categorie('A3')
        ]),
        new Categorie('BMW',
            <Categorie>[new Categorie('X1'), new Categorie('X2'), new Categorie('X5')]),
        new Categorie('Mercedes', <Categorie>[
          new Categorie('C'),
          new Categorie('Benz'),
          new Categorie('Furios')
        ]),
        new Categorie('Ford', <Categorie>[
          new Categorie('Focus'),
          new Categorie('Murano'),
          new Categorie('Fiesto')
        ]),
        new Categorie('Citroen', <Categorie>[
          new Categorie('C4'),
          new Categorie('Bis'),
          new Categorie('Futur')
        ]),
        new Categorie('Fiat'),
        new Categorie('Hyundai'),
        new Categorie('Jaguar'),
      ]),
      new Categorie('Autoteile & Reifen', <Categorie>[
        new Categorie('Auto Hifi & Navigation'),
        new Categorie('Ersatz und Reparaturteile'),
        new Categorie('Reifen & Felgen'),
        new Categorie('Tuning & Styling'),
        new Categorie('Werkzeug'),
        new Categorie('Weitere Autoteile'),
      ]),
      new Categorie('Boote & Bootzubehör', <Categorie>[
        new Categorie('Motorboote'),
        new Categorie('Segelboote'),
        new Categorie('Kleinboote'),
        new Categorie('Schlauchboote'),
        new Categorie('Jetski'),
        new Categorie('Bootstrailer'),
        new Categorie('Bootliegeplätze'),
        new Categorie('Bootzubehör'),
        new Categorie('Weitere Boote'),
      ]),
      new Categorie('Fahrräder & Zubehör', <Categorie>[
        new Categorie('Damen'),
        new Categorie('Herren'),
        new Categorie('Kinder'),
        new Categorie('Zubehör'),
        new Categorie('Weitere Fahrräder & Zubehör'),
      ]),
      new Categorie('Motorräder & Motorroller', <Categorie>[
        new Categorie('Mofas & Mopeds', <Categorie>[
          new Categorie('Aprilia'),
          new Categorie('BMW'),
          new Categorie('Buell'),
          new Categorie('Harley'),
          new Categorie('Honda'),
          new Categorie('Kymco'),
          new Categorie('Peugeot'),
          new Categorie('Piaggo'),
          new Categorie('Kawasaki'),
        ]),
        new Categorie('Motorräder', <Categorie>[
          new Categorie('Aprilia'),
          new Categorie('BMW'),
          new Categorie('Buell'),
          new Categorie('Harley'),
          new Categorie('Honda'),
          new Categorie('Kymco'),
          new Categorie('Peugeot'),
          new Categorie('Piaggo'),
          new Categorie('Kawasaki'),
        ]),
        new Categorie('Quads', <Categorie>[
          new Categorie('Aprilia'),
          new Categorie('BMW'),
          new Categorie('Buell'),
          new Categorie('Harley'),
          new Categorie('Honda'),
          new Categorie('Kymco'),
          new Categorie('Peugeot'),
          new Categorie('Piaggo'),
          new Categorie('Kawasaki'),
        ]),
        new Categorie('Motorroller & Scooter', <Categorie>[
          new Categorie('Aprilia'),
          new Categorie('BMW'),
          new Categorie('Buell'),
          new Categorie('Harley'),
          new Categorie('Honda'),
          new Categorie('Kymco'),
          new Categorie('Peugeot'),
          new Categorie('Piaggo'),
          new Categorie('Kawasaki'),
        ]),
      ]),
      new Categorie('Motorradteile & Zubehör', <Categorie>[
        new Categorie('Ersatz- & Reparaturteile'),
        new Categorie('Reifen & Felgen'),
        new Categorie('Motorradbekleidung'),
      ]),
      new Categorie('Nutzfahrzeuge & Anhänger', <Categorie>[
        new Categorie('Agrarfahrzeuge'),
        new Categorie('Anhänger'),
        new Categorie('Baumaschinen'),
        new Categorie('Busse'),
        new Categorie('LKW'),
        new Categorie('Sattelzugmaschinen & Auflieger'),
        new Categorie('Spatler'),
        new Categorie('Nutzfahrzeugteile & Zubehör'),
        new Categorie('Weitere Nutzfahrzeugteile & Anhänger'),
      ]),
      new Categorie('Reparaturen & Dienstleistungen'),
      new Categorie('Wohnwagen & -mobile', <Categorie>[
        new Categorie('Alkoven', <Categorie>[
          new Categorie('Adria'),
          new Categorie('Fiat'),
          new Categorie('Ford'),
          new Categorie('Hobby'),
          new Categorie('Carado')
        ]),
        new Categorie('Integrierter', <Categorie>[
          new Categorie('Adria'),
          new Categorie('Fiat'),
          new Categorie('Ford'),
          new Categorie('Hobby'),
          new Categorie('Carado')
        ]),
        new Categorie('Kastenwagen', <Categorie>[
          new Categorie('Adria'),
          new Categorie('Fiat'),
          new Categorie('Ford'),
          new Categorie('Hobby'),
          new Categorie('Carado')
        ]),
        new Categorie('Teilintegrierter', <Categorie>[
          new Categorie('Adria'),
          new Categorie('Fiat'),
          new Categorie('Ford'),
          new Categorie('Hobby'),
          new Categorie('Carado')
        ]),
       new Categorie('Wohnwagen', <Categorie>[
          new Categorie('Adria'),
          new Categorie('Fiat'),
          new Categorie('Ford'),
          new Categorie('Hobby'),
          new Categorie('Carado')
        ]),
       new Categorie('Weitere Wohnwagen & -mobile', <Categorie>[
          new Categorie('Adria'),
          new Categorie('Fiat'),
          new Categorie('Ford'),
          new Categorie('Hobby'),
          new Categorie('Carado')
        ]),
      ]),
      new Categorie('Weiteres Auto, Rad & Boot'),
    ],
  ),
  new Categorie(
    'Phones',
    <Categorie>[
      new Categorie('Google'),
      new Categorie('Samsung'),
      new Categorie(
        'OnePlus',
        <Categorie>[
          new Categorie('1'),
          new Categorie('2'),
          new Categorie('3'),
          new Categorie('4'),
          new Categorie('5'),
          new Categorie('6'),
          new Categorie('7'),
          new Categorie('8'),
          new Categorie('9'),
          new Categorie('10'),
          new Categorie('11'),
          new Categorie('12'),
        ],
      ),
    ],
  ),
];
