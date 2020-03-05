import 'package:emarket_app/converter/utils.dart';
import 'package:emarket_app/global/global_color.dart';
import 'package:emarket_app/global/global_styling.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/categorie_tile.dart';
import 'package:emarket_app/pages/categorie/categorie_page.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/enumeration/posttyp.dart';
import '../model/searchparameter.dart';
import '../validator/form_validator.dart';

class SearchParameterForm extends StatefulWidget {
  final String allTranslated;

  SearchParameterForm(BuildContext context, this.allTranslated);

  @override
  SearchParameterFormState createState() => new SearchParameterFormState();
}

class SearchParameterFormState extends State<SearchParameterForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _categorie = '';
  int _categorieId;
  PostTyp _postTyp = PostTyp.all;
  String _feeTyp = "";
  FormValidator formValidator = new FormValidator();
  SearchParameter searchParameter = new SearchParameter();

  @override
  void initState() {
    _feeTyp = widget.allTranslated;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    List<String> _feeTyps = <String>[
      AppLocalizations.of(context).translate('gift'),
      AppLocalizations.of(context).translate('negotiable'),
      AppLocalizations.of(context).translate('fixed'),
      AppLocalizations.of(context).translate('all')
    ];

    return Container(
      height: SizeConfig.screenHeight,
      child: Form(
        key: _formKey,
        autovalidate: false,
        child: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 2),
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
                    AppLocalizations.of(context).translate('offer'),
                    style: GlobalStyling.styleRadioButton,
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
                    AppLocalizations.of(context).translate('search'),
                    style: GlobalStyling.styleRadioButton,
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
                    AppLocalizations.of(context).translate('all'),
                    style: GlobalStyling.styleRadioButton,
                  ),
                ],
              ),
            ),
            Divider(),
            TextFormField(
              style: GlobalStyling.styleFormGrey,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).translate('title'),
                labelText: AppLocalizations.of(context).translate('title'),
                labelStyle: GlobalStyling.styleFormBlack,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(30),
              ],
              onSaved: (val) => searchParameter.title = val,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                    child: Text(
                      AppLocalizations.of(context).translate('category'),
                      style: GlobalStyling.styleFormBlack,
                    ),
                  ),
                  GestureDetector(
                    onTap: showCategoriePage,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            _categorie,
                            style: GlobalStyling.styleFormGrey,
                          ),
                        ),
                        IconButton(
                          onPressed: showCategoriePage,
                          icon: Icon(Icons.arrow_forward_ios),
                          tooltip: AppLocalizations.of(context)
                              .translate('choose_category'),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      style: GlobalStyling.styleFormGrey,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .translate('advert_city'),
                        labelText:
                            AppLocalizations.of(context).translate('city'),
                        labelStyle: GlobalStyling.styleFormBlack,
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(30),
                      ],
                      onSaved: (val) => searchParameter.city = val,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      style: GlobalStyling.styleFormGrey,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .translate('advert_neighborhood'),
                        labelText: AppLocalizations.of(context)
                            .translate('neighborhood'),
                        labelStyle: GlobalStyling.styleFormBlack,
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(30),
                      ],
                      onSaved: (val) => searchParameter.quarter = val,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Column(children: <Widget>[
                      Text(
                        AppLocalizations.of(context).translate('min_price'),
                        style: GlobalStyling.styleFormBlack,
                      ),
                    ]),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)
                                  .translate('fcfa'),
                              labelStyle: TextStyle(color: Colors.black)),
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
                          AppLocalizations.of(context).translate('max_price'),
                          style: GlobalStyling.styleFormBlack,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            hintText:
                                AppLocalizations.of(context).translate('fcfa'),
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
            FormField(
              builder: (FormFieldState state) {
                return InputDecorator(
                  decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context).translate('price_typ'),
                    labelStyle: GlobalStyling.styleFormBlack,
                    errorText: state.hasError ? state.errorText : null,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: _feeTyp,
                      isDense: true,
                      onChanged: (String newValue) {
                        setState(() {
                          _feeTyp = newValue;
                          state.didChange(newValue);
                        });
                      },
                      items: _feeTyps
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child:
                              Text(value, style: GlobalStyling.styleFormGrey),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
            Container(
              width: SizeConfig.screenWidth * 0.9,
              padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
              child: RaisedButton(
                shape: const StadiumBorder(),
                color: GlobalColor.colorDeepPurple400,
                child: Text(
                    AppLocalizations.of(context).translate('to_search_capital'),
                    style: GlobalStyling.styleButtonWhite),
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
    searchParameter.feeTyp = (_feeTyp == 'All' || _feeTyp == 'Tout')
        ? null
        : Converter.convertStringToFeeTyp(_feeTyp);

    Navigator.of(context).pop(searchParameter);
  }
}
