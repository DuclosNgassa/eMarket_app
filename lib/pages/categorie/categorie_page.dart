import 'package:flutter/material.dart';

class CategoriePage extends StatefulWidget {
  @override
  _CategoriePageState createState() => _CategoriePageState();
}

class _CategoriePageState extends State<CategoriePage> {
  String _categorieChoosed;

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

  Future<bool> _backPressed(){
     Navigator.of(context).pop('');
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
      new Categorie('Festplatten & Laufwerke'),
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
  new Categorie('Familie, Kind & Baby', <Categorie>[
    new Categorie('Altenpflege'),
    new Categorie('Baby- & Kinderkleidung', [
      new Categorie('< 56'),
      new Categorie('56'),
      new Categorie('68'),
      new Categorie('74'),
      new Categorie('80'),
      new Categorie('86'),
      new Categorie('Autres tailles'),
    ]),
    new Categorie('Baby- & Kinderschuhe', <Categorie>[
      new Categorie('< 20'),
      new Categorie('20'),
      new Categorie('21'),
      new Categorie('22'),
      new Categorie('23'),
      new Categorie('24'),
      new Categorie('Autres tailles'),
    ]),
    new Categorie('Baby-Ausstatung'),
    new Categorie('Babyschalen & Kindersitze'),
    new Categorie('Babysitter & Kinderbetreuung'),
    new Categorie('Kinderwagen & Buggys'),
    new Categorie('Kinderzimmermöbel', <Categorie>[
      new Categorie('Betten & Wiegen'),
      new Categorie('Hochstühle & Laufställe'),
      new Categorie('Schränke & Kommoden'),
      new Categorie('Wickeltische & Zubehör'),
      new Categorie('Wippen & Schaukeln'),
      new Categorie('Autres meubles pour chambre d´enfants'),
    ]),
    new Categorie('Spielzeug', <Categorie>[
      new Categorie('Action- & Spielfiguren'),
      new Categorie('Babyspielzeug'),
      new Categorie('Barbie & Co'),
      new Categorie('Dreirad & Co'),
      new Categorie('Gesellschaftspiele'),
      new Categorie('Holzspielzeug'),
      new Categorie('LEGO & Duplo'),
      new Categorie('Lernspielzeug'),
      new Categorie('Playmobil'),
      new Categorie('Puppen'),
      new Categorie('Spielzeugautos'),
      new Categorie('Spielzeug für draußen'),
      new Categorie('Stofftiere'),
      new Categorie('Weitere Spielzeug'),
    ]),
    new Categorie('Weitere Familie, Kind & Baby')
  ]),
  new Categorie('Freizeit, Hoby & Nachbarschaft', <Categorie>[
    new Categorie('Essen & Trinken'),
    new Categorie('Freizeitaktivitäten'),
    new Categorie('Handarbeit, Basteln & Kunsthandwerk'),
    new Categorie('Kunst & Antiquitäten'),
    new Categorie('Künstler & Musiker'),
    new Categorie('Modellbau'),
    new Categorie('Reise & Eventservices'),
    new Categorie('Sammeln', <Categorie>[
      new Categorie('Ansichts- & Postkarte'),
      new Categorie('Autogramme'),
      new Categorie('Brierkrüge & -gläser'),
      new Categorie('Briefmarken'),
      new Categorie('Comics'),
      new Categorie('Flaggen'),
      new Categorie('Münzen'),
      new Categorie('Porzellan'),
      new Categorie('Puppen & Puppenzubehör'),
      new Categorie('Sammelbilder & Sticker'),
      new Categorie('Sammelkartenspiele'),
      new Categorie('Weitere Sammel'),
    ]),
    new Categorie('Sport & Camping', <Categorie>[
      new Categorie('Ballsport'),
      new Categorie('Camping & Outdoor'),
      new Categorie('Fitness'),
      new Categorie('Radsport'),
      new Categorie('Tanzen & Laufen'),
      new Categorie('Wassersport'),
      new Categorie('Weitere Sport & Camping'),
    ]),
    new Categorie('Trödel'),
    new Categorie('Verloren & Gefunden'),
    new Categorie('Weitere Freizeit, Hoby & Nachbarschaft'),
  ]),
  new Categorie('Haus & Garten', <Categorie>[
    new Categorie('Badezimmer'),
    new Categorie('Büro'),
    new Categorie('Dekoration'),
    new Categorie('Dienstleistungen Haus & Garten', <Categorie>[
      new Categorie('Bau & Handwerk'),
      new Categorie('Garten- & Landschaftsbau'),
      new Categorie('Haushaltshilfe'),
      new Categorie('Reinigungsservice'),
      new Categorie('Reparaturen'),
      new Categorie('Weitere Dienstleistungen Haus & Garten'),
    ]),
    new Categorie('Gartenzubehör & Pflanzen', <Categorie>[
      new Categorie('Blumentöpfe'),
      new Categorie('Dekoration'),
      new Categorie('Gartengeräte'),
      new Categorie('Gartenmöbel'),
      new Categorie('Pflanzen'),
      new Categorie('Weitere Gartenzubehör & Pflanzen'),
    ]),
    new Categorie('Heimtextilien'),
    new Categorie('Heimwerken'),
    new Categorie('Küche & Zimmer', <Categorie>[
      new Categorie('Besteck'),
      new Categorie('Geschirr'),
      new Categorie('Gläser'),
      new Categorie('Kleingeräte'),
      new Categorie('Küchenschränke'),
      new Categorie('Stühle'),
      new Categorie('Tisch'),
      new Categorie('Weiteres Küche & Zimmer'),
    ]),
    new Categorie('Lampen & Licht'),
    new Categorie('Schlafzimmer', <Categorie>[
      new Categorie('Betten'),
      new Categorie('Lattenroste'),
      new Categorie('Matratzen'),
      new Categorie('Nachttische'),
      new Categorie('Küchenschränke'),
      new Categorie('Schränke'),
      new Categorie('Weiteres Schlafzimmer'),
    ]),
    new Categorie('Wohnzimmer', <Categorie>[
      new Categorie('Regale'),
      new Categorie('Schränke & Schrankwände'),
      new Categorie('Sitzmöbel'),
      new Categorie('Sofas & Sitzgarnituren'),
      new Categorie('Tische'),
      new Categorie('TV & Phonomöbel'),
      new Categorie('Weiteres Wohnzimmer'),
    ]),
    new Categorie('Weitere Haus & Garten'),
  ]),
  new Categorie('Haustiere', <Categorie>[
    new Categorie('Fische'),
    new Categorie('Hunde'),
    new Categorie('Katzen'),
    new Categorie('Kleintiere'),
    new Categorie('Pferde'),
    new Categorie('Reptilien'),
    new Categorie('Tierbetreuung & Training'),
    new Categorie('Vermisste Tiere'),
    new Categorie('Vögel'),
    new Categorie('Zubehör'),
    new Categorie('Weiteres Haustiere'),
  ]),
  new Categorie('Immobilien', <Categorie>[
    new Categorie('Auf Zeit & WG', <Categorie>[
      new Categorie('befristet'),
      new Categorie('unbefristet'),
    ]),
    new Categorie('Eigentumswohnungen'),
    new Categorie('Ferien- & Auslandsimmobilien', <Categorie>[
      new Categorie('Kaufen'),
      new Categorie('Mieten'),
    ]),
    new Categorie('Garagen & Stellplätze', <Categorie>[
      new Categorie('Kaufen'),
      new Categorie('Mieten'),
    ]),
    new Categorie('Gewerbeimmobilien', <Categorie>[
      new Categorie('Kaufen'),
      new Categorie('Mieten'),
    ]),
    new Categorie('Grundstücke & Gärten', <Categorie>[
      new Categorie('Baugrunstück', <Categorie>[
        new Categorie('Kaufen'),
        new Categorie('Mieten'),
      ]),
      new Categorie('Garten', <Categorie>[
        new Categorie('Kaufen'),
        new Categorie('Mieten'),
      ]),
      new Categorie('Land-/Forstwirtschaft', <Categorie>[
        new Categorie('Kaufen'),
        new Categorie('Mieten'),
      ]),
      new Categorie('Weitere Grundstücke & Gärten', <Categorie>[
        new Categorie('Kaufen'),
        new Categorie('Mieten'),
      ]),
    ]),
    new Categorie('Häuser zum Kauf'),
    new Categorie('Häuser zr Miete'),
    new Categorie('Mietwohnungen'),
    new Categorie('Umzug & Transport'),
    new Categorie('Weiteres Immobilien'),
  ]),
  new Categorie('Jobs', <Categorie>[
    new Categorie('Ausbildung'),
    new Categorie('Bau, Handwerk & Produktion', <Categorie>[
      new Categorie('Bauhelfer'),
      new Categorie('Dachdecker'),
      new Categorie('Elektriker'),
      new Categorie('Fliesenleger'),
      new Categorie('Maler'),
      new Categorie('Maurer'),
      new Categorie('Produktionshelfer'),
      new Categorie('Schlosser'),
      new Categorie('Tischler'),
      new Categorie('Weitere Berufe'),
    ]),
    new Categorie('Büroarbeit & Verwaltung', <Categorie>[
      new Categorie('Buchhalter'),
      new Categorie('Bürokauffrau/-mann'),
      new Categorie('Sachbearbeiter/in'),
      new Categorie('Sekretärin'),
      new Categorie('Weitere Berufe'),
    ]),
    new Categorie('Gastronomie & Tourismus', <Categorie>[
      new Categorie('Barkeeper'),
      new Categorie('Hotelfachfrau/mann'),
      new Categorie('Kellner/-in'),
      new Categorie('Koch/Köchin'),
      new Categorie('Küchenhilfe'),
      new Categorie('Servicekraft'),
      new Categorie('Zimmermädchen'),
      new Categorie('Weitere Berufe'),
    ]),
    new Categorie('Kundenservice & Call Center'),
    new Categorie('Mini- & Nebenjobs'),
    new Categorie('Praktika'),
    new Categorie('Sozialer Sektor & Pflege', <Categorie>[
      new Categorie('Altenpfleger/-in'),
      new Categorie('Arzthelfer/-in'),
      new Categorie('Erzieher/-in'),
      new Categorie('Krankenschwester / Krankenpfleger'),
      new Categorie('Physiotherapeut/-in'),
      new Categorie('Weitere Berufe'),
    ]),
    new Categorie('Transport, Logistik & Verkehr', <Categorie>[
      new Categorie('Kraftfahrer'),
      new Categorie('Kurierfahrer'),
      new Categorie('Lagerhelfer'),
      new Categorie('Stapelfahrer'),
      new Categorie('Weitere Berufe'),
    ]),
    new Categorie('Vertrieb, Einkauf & Verkauf', <Categorie>[
      new Categorie('Buchhalter/-in'),
      new Categorie('Immobilienmakler'),
      new Categorie('Kaufmann/frau'),
      new Categorie('Verkäufer/-in'),
      new Categorie('Weitere Berufe'),
    ]),
    new Categorie('Weitere Jobs', <Categorie>[
      new Categorie('Designer/grafiker'),
      new Categorie('Friseur/-in'),
      new Categorie('Haushaltshilfe'),
      new Categorie('Hausmeister'),
      new Categorie('Reinigungskraft'),
      new Categorie('Weitere Berufe'),
    ]),
  ]),
  new Categorie('Mode & Beauty', <Categorie>[
    new Categorie('Accessoires & Schmuck'),
    new Categorie('Beauty & Gesundheit', <Categorie>[
      new Categorie('Make-Up & Gesichtspflege'),
      new Categorie('Haarpflege'),
      new Categorie('Körperpflege'),
      new Categorie('Hand- & Nagelpflege'),
      new Categorie('Gesundheit'),
      new Categorie('Weiteres Beauty & Gesundheit'),
    ]),
    new Categorie('Damenbekleidung', <Categorie>[
      new Categorie('Hemden & Blusen', <Categorie>[
        new Categorie('XS'),
        new Categorie('S'),
        new Categorie('M'),
        new Categorie('L'),
        new Categorie('XL'),
        new Categorie('XXL'),
      ]),
      new Categorie('Hosen', <Categorie>[
        new Categorie('XS'),
        new Categorie('S'),
        new Categorie('M'),
        new Categorie('L'),
        new Categorie('XL'),
        new Categorie('XXL'),
      ]),
      new Categorie('Jacken & Mäntel', <Categorie>[
        new Categorie('XS'),
        new Categorie('S'),
        new Categorie('M'),
        new Categorie('L'),
        new Categorie('XL'),
        new Categorie('XXL'),
      ]),
      new Categorie('Pullover', <Categorie>[
        new Categorie('XS'),
        new Categorie('S'),
        new Categorie('M'),
        new Categorie('L'),
        new Categorie('XL'),
        new Categorie('XXL'),
      ]),
      new Categorie('Röcke & Kleider', <Categorie>[
        new Categorie('XS'),
        new Categorie('S'),
        new Categorie('M'),
        new Categorie('L'),
        new Categorie('XL'),
        new Categorie('XXL'),
      ]),
      new Categorie('Shirts & Tops', <Categorie>[
        new Categorie('XS'),
        new Categorie('S'),
        new Categorie('M'),
        new Categorie('L'),
        new Categorie('XL'),
        new Categorie('XXL'),
      ]),
      new Categorie('Umstandsmode', <Categorie>[
        new Categorie('XS'),
        new Categorie('S'),
        new Categorie('M'),
        new Categorie('L'),
        new Categorie('XL'),
        new Categorie('XXL'),
      ]),
      new Categorie('Weitere Damenbekleidung', <Categorie>[
        new Categorie('XS'),
        new Categorie('S'),
        new Categorie('M'),
        new Categorie('L'),
        new Categorie('XL'),
        new Categorie('XXL'),
      ]),
    ]),
    new Categorie('Damenschuhe', <Categorie>[
      new Categorie('< 36'),
      new Categorie('36'),
      new Categorie('37'),
      new Categorie('38'),
      new Categorie('39'),
      new Categorie('40'),
      new Categorie('41'),
      new Categorie('> 41'),
    ]),
    new Categorie('Herrenbekleidung', <Categorie>[
      new Categorie('Hemden', <Categorie>[
        new Categorie('S'),
        new Categorie('M'),
        new Categorie('L'),
        new Categorie('XL'),
        new Categorie('XXL'),
      ]),
      new Categorie('Hosen', <Categorie>[
        new Categorie('S'),
        new Categorie('M'),
        new Categorie('L'),
        new Categorie('XL'),
        new Categorie('XXL'),
      ]),
      new Categorie('Jacken & Mäntel', <Categorie>[
        new Categorie('S'),
        new Categorie('M'),
        new Categorie('L'),
        new Categorie('XL'),
        new Categorie('XXL'),
      ]),
      new Categorie('Pullover', <Categorie>[
        new Categorie('S'),
        new Categorie('M'),
        new Categorie('L'),
        new Categorie('XL'),
        new Categorie('XXL'),
      ]),
      new Categorie('Shirts', <Categorie>[
        new Categorie('S'),
        new Categorie('M'),
        new Categorie('L'),
        new Categorie('XL'),
        new Categorie('XXL'),
      ]),
      new Categorie('Weitere Herrenbekleidung', <Categorie>[
        new Categorie('S'),
        new Categorie('M'),
        new Categorie('L'),
        new Categorie('XL'),
        new Categorie('XXL'),
      ]),
    ]),
    new Categorie('Herrenschuhe', <Categorie>[
      new Categorie('< 40'),
      new Categorie('40'),
      new Categorie('41'),
      new Categorie('42'),
      new Categorie('43'),
      new Categorie('44'),
      new Categorie('45'),
      new Categorie('> 45'),
    ]),
    new Categorie('Weitere Mode & Beauty'),
  ]),
  new Categorie('Musik, Filme & Bücher', <Categorie>[
    new Categorie('Bücher & Zeitschriften', <Categorie>[
      new Categorie('Kinderbücher'),
      new Categorie('Krimis & Thriller'),
      new Categorie('Kunst & Kultur'),
      new Categorie('Sachbücher'),
      new Categorie('Science Fiction'),
      new Categorie('Zeitschriften'),
    ]),
    new Categorie('Büro & Schreibwaren'),
    new Categorie('Comics'),
    new Categorie('Fachbücher, Schule & Studium'),
    new Categorie('Film & DVD'),
    new Categorie('Musik & CDs'),
    new Categorie('Musikinstrumente'),
    new Categorie('Weitere Musik, Filme & Bücher'),
  ]),
  new Categorie('Unterricht & Kurse', <Categorie>[
    new Categorie('Beauty & Gesundheit'),
    new Categorie('Computerkurse'),
    new Categorie('Kochen & Backen'),
    new Categorie('Kunst & Gestaltung'),
    new Categorie('Musik & Gesang'),
    new Categorie('Nachhilfe'),
    new Categorie('Sportkurse'),
    new Categorie('Sprachkurse'),
    new Categorie('Tanzkurse'),
    new Categorie('Weiterbildung'),
    new Categorie('Weitere Unterricht & Kurse'),
  ]),
  new Categorie('Verschenken & Tauschen', <Categorie>[
    new Categorie('Tauschen'),
    new Categorie('Verleihen'),
    new Categorie('Verschenken'),
  ])
];
