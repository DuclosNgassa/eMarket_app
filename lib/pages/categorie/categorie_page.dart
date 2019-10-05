import 'package:emarket_app/model/categorie.dart';
import 'package:flutter/material.dart';
import '../../services/categorie_service.dart';
import 'package:http/http.dart' as http;

class CategoriePage extends StatefulWidget {
  @override
  _CategoriePageState createState() => _CategoriePageState();
}

class _CategoriePageState extends State<CategoriePage> {
  //String _categorieChoosed;
  CategorieService _categorieService = new CategorieService();
  List<Categorie> categories = new List();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _backPressed,
      child: Scaffold(
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
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadCategorie();
  }

  Future<bool> _backPressed() {
    Navigator.of(context).pop('');
  }

  Widget _buildCategories(Categorie categorie) {
    return new ListTile(
      dense: true,
      enabled: true,
      isThreeLine: false,
      onLongPress: () => print("long press"),
      onTap: () => submitCategorie(categorie),
      //subtitle: new Text("Subtitle"),
      //leading: new Text("Leading"),
      leading: Icon(IconData(int.parse(categorie.icon), fontFamily: 'MaterialIcons')),
      selected: true,
      //trailing: new Text("trailing"),
      title: new Text(
        categorie.title,
        style: TextStyle(
          //fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
    );
  }

/*
  Widget _buildCategories(CategorieTile categorie) {
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
      key: PageStorageKey<CategorieTile>(categorie),
      title: new Text(categorie.title),
      children: categorie.children.map(_buildCategories).toList(),
    );
  }
*/

/*
  Future<List<CategorieTile>> _buildCategoriesTileFromService(List<Categorie> categories) async {
    List<CategorieTile> categorieTiles = new List();

    for(var parent in categories){
      if(parent.parentid == null){//Take only categorie without parent
        CategorieTile categorieTileParent = new CategorieTile(parent.title);
        categorieTileParent.id = parent.id;
      }
    }
  }
*/

  Future<void> _loadCategorie() async {
    categories = await _categorieService.fetchCategories(http.Client());
    setState(() {});
  }

  void submitCategorie(Categorie t) {
    Navigator.of(context).pop(t.title);
  }

/*
  void submitCategorie(CategorieTile t) {
    Navigator.of(context).pop(t.title);
  }
*/
}

/*
class CategorieTile {
  int id;
  String title;
  List<CategorieTile> children;

  CategorieTile(this.title, [this.children = const <CategorieTile>[]]);
}
*/

/*
List<CategorieTile> categories = <CategorieTile>[
  new CategorieTile(
    'Autos, Rad & Boot',
    <CategorieTile>[
      new CategorieTile('Autos', <CategorieTile>[
        new CategorieTile('Toyota', <CategorieTile>[
          new CategorieTile('Carina 2'),
          new CategorieTile('Rav4'),
          new CategorieTile('Prado')
        ]),
        new CategorieTile('Audi', <CategorieTile>[
          new CategorieTile('A4'),
          new CategorieTile('Desperate'),
          new CategorieTile('A3')
        ]),
        new CategorieTile('BMW', <CategorieTile>[
          new CategorieTile('X1'),
          new CategorieTile('X2'),
          new CategorieTile('X5')
        ]),
        new CategorieTile('Mercedes', <CategorieTile>[
          new CategorieTile('C'),
          new CategorieTile('Benz'),
          new CategorieTile('Furios')
        ]),
        new CategorieTile('Ford', <CategorieTile>[
          new CategorieTile('Focus'),
          new CategorieTile('Murano'),
          new CategorieTile('Fiesto')
        ]),
        new CategorieTile('Citroen', <CategorieTile>[
          new CategorieTile('C4'),
          new CategorieTile('Bis'),
          new CategorieTile('Futur')
        ]),
        new CategorieTile('Fiat'),
        new CategorieTile('Hyundai'),
        new CategorieTile('Jaguar'),
      ]),
      new CategorieTile('Autoteile & Reifen', <CategorieTile>[
        new CategorieTile('Auto Hifi & Navigation'),
        new CategorieTile('Ersatz und Reparaturteile'),
        new CategorieTile('Reifen & Felgen'),
        new CategorieTile('Tuning & Styling'),
        new CategorieTile('Werkzeug'),
        new CategorieTile('Weitere Autoteile'),
      ]),
      new CategorieTile('Boote & Bootzubehör', <CategorieTile>[
        new CategorieTile('Motorboote'),
        new CategorieTile('Segelboote'),
        new CategorieTile('Kleinboote'),
        new CategorieTile('Schlauchboote'),
        new CategorieTile('Jetski'),
        new CategorieTile('Bootstrailer'),
        new CategorieTile('Bootliegeplätze'),
        new CategorieTile('Bootzubehör'),
        new CategorieTile('Weitere Boote'),
      ]),
      new CategorieTile('Fahrräder & Zubehör', <CategorieTile>[
        new CategorieTile('Damen'),
        new CategorieTile('Herren'),
        new CategorieTile('Kinder'),
        new CategorieTile('Zubehör'),
        new CategorieTile('Weitere Fahrräder & Zubehör'),
      ]),
      new CategorieTile('Motorräder & Motorroller', <CategorieTile>[
        new CategorieTile('Mofas & Mopeds', <CategorieTile>[
          new CategorieTile('Aprilia'),
          new CategorieTile('BMW'),
          new CategorieTile('Buell'),
          new CategorieTile('Harley'),
          new CategorieTile('Honda'),
          new CategorieTile('Kymco'),
          new CategorieTile('Peugeot'),
          new CategorieTile('Piaggo'),
          new CategorieTile('Kawasaki'),
        ]),
        new CategorieTile('Motorräder', <CategorieTile>[
          new CategorieTile('Aprilia'),
          new CategorieTile('BMW'),
          new CategorieTile('Buell'),
          new CategorieTile('Harley'),
          new CategorieTile('Honda'),
          new CategorieTile('Kymco'),
          new CategorieTile('Peugeot'),
          new CategorieTile('Piaggo'),
          new CategorieTile('Kawasaki'),
        ]),
        new CategorieTile('Quads', <CategorieTile>[
          new CategorieTile('Aprilia'),
          new CategorieTile('BMW'),
          new CategorieTile('Buell'),
          new CategorieTile('Harley'),
          new CategorieTile('Honda'),
          new CategorieTile('Kymco'),
          new CategorieTile('Peugeot'),
          new CategorieTile('Piaggo'),
          new CategorieTile('Kawasaki'),
        ]),
        new CategorieTile('Motorroller & Scooter', <CategorieTile>[
          new CategorieTile('Aprilia'),
          new CategorieTile('BMW'),
          new CategorieTile('Buell'),
          new CategorieTile('Harley'),
          new CategorieTile('Honda'),
          new CategorieTile('Kymco'),
          new CategorieTile('Peugeot'),
          new CategorieTile('Piaggo'),
          new CategorieTile('Kawasaki'),
        ]),
      ]),
      new CategorieTile('Motorradteile & Zubehör', <CategorieTile>[
        new CategorieTile('Ersatz- & Reparaturteile'),
        new CategorieTile('Reifen & Felgen'),
        new CategorieTile('Motorradbekleidung'),
      ]),
      new CategorieTile('Nutzfahrzeuge & Anhänger', <CategorieTile>[
        new CategorieTile('Agrarfahrzeuge'),
        new CategorieTile('Anhänger'),
        new CategorieTile('Baumaschinen'),
        new CategorieTile('Busse'),
        new CategorieTile('LKW'),
        new CategorieTile('Sattelzugmaschinen & Auflieger'),
        new CategorieTile('Spatler'),
        new CategorieTile('Nutzfahrzeugteile & Zubehör'),
        new CategorieTile('Weitere Nutzfahrzeugteile & Anhänger'),
      ]),
      new CategorieTile('Reparaturen & Dienstleistungen'),
      new CategorieTile('Wohnwagen & -mobile', <CategorieTile>[
        new CategorieTile('Alkoven', <CategorieTile>[
          new CategorieTile('Adria'),
          new CategorieTile('Fiat'),
          new CategorieTile('Ford'),
          new CategorieTile('Hobby'),
          new CategorieTile('Carado')
        ]),
        new CategorieTile('Integrierter', <CategorieTile>[
          new CategorieTile('Adria'),
          new CategorieTile('Fiat'),
          new CategorieTile('Ford'),
          new CategorieTile('Hobby'),
          new CategorieTile('Carado')
        ]),
        new CategorieTile('Kastenwagen', <CategorieTile>[
          new CategorieTile('Adria'),
          new CategorieTile('Fiat'),
          new CategorieTile('Ford'),
          new CategorieTile('Hobby'),
          new CategorieTile('Carado')
        ]),
        new CategorieTile('Teilintegrierter', <CategorieTile>[
          new CategorieTile('Adria'),
          new CategorieTile('Fiat'),
          new CategorieTile('Ford'),
          new CategorieTile('Hobby'),
          new CategorieTile('Carado')
        ]),
        new CategorieTile('Wohnwagen', <CategorieTile>[
          new CategorieTile('Adria'),
          new CategorieTile('Fiat'),
          new CategorieTile('Ford'),
          new CategorieTile('Hobby'),
          new CategorieTile('Carado')
        ]),
        new CategorieTile('Weitere Wohnwagen & -mobile', <CategorieTile>[
          new CategorieTile('Adria'),
          new CategorieTile('Fiat'),
          new CategorieTile('Ford'),
          new CategorieTile('Hobby'),
          new CategorieTile('Carado')
        ]),
      ]),
      new CategorieTile('Weiteres Auto, Rad & Boot'),
    ],
  ),
  new CategorieTile('Dienstleistungen', <CategorieTile>[
    new CategorieTile('Altenpflege'),
    new CategorieTile('Auto, Rad, Boot'),
    new CategorieTile('Babysitter & Kinderbetreuung'),
    new CategorieTile('Elektronik'),
    new CategorieTile('Haus & Garten'),
    new CategorieTile('Künstler & Musiker'),
    new CategorieTile('Reise & Event'),
    new CategorieTile('Tierbetreuung & Training'),
    new CategorieTile('Umzug & Transport'),
    new CategorieTile('Weitere Dienstleistungen')
  ]),
  new CategorieTile('Eintrittskarten & Tickets', <CategorieTile>[
    new CategorieTile('Bahn & ÖPVN'),
    new CategorieTile('Comedy & Kabarett'),
    new CategorieTile('Gutscheine'),
    new CategorieTile('Kinder'),
    new CategorieTile('Konzerte'),
    new CategorieTile('Sport'),
    new CategorieTile('Theater & Musical'),
    new CategorieTile('Weitere Eintrittskarten & Tickets')
  ]),
  new CategorieTile('Elektronik', <CategorieTile>[
    new CategorieTile('Audio & Hifi', <CategorieTile>[
      new CategorieTile('CD Player'),
      new CategorieTile('Lautsprächer & Kopfhörer'),
      new CategorieTile('MP3 Player'),
      new CategorieTile('Radio & Receiver'),
      new CategorieTile('Stereoanlagen'),
      new CategorieTile('Weiteres Audio & Hifi'),
    ]),
    new CategorieTile('Dienstleistungen Elektronik'),
    new CategorieTile('Foto'),
    new CategorieTile('Handy & Telefon', <CategorieTile>[
      new CategorieTile('Apple'),
      new CategorieTile('HTC'),
      new CategorieTile('LG'),
      new CategorieTile('Motorola'),
      new CategorieTile('Nokia'),
      new CategorieTile('Huawai'),
      new CategorieTile('Samsung'),
      new CategorieTile('Techno'),
      new CategorieTile('Sony'),
      new CategorieTile('Siemens'),
      new CategorieTile('Faxgerät'),
      new CategorieTile('Telefone'),
      new CategorieTile('Weitere Handys & Telefone')
    ]),
    new CategorieTile('Haushaltsgeräte', <CategorieTile>[
      new CategorieTile('Haushaltskleingeräte'),
      new CategorieTile('Herde & Backöfen'),
      new CategorieTile('Kaffe & Espressomaschinen'),
      new CategorieTile('Kühlschränke & Gefriergeräte'),
      new CategorieTile('Spühlmaschinen'),
      new CategorieTile('Staubsauger'),
      new CategorieTile('Waschmaschinen & Trockner'),
      new CategorieTile('Weitere Haushaltsgeräte')
    ]),
    new CategorieTile('Konsole', <CategorieTile>[
      new CategorieTile('Pocket Konsolen'),
      new CategorieTile('PlayStation'),
      new CategorieTile('Xbox'),
      new CategorieTile('Wii'),
      new CategorieTile('Gameboy'),
      new CategorieTile('Weitere Konsolen')
    ]),
    new CategorieTile('Notebooks'),
    new CategorieTile('PCs'),
    new CategorieTile('PC-Zubehör & Software', <CategorieTile>[
      new CategorieTile('Drucker & Scanner'),
      new CategorieTile('Festplatten & Laufwerke'),
      new CategorieTile('Gehäuser'),
      new CategorieTile('Grafikkarten'),
      new CategorieTile('Kabel & Adapter'),
      new CategorieTile('Mainboards'),
      new CategorieTile('Monitore'),
      new CategorieTile('Multimedia'),
      new CategorieTile('Netzwerk & Modem'),
      new CategorieTile('Prozessoren / CPUs'),
      new CategorieTile('Speicher'),
      new CategorieTile('Software'),
      new CategorieTile('Tastatur & Maus'),
      new CategorieTile('Weitere PC-Zubehör'),
    ]),
    new CategorieTile('Tablets & Reader', <CategorieTile>[
      new CategorieTile('iPad'),
      new CategorieTile('Kindle'),
      new CategorieTile('Samsung Tablets'),
      new CategorieTile('Huawai Tablets'),
      new CategorieTile('Weitere Tablets & Reader')
    ]),
    new CategorieTile('TV & Video', <CategorieTile>[
      new CategorieTile('DVD-Player & Recorder'),
      new CategorieTile('Fernseher'),
      new CategorieTile('TV-Receiver'),
      new CategorieTile('Weitere TV & Video')
    ]),
    new CategorieTile('Videospiele', <CategorieTile>[
      new CategorieTile('DS(i)- & PSP Spiele'),
      new CategorieTile('Nintendo Spiele'),
      new CategorieTile('PlayStation Spiele'),
      new CategorieTile('Xbox Spiele'),
      new CategorieTile('Wii Spiele'),
      new CategorieTile('PC Spiele'),
      new CategorieTile('Weitere Videospiele')
    ]),
    new CategorieTile('Weitere Elektronik')
  ]),
  new CategorieTile('Familie, Kind & Baby', <CategorieTile>[
    new CategorieTile('Altenpflege'),
    new CategorieTile('Baby- & Kinderkleidung', [
      new CategorieTile('< 56'),
      new CategorieTile('56'),
      new CategorieTile('68'),
      new CategorieTile('74'),
      new CategorieTile('80'),
      new CategorieTile('86'),
      new CategorieTile('Autres tailles'),
    ]),
    new CategorieTile('Baby- & Kinderschuhe', <CategorieTile>[
      new CategorieTile('< 20'),
      new CategorieTile('20'),
      new CategorieTile('21'),
      new CategorieTile('22'),
      new CategorieTile('23'),
      new CategorieTile('24'),
      new CategorieTile('Autres tailles'),
    ]),
    new CategorieTile('Baby-Ausstatung'),
    new CategorieTile('Babyschalen & Kindersitze'),
    new CategorieTile('Babysitter & Kinderbetreuung'),
    new CategorieTile('Kinderwagen & Buggys'),
    new CategorieTile('Kinderzimmermöbel', <CategorieTile>[
      new CategorieTile('Betten & Wiegen'),
      new CategorieTile('Hochstühle & Laufställe'),
      new CategorieTile('Schränke & Kommoden'),
      new CategorieTile('Wickeltische & Zubehör'),
      new CategorieTile('Wippen & Schaukeln'),
      new CategorieTile('Autres meubles pour chambre d´enfants'),
    ]),
    new CategorieTile('Spielzeug', <CategorieTile>[
      new CategorieTile('Action- & Spielfiguren'),
      new CategorieTile('Babyspielzeug'),
      new CategorieTile('Barbie & Co'),
      new CategorieTile('Dreirad & Co'),
      new CategorieTile('Gesellschaftspiele'),
      new CategorieTile('Holzspielzeug'),
      new CategorieTile('LEGO & Duplo'),
      new CategorieTile('Lernspielzeug'),
      new CategorieTile('Playmobil'),
      new CategorieTile('Puppen'),
      new CategorieTile('Spielzeugautos'),
      new CategorieTile('Spielzeug für draußen'),
      new CategorieTile('Stofftiere'),
      new CategorieTile('Weitere Spielzeug'),
    ]),
    new CategorieTile('Weitere Familie, Kind & Baby')
  ]),
  new CategorieTile('Freizeit, Hoby & Nachbarschaft', <CategorieTile>[
    new CategorieTile('Essen & Trinken'),
    new CategorieTile('Freizeitaktivitäten'),
    new CategorieTile('Handarbeit, Basteln & Kunsthandwerk'),
    new CategorieTile('Kunst & Antiquitäten'),
    new CategorieTile('Künstler & Musiker'),
    new CategorieTile('Modellbau'),
    new CategorieTile('Reise & Eventservices'),
    new CategorieTile('Sammeln', <CategorieTile>[
      new CategorieTile('Ansichts- & Postkarte'),
      new CategorieTile('Autogramme'),
      new CategorieTile('Brierkrüge & -gläser'),
      new CategorieTile('Briefmarken'),
      new CategorieTile('Comics'),
      new CategorieTile('Flaggen'),
      new CategorieTile('Münzen'),
      new CategorieTile('Porzellan'),
      new CategorieTile('Puppen & Puppenzubehör'),
      new CategorieTile('Sammelbilder & Sticker'),
      new CategorieTile('Sammelkartenspiele'),
      new CategorieTile('Weitere Sammel'),
    ]),
    new CategorieTile('Sport & Camping', <CategorieTile>[
      new CategorieTile('Ballsport'),
      new CategorieTile('Camping & Outdoor'),
      new CategorieTile('Fitness'),
      new CategorieTile('Radsport'),
      new CategorieTile('Tanzen & Laufen'),
      new CategorieTile('Wassersport'),
      new CategorieTile('Weitere Sport & Camping'),
    ]),
    new CategorieTile('Trödel'),
    new CategorieTile('Verloren & Gefunden'),
    new CategorieTile('Weitere Freizeit, Hoby & Nachbarschaft'),
  ]),
  new CategorieTile('Haus & Garten', <CategorieTile>[
    new CategorieTile('Badezimmer'),
    new CategorieTile('Büro'),
    new CategorieTile('Dekoration'),
    new CategorieTile('Dienstleistungen Haus & Garten', <CategorieTile>[
      new CategorieTile('Bau & Handwerk'),
      new CategorieTile('Garten- & Landschaftsbau'),
      new CategorieTile('Haushaltshilfe'),
      new CategorieTile('Reinigungsservice'),
      new CategorieTile('Reparaturen'),
      new CategorieTile('Weitere Dienstleistungen Haus & Garten'),
    ]),
    new CategorieTile('Gartenzubehör & Pflanzen', <CategorieTile>[
      new CategorieTile('Blumentöpfe'),
      new CategorieTile('Dekoration'),
      new CategorieTile('Gartengeräte'),
      new CategorieTile('Gartenmöbel'),
      new CategorieTile('Pflanzen'),
      new CategorieTile('Weitere Gartenzubehör & Pflanzen'),
    ]),
    new CategorieTile('Heimtextilien'),
    new CategorieTile('Heimwerken'),
    new CategorieTile('Küche & Zimmer', <CategorieTile>[
      new CategorieTile('Besteck'),
      new CategorieTile('Geschirr'),
      new CategorieTile('Gläser'),
      new CategorieTile('Kleingeräte'),
      new CategorieTile('Küchenschränke'),
      new CategorieTile('Stühle'),
      new CategorieTile('Tisch'),
      new CategorieTile('Weiteres Küche & Zimmer'),
    ]),
    new CategorieTile('Lampen & Licht'),
    new CategorieTile('Schlafzimmer', <CategorieTile>[
      new CategorieTile('Betten'),
      new CategorieTile('Lattenroste'),
      new CategorieTile('Matratzen'),
      new CategorieTile('Nachttische'),
      new CategorieTile('Küchenschränke'),
      new CategorieTile('Schränke'),
      new CategorieTile('Weiteres Schlafzimmer'),
    ]),
    new CategorieTile('Wohnzimmer', <CategorieTile>[
      new CategorieTile('Regale'),
      new CategorieTile('Schränke & Schrankwände'),
      new CategorieTile('Sitzmöbel'),
      new CategorieTile('Sofas & Sitzgarnituren'),
      new CategorieTile('Tische'),
      new CategorieTile('TV & Phonomöbel'),
      new CategorieTile('Weiteres Wohnzimmer'),
    ]),
    new CategorieTile('Weitere Haus & Garten'),
  ]),
  new CategorieTile('Haustiere', <CategorieTile>[
    new CategorieTile('Fische'),
    new CategorieTile('Hunde'),
    new CategorieTile('Katzen'),
    new CategorieTile('Kleintiere'),
    new CategorieTile('Pferde'),
    new CategorieTile('Reptilien'),
    new CategorieTile('Tierbetreuung & Training'),
    new CategorieTile('Vermisste Tiere'),
    new CategorieTile('Vögel'),
    new CategorieTile('Zubehör'),
    new CategorieTile('Weiteres Haustiere'),
  ]),
  new CategorieTile('Immobilien', <CategorieTile>[
    new CategorieTile('Auf Zeit & WG', <CategorieTile>[
      new CategorieTile('befristet'),
      new CategorieTile('unbefristet'),
    ]),
    new CategorieTile('Eigentumswohnungen'),
    new CategorieTile('Ferien- & Auslandsimmobilien', <CategorieTile>[
      new CategorieTile('Kaufen'),
      new CategorieTile('Mieten'),
    ]),
    new CategorieTile('Garagen & Stellplätze', <CategorieTile>[
      new CategorieTile('Kaufen'),
      new CategorieTile('Mieten'),
    ]),
    new CategorieTile('Gewerbeimmobilien', <CategorieTile>[
      new CategorieTile('Kaufen'),
      new CategorieTile('Mieten'),
    ]),
    new CategorieTile('Grundstücke & Gärten', <CategorieTile>[
      new CategorieTile('Baugrunstück', <CategorieTile>[
        new CategorieTile('Kaufen'),
        new CategorieTile('Mieten'),
      ]),
      new CategorieTile('Garten', <CategorieTile>[
        new CategorieTile('Kaufen'),
        new CategorieTile('Mieten'),
      ]),
      new CategorieTile('Land-/Forstwirtschaft', <CategorieTile>[
        new CategorieTile('Kaufen'),
        new CategorieTile('Mieten'),
      ]),
      new CategorieTile('Weitere Grundstücke & Gärten', <CategorieTile>[
        new CategorieTile('Kaufen'),
        new CategorieTile('Mieten'),
      ]),
    ]),
    new CategorieTile('Häuser zum Kauf'),
    new CategorieTile('Häuser zr Miete'),
    new CategorieTile('Mietwohnungen'),
    new CategorieTile('Umzug & Transport'),
    new CategorieTile('Weiteres Immobilien'),
  ]),
  new CategorieTile('Jobs', <CategorieTile>[
    new CategorieTile('Ausbildung'),
    new CategorieTile('Bau, Handwerk & Produktion', <CategorieTile>[
      new CategorieTile('Bauhelfer'),
      new CategorieTile('Dachdecker'),
      new CategorieTile('Elektriker'),
      new CategorieTile('Fliesenleger'),
      new CategorieTile('Maler'),
      new CategorieTile('Maurer'),
      new CategorieTile('Produktionshelfer'),
      new CategorieTile('Schlosser'),
      new CategorieTile('Tischler'),
      new CategorieTile('Weitere Berufe'),
    ]),
    new CategorieTile('Büroarbeit & Verwaltung', <CategorieTile>[
      new CategorieTile('Buchhalter'),
      new CategorieTile('Bürokauffrau/-mann'),
      new CategorieTile('Sachbearbeiter/in'),
      new CategorieTile('Sekretärin'),
      new CategorieTile('Weitere Berufe'),
    ]),
    new CategorieTile('Gastronomie & Tourismus', <CategorieTile>[
      new CategorieTile('Barkeeper'),
      new CategorieTile('Hotelfachfrau/mann'),
      new CategorieTile('Kellner/-in'),
      new CategorieTile('Koch/Köchin'),
      new CategorieTile('Küchenhilfe'),
      new CategorieTile('Servicekraft'),
      new CategorieTile('Zimmermädchen'),
      new CategorieTile('Weitere Berufe'),
    ]),
    new CategorieTile('Kundenservice & Call Center'),
    new CategorieTile('Mini- & Nebenjobs'),
    new CategorieTile('Praktika'),
    new CategorieTile('Sozialer Sektor & Pflege', <CategorieTile>[
      new CategorieTile('Altenpfleger/-in'),
      new CategorieTile('Arzthelfer/-in'),
      new CategorieTile('Erzieher/-in'),
      new CategorieTile('Krankenschwester / Krankenpfleger'),
      new CategorieTile('Physiotherapeut/-in'),
      new CategorieTile('Weitere Berufe'),
    ]),
    new CategorieTile('Transport, Logistik & Verkehr', <CategorieTile>[
      new CategorieTile('Kraftfahrer'),
      new CategorieTile('Kurierfahrer'),
      new CategorieTile('Lagerhelfer'),
      new CategorieTile('Stapelfahrer'),
      new CategorieTile('Weitere Berufe'),
    ]),
    new CategorieTile('Vertrieb, Einkauf & Verkauf', <CategorieTile>[
      new CategorieTile('Buchhalter/-in'),
      new CategorieTile('Immobilienmakler'),
      new CategorieTile('Kaufmann/frau'),
      new CategorieTile('Verkäufer/-in'),
      new CategorieTile('Weitere Berufe'),
    ]),
    new CategorieTile('Weitere Jobs', <CategorieTile>[
      new CategorieTile('Designer/grafiker'),
      new CategorieTile('Friseur/-in'),
      new CategorieTile('Haushaltshilfe'),
      new CategorieTile('Hausmeister'),
      new CategorieTile('Reinigungskraft'),
      new CategorieTile('Weitere Berufe'),
    ]),
  ]),
  new CategorieTile('Mode & Beauty', <CategorieTile>[
    new CategorieTile('Accessoires & Schmuck'),
    new CategorieTile('Beauty & Gesundheit', <CategorieTile>[
      new CategorieTile('Make-Up & Gesichtspflege'),
      new CategorieTile('Haarpflege'),
      new CategorieTile('Körperpflege'),
      new CategorieTile('Hand- & Nagelpflege'),
      new CategorieTile('Gesundheit'),
      new CategorieTile('Weiteres Beauty & Gesundheit'),
    ]),
    new CategorieTile('Damenbekleidung', <CategorieTile>[
      new CategorieTile('Hemden & Blusen', <CategorieTile>[
        new CategorieTile('XS'),
        new CategorieTile('S'),
        new CategorieTile('M'),
        new CategorieTile('L'),
        new CategorieTile('XL'),
        new CategorieTile('XXL'),
      ]),
      new CategorieTile('Hosen', <CategorieTile>[
        new CategorieTile('XS'),
        new CategorieTile('S'),
        new CategorieTile('M'),
        new CategorieTile('L'),
        new CategorieTile('XL'),
        new CategorieTile('XXL'),
      ]),
      new CategorieTile('Jacken & Mäntel', <CategorieTile>[
        new CategorieTile('XS'),
        new CategorieTile('S'),
        new CategorieTile('M'),
        new CategorieTile('L'),
        new CategorieTile('XL'),
        new CategorieTile('XXL'),
      ]),
      new CategorieTile('Pullover', <CategorieTile>[
        new CategorieTile('XS'),
        new CategorieTile('S'),
        new CategorieTile('M'),
        new CategorieTile('L'),
        new CategorieTile('XL'),
        new CategorieTile('XXL'),
      ]),
      new CategorieTile('Röcke & Kleider', <CategorieTile>[
        new CategorieTile('XS'),
        new CategorieTile('S'),
        new CategorieTile('M'),
        new CategorieTile('L'),
        new CategorieTile('XL'),
        new CategorieTile('XXL'),
      ]),
      new CategorieTile('Shirts & Tops', <CategorieTile>[
        new CategorieTile('XS'),
        new CategorieTile('S'),
        new CategorieTile('M'),
        new CategorieTile('L'),
        new CategorieTile('XL'),
        new CategorieTile('XXL'),
      ]),
      new CategorieTile('Umstandsmode', <CategorieTile>[
        new CategorieTile('XS'),
        new CategorieTile('S'),
        new CategorieTile('M'),
        new CategorieTile('L'),
        new CategorieTile('XL'),
        new CategorieTile('XXL'),
      ]),
      new CategorieTile('Weitere Damenbekleidung', <CategorieTile>[
        new CategorieTile('XS'),
        new CategorieTile('S'),
        new CategorieTile('M'),
        new CategorieTile('L'),
        new CategorieTile('XL'),
        new CategorieTile('XXL'),
      ]),
    ]),
    new CategorieTile('Damenschuhe', <CategorieTile>[
      new CategorieTile('< 36'),
      new CategorieTile('36'),
      new CategorieTile('37'),
      new CategorieTile('38'),
      new CategorieTile('39'),
      new CategorieTile('40'),
      new CategorieTile('41'),
      new CategorieTile('> 41'),
    ]),
    new CategorieTile('Herrenbekleidung', <CategorieTile>[
      new CategorieTile('Hemden', <CategorieTile>[
        new CategorieTile('S'),
        new CategorieTile('M'),
        new CategorieTile('L'),
        new CategorieTile('XL'),
        new CategorieTile('XXL'),
      ]),
      new CategorieTile('Hosen', <CategorieTile>[
        new CategorieTile('S'),
        new CategorieTile('M'),
        new CategorieTile('L'),
        new CategorieTile('XL'),
        new CategorieTile('XXL'),
      ]),
      new CategorieTile('Jacken & Mäntel', <CategorieTile>[
        new CategorieTile('S'),
        new CategorieTile('M'),
        new CategorieTile('L'),
        new CategorieTile('XL'),
        new CategorieTile('XXL'),
      ]),
      new CategorieTile('Pullover', <CategorieTile>[
        new CategorieTile('S'),
        new CategorieTile('M'),
        new CategorieTile('L'),
        new CategorieTile('XL'),
        new CategorieTile('XXL'),
      ]),
      new CategorieTile('Shirts', <CategorieTile>[
        new CategorieTile('S'),
        new CategorieTile('M'),
        new CategorieTile('L'),
        new CategorieTile('XL'),
        new CategorieTile('XXL'),
      ]),
      new CategorieTile('Weitere Herrenbekleidung', <CategorieTile>[
        new CategorieTile('S'),
        new CategorieTile('M'),
        new CategorieTile('L'),
        new CategorieTile('XL'),
        new CategorieTile('XXL'),
      ]),
    ]),
    new CategorieTile('Herrenschuhe', <CategorieTile>[
      new CategorieTile('< 40'),
      new CategorieTile('40'),
      new CategorieTile('41'),
      new CategorieTile('42'),
      new CategorieTile('43'),
      new CategorieTile('44'),
      new CategorieTile('45'),
      new CategorieTile('> 45'),
    ]),
    new CategorieTile('Weitere Mode & Beauty'),
  ]),
  new CategorieTile('Musik, Filme & Bücher', <CategorieTile>[
    new CategorieTile('Bücher & Zeitschriften', <CategorieTile>[
      new CategorieTile('Kinderbücher'),
      new CategorieTile('Krimis & Thriller'),
      new CategorieTile('Kunst & Kultur'),
      new CategorieTile('Sachbücher'),
      new CategorieTile('Science Fiction'),
      new CategorieTile('Zeitschriften'),
    ]),
    new CategorieTile('Büro & Schreibwaren'),
    new CategorieTile('Comics'),
    new CategorieTile('Fachbücher, Schule & Studium'),
    new CategorieTile('Film & DVD'),
    new CategorieTile('Musik & CDs'),
    new CategorieTile('Musikinstrumente'),
    new CategorieTile('Weitere Musik, Filme & Bücher'),
  ]),
  new CategorieTile('Unterricht & Kurse', <CategorieTile>[
    new CategorieTile('Beauty & Gesundheit'),
    new CategorieTile('Computerkurse'),
    new CategorieTile('Kochen & Backen'),
    new CategorieTile('Kunst & Gestaltung'),
    new CategorieTile('Musik & Gesang'),
    new CategorieTile('Nachhilfe'),
    new CategorieTile('Sportkurse'),
    new CategorieTile('Sprachkurse'),
    new CategorieTile('Tanzkurse'),
    new CategorieTile('Weiterbildung'),
    new CategorieTile('Weitere Unterricht & Kurse'),
  ]),
  new CategorieTile('Verschenken & Tauschen', <CategorieTile>[
    new CategorieTile('Tauschen'),
    new CategorieTile('Verleihen'),
    new CategorieTile('Verschenken'),
  ])
];
*/
