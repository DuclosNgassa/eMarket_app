import 'package:emarket_app/model/categorie_tile.dart';
import 'package:emarket_app/pages/categorie/categorie_page.dart';
import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/posttyp.dart';
import '../model/searchparameter.dart';
import '../validator/form_validator.dart';

class SearchParameterForm extends StatefulWidget {
  SearchParameterForm(BuildContext context);

  @override
  SearchParameterFormState createState() => new SearchParameterFormState();
}

class SearchParameterFormState extends State<SearchParameterForm> {
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

  FormValidator formValidator = new FormValidator();
  SearchParameter searchParameter = new SearchParameter();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      height: SizeConfig.screenHeight,
      child: Form(
        key: _formKey,
        autovalidate: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
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
                    style: SizeConfig.styleRadioButton,
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
                    style: SizeConfig.styleRadioButton,
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
                    "Tout",
                    style: SizeConfig.styleRadioButton,
                  ),
                ],
              ),
            ),
            Divider(),
            FormField(
              builder: (FormFieldState state) {
                return InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Ville',
                    labelStyle: SizeConfig.styleFormBlack,
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
                          child: Text(value, style: SizeConfig.styleFormGrey,),
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
                      Text(
                        "Prix",
                        style: SizeConfig.styleFormBlack,
                      ),
                    ]),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Fcfa',
                            labelStyle: TextStyle(color: Colors.black)
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          onSaved: (val) => val.isEmpty
                              ? 0
                              : searchParameter.feeMin = int.parse(val),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "jusqu´à",
                          style: SizeConfig.styleFormGrey,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Fcfa',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          onSaved: (val) => val.isEmpty
                              ? 0
                              : searchParameter.feeMax = int.parse(val),
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
                      style: SizeConfig.styleFormBlack,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      new Expanded(
                        child: Text(_categorie, style: SizeConfig.styleFormGrey),
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
            Container(
              padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
              child: RaisedButton(
                shape: const StadiumBorder(),
                color: colorDeepPurple400,
                child: Text('Rechercher',
                    style: SizeConfig.styleButtonWhite),
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
    });
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    form.save();
    searchParameter.category = _categorieId;
    searchParameter.postTyp = _postTyp;

    Navigator.of(context).pop(searchParameter);
  }
}
