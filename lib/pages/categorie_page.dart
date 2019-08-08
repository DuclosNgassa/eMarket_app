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
          return _buildCategories(categories[index]);
        },
        itemCount: categories.length,
      ),
    );
  }

  Widget _buildCategories(Categorie categorie) {
    if (categorie.children.isEmpty)
      return new ListTile(
          dense: true,
          enabled: true,
          isThreeLine: false,
          onLongPress: () => print("long press"),
          onTap: () => submitCategorie(categorie),
          //subtitle: new Text("Subtitle"),
          //leading: new Text("Leading"),
          selected: true,
          //trailing: new Text("trailing"),
          title: new Text(categorie.title));

    return new ExpansionTile(
      key: PageStorageKey<Categorie>(categorie),
      title: new Text(categorie.title),
      children: categorie.children.map(_buildCategories).toList(),
    );
  }

  void submitCategorie(Categorie t) {
    Navigator.of(context).pop(t.title);
  }
}

class Categorie {
  String title;
  List<Categorie> children;

  Categorie(this.title, [this.children = const <Categorie>[]]);
}

List<Categorie> categories = <Categorie>[
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
        new Categorie('BMW', <Categorie>[
          new Categorie('X1'),
          new Categorie('X2'),
          new Categorie('X5')
        ]),
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
  new Categorie('Dienstleistungen', <Categorie>[
    new Categorie('Altenpflege'),
    new Categorie('Auto, Rad, Boot'),
    new Categorie('Babysitter & Kinderbetreuung'),
    new Categorie('Elektronik'),
    new Categorie('Haus & Garten'),
    new Categorie('Künstler & Musiker'),
    new Categorie('Reise & Event'),
    new Categorie('Tierbetreuung & Training'),
    new Categorie('Umzug & Transport'),
    new Categorie('Weitere Dienstleistungen')
  ]),
  new Categorie('Eintrittskarten & Tickets', <Categorie>[
    new Categorie('Bahn & ÖPVN'),
    new Categorie('Comedy & Kabarett'),
    new Categorie('Gutscheine'),
    new Categorie('Kinder'),
    new Categorie('Konzerte'),
    new Categorie('Sport'),
    new Categorie('Theater & Musical'),
    new Categorie('Weitere Eintrittskarten & Tickets')
  ]),
  new Categorie('Elektronik', <Categorie>[
    new Categorie('Audio & Hifi', <Categorie>[
      new Categorie('CD Player'),
      new Categorie('Lautsprächer & Kopfhörer'),
      new Categorie('MP3 Player'),
      new Categorie('Radio & Receiver'),
      new Categorie('Stereoanlagen'),
      new Categorie('Weiteres Audio & Hifi'),
    ]),
    new Categorie('Dienstleistungen Elektronik'),
    new Categorie('Foto'),
    new Categorie('Handy & Telefon', <Categorie>[
      new Categorie('Apple'),
      new Categorie('HTC'),
      new Categorie('LG'),
      new Categorie('Motorola'),
      new Categorie('Nokia'),
      new Categorie('Huawai'),
      new Categorie('Samsung'),
      new Categorie('Techno'),
      new Categorie('Sony'),
      new Categorie('Siemens'),
      new Categorie('Sony'),
      new Categorie('Faxgerät'),
      new Categorie('Telefone'),
      new Categorie('Weitere Handys & Telefone')
    ]),
    new Categorie('Haushaltsgeräte', <Categorie>[
      new Categorie('Haushaltskleingeräte'),
      new Categorie('Herde & Backöfen'),
      new Categorie('Kaffe & Espressomaschinen'),
      new Categorie('Kühlschränke & Gefriergeräte'),
      new Categorie('Spühlmaschinen'),
      new Categorie('Staubsauger'),
      new Categorie('Waschmaschinen & Trockner'),
      new Categorie('Weitere Haushaltsgeräte')
    ]),
    new Categorie('Konsole', <Categorie>[
      new Categorie('Pocket Konsolen'),
      new Categorie('PlayStation'),
      new Categorie('Xbox'),
      new Categorie('Wii'),
      new Categorie('Gameboy'),
      new Categorie('Weitere Konsolen')
    ]),
    new Categorie('Notebooks'),
    new Categorie('PCs'),
    new Categorie('PC-Zubehör & Software', <Categorie>[
      new Categorie('Drucker & Scanner'),
      new Categorie('festplatten & Laufwerke'),
      new Categorie('Gehäuser'),
      new Categorie('Grafikkarten'),
      new Categorie('Kabel & Adapter'),
      new Categorie('Mainboards'),
      new Categorie('Monitore'),
      new Categorie('Multimedia'),
      new Categorie('Netzwerk & Modem'),
      new Categorie('Prozessoren / CPUs'),
      new Categorie('Speicher'),
      new Categorie('Software'),
      new Categorie('Tastatur & Maus'),
      new Categorie('Weitere PC-Zubehör'),
    ]),
    new Categorie('Tablets & Reader', <Categorie>[
      new Categorie('iPad'),
      new Categorie('Kindle'),
      new Categorie('Samsung Tablets'),
      new Categorie('Huawai Tablets'),
      new Categorie('Weitere Tablets & Reader')
    ]),
    new Categorie('TV & Video', <Categorie>[
      new Categorie('DVD-Player & Recorder'),
      new Categorie('Fernseher'),
      new Categorie('TV-Receiver'),
      new Categorie('Weitere TV & Video')
    ]),
    new Categorie('Videospiele', <Categorie>[
      new Categorie('DS(i)- & PSP Spiele'),
      new Categorie('Nintendo Spiele'),
      new Categorie('PlayStation Spiele'),
      new Categorie('Xbox Spiele'),
      new Categorie('Wii Spiele'),
      new Categorie('PC Spiele'),
      new Categorie('Weitere Videospiele')
    ]),
    new Categorie('Weitere Elektronik')
  ]),
];
