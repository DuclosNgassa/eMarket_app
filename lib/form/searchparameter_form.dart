import 'package:emarket_app/model/categorie_tile.dart';
import 'package:emarket_app/pages/categorie/categorie_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/posttyp.dart';
import '../model/searchparameter.dart';
import '../validator/form_validator.dart';

class SearchParameterForm extends StatefulWidget {
  SearchParameterForm(BuildContext context);

  // SearchParameterForm({Key key}) : super(key: key);
  // final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  SearchParameterFormState createState() =>
      new SearchParameterFormState(Colors.lightBlueAccent);
}

class SearchParameterFormState extends State<SearchParameterForm> {
  final Color color;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _categorie = '';
  int _categorieId;
  PostTyp _postTyp = PostTyp.offer;

  List<String> _cities = <String>[
    'Yaounde',
    'Douala',
    'Bangangte',
    'Mbouda',
    'Ngaoundal'
  ]; // TODO please replace me with a list of cities comin from backend
  String _city = 'Yaounde';

  SearchParameterFormState(this.color);

  // DateConverter dateConverter = new DateConverter();
  FormValidator formValidator = new FormValidator();

  //Contact newContact = new Contact();
  SearchParameter searchParameter = new SearchParameter();

/*

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    context.widget.showSnackBar(new SnackBar(
      content: Text(message),
      backgroundColor: color,
    ));
  }
*/

  @override
  Widget build(BuildContext context) {
    var divheight = MediaQuery.of(context).size.height;
    return Container(
      height: divheight,
      child: Form(
        key: _formKey,
        autovalidate: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            Divider(),
            FormField(
              builder: (FormFieldState state) {
                return InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Ville',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: _city,
                      isDense: true,
                      onChanged: (String newValue) {
                        setState(() {
                          searchParameter.city = newValue;
                          _city = newValue;
                          state.didChange(newValue);
                        });
                      },
                      items: _cities.map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Column(children: <Widget>[
                      Text("Prix", style: TextStyle(color: Colors.white),),
                    ]),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Fcfa',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          onSaved: (val) => val.isEmpty ? 0 : searchParameter.feeMin = int.parse(val),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text("jusqu´à", style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Fcfa',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          onSaved: (val) => val.isEmpty ? 0 : searchParameter.feeMax = int.parse(val),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      "Categorie",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      new Expanded(
                        child: Text(_categorie),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        tooltip: 'Choisir la catégorie',
                        onPressed: showCategoriePage,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(right:20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Radio(
                    value: PostTyp.offer,
                    groupValue: _postTyp,
                    onChanged: (PostTyp value) {
                      setState(() {
                        _postTyp = value;
                      });
                    },
                  ),
                  Text(
                    "Offre",
                    style: new TextStyle(color: Colors.white),
                  ),
                  Radio(
                    value: PostTyp.search,
                    groupValue: _postTyp,
                    onChanged: (PostTyp value) {
                      setState(() {
                        _postTyp = value;
                      });
                    },
                  ),
                  Text(
                    "Recherche",
                    style: new TextStyle(color: Colors.white),
                  ),
                  Radio(
                    value: PostTyp.all,
                    groupValue: _postTyp,
                    onChanged: (PostTyp value) {
                      setState(() {
                        _postTyp = value;
                      });
                    },
                  ),
                  Text(
                    "Mix",
                    style: new TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            new Container(
              padding: const EdgeInsets.only(top: 10.0),
              child: RaisedButton(
                color: Colors.deepPurple,
                child: Text('Afficher le resultat', style: TextStyle(color: Colors.white)),
                onPressed: _submitForm,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future showCategoriePage() async {
    CategorieTile categorieChoosed = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return CategoriePage();
        },
      ),
    );
    setState(() {
      _categorie = categorieChoosed.title;
      _categorieId = categorieChoosed.id;
      print("Choosed categorie: " + categorieChoosed.title);
    });
  }

/*
  void submitPup(context) {
    if (nameController.text.isEmpty) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Pups neeed names!'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } else {
      var newDog = Dog(nameController.text, locationController.text,
          descriptionController.text);
      Navigator.of(context).pop(newDog);
    }
  }
*/

  void _submitForm() {
    final FormState form = _formKey.currentState;

      form.save();
      searchParameter.category = _categorieId;
      searchParameter.postTyp = _postTyp;

      print('Form save called, newContact is now up to date...');
      if(searchParameter.city != null) {
        print('Ville: ${searchParameter.city}');
      }
      print('Categorie: ${searchParameter.category}');
      print('PrixMin: ${searchParameter.feeMin.toString()}');
      print('PrixMax: ${searchParameter.feeMax.toString()}');
      print('Typ: ${searchParameter.postTyp}');
      print('========================================');
      print('Submitting to back end...');
      print('TODO - we will write the submission part next...');

      Navigator.of(context).pop(searchParameter);
  }
}
