import 'package:flutter/material.dart';
import '../component/custom_button.dart';
import '../pages/categorie_page.dart';
import 'searchparameter.dart';
import '../model/searchparameter.dart';

class Search extends StatefulWidget {
  final String pageTitle;

  Search(this.pageTitle);

  @override
  SearchState createState() => new SearchState(Colors.lightBlueAccent);
}

class SearchState extends State<Search> {
  final Color color;
  String _categorie = '';
  SearchParameter _searchParameter;

  SearchState(this.color);

  @override
  Widget build(BuildContext context) {
    var divheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            //title: Text('Test'),
            backgroundColor: Colors.deepPurple[400],
            expandedHeight: divheight / 2 * 0.5,
            floating: true,
            snap: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              //title: Text("Search Page"),
              background: Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 15.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                hintText: 'Entrer votre recherche',
                                labelText: 'Recherche',
                                labelStyle: TextStyle(color: Colors.white),
                              ),
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
                              print('Recherche en cours...');
                              //_chooseDate(context, _controller.text);
                            }),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Wrap(
                        direction: Axis.horizontal,
                        spacing: 4,
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          CustomButton(
                            fillColor: Colors.deepPurple,
                            icon: Icons.build,
                            splashColor: Colors.white,
                            iconColor: Colors.white,
                            text: 'Filtre',
                            textStyle: TextStyle(color: Colors.white),
                            onPressed: () => showSearchParameterPage(context),
                          ),
                          CustomButton(
                            fillColor: Colors.deepPurple,
                            icon: Icons.apps,
                            splashColor: Colors.white,
                            iconColor: Colors.white,
                            text: 'Categorie',
                            textStyle: TextStyle(color: Colors.white),
                            onPressed: showCategoriePage,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CustomButton(
                              fillColor: Colors.deepPurple,
                              icon: Icons.location_on,
                              splashColor: Colors.white,
                              iconColor: Colors.white,
                              text: 'Yaounde',
                              textStyle: TextStyle(color: Colors.white),
                              onPressed: () => showSearchParameterPage(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 20.0,
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: Text("List item $index"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future showCategoriePage() async {
    String categorieChoosed = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return CategoriePage();
        },
      ),
    );
    setState(() {
      _categorie = categorieChoosed;
      print("Categorie choisie: " + categorieChoosed);
    });
  }

  Future showSearchParameterPage(BuildContext context) async {
   // SearchParameter transmitedSearchParameter = await Navigator.push(context,
    SearchParameter transmitedSearchParameter = new SearchParameter();
    transmitedSearchParameter = await Navigator.push(context,
      MaterialPageRoute(
        builder: (context) =>
           SearchParameterPage(pageTitle: "Search",),
      ),
    );
    if(transmitedSearchParameter.city != null) {
      print('Ville: ${transmitedSearchParameter.city}');
    }

    setState(() {
      _searchParameter = transmitedSearchParameter;
      print("Searchparameter Categorie: " + _searchParameter.category);
    });
  }
}
