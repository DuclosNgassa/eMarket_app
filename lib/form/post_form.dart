import 'dart:convert';
import 'dart:io';

import 'package:emarket_app/pages/categorie/categorie_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

import '../converter/date_converter.dart';
import '../model/feetyp.dart';
import '../model/post.dart';
import '../model/posttyp.dart';
import '../validator/form_validator.dart';

class PostForm extends StatefulWidget {
  PostForm({Key key, this.scaffoldKey}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  CustomFormState createState() => new CustomFormState(Colors.lightBlueAccent);
}

class CustomFormState extends State<PostForm> {
  final Color color;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  PostTyp _postTyp = PostTyp.offer;
  String _categorie = '';
  List<String> _priceTyps = <String>['Kdo', 'Negociable', 'Fixe'];
  String _priceTyp = 'Kdo';
  FormValidator formValidator = new FormValidator();
  Post newPost;
  File imageFile;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  static const baseUrl = 'http://192.168.2.120:3000/images';

  CustomFormState(this.color);
  
  void showMessage(String message, [MaterialColor color = Colors.red]) {
    widget.scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(message),
      backgroundColor: color,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.0,
      alignment: Alignment.center,
      child: Form(
        key: _formKey,
        autovalidate: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            Container(
              height: 150.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildPreviewImage(),
                  _buildButtons(),
                ],
              ),
            ),

            Divider(),
            Row(
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
                  "J'offre",
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
                  "Je recherche",
                  style: new TextStyle(color: Colors.white),
                ),
              ],
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Donnez le titre de votre post',
                labelText: 'Titre',
                labelStyle: TextStyle(color: Colors.white),
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(30),
              ],
              validator: (val) =>
                  formValidator.isEmptyText(val) ? 'Donnez un titre' : null,
              onSaved: (val) => newPost.title = val,
            ),
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
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Donnez le prix',
                labelText: 'Prix (FCFA)',
                labelStyle: TextStyle(color: Colors.white),
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(30),
              ],
              validator: (val) =>
                  formValidator.isEmptyText(val) ? 'Donnez un prix' : null,
              onSaved: (val) => newPost.fee = int.parse(val),
            ),
            FormField(
              builder: (FormFieldState state) {
                return InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Typ de prix',
                    labelStyle: TextStyle(color: Colors.white),
                    errorText: state.hasError ? state.errorText : null,
                  ),
                  isEmpty: _priceTyp == '',
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: _priceTyp,
                      isDense: true,
                      onChanged: (String newValue) {
                        setState(() {
                          setFeeTyp(newValue);
                          state.didChange(newValue);
                        });
                      },
                      items: _priceTyps.map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
              validator: (val) => formValidator.isEmptyText(val)
                  ? 'Veuillez choisir le type de prix svp'
                  : null,
            ),
            TextFormField(
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Description de votre post',
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.white),
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(500),
              ],
              validator: (val) =>
                  formValidator.isEmptyText(val) ? 'Enter a name' : null,
              onSaved: (val) => newPost.description = val,
            ),
            new Container(
              padding: const EdgeInsets.only(top: 10.0),
              child: RaisedButton(
                color: Colors.deepPurple,
                child: Text('Submit', style: TextStyle(color: Colors.white)),
                onPressed: _submitForm,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setFeeTyp(String newValue) {
    switch(newValue){
      case 'Kdo':{
        newPost.feeTyp = FeeTyp.gift;
      }
      break;
      case 'Negociable':{
        newPost.feeTyp = FeeTyp.negotiable;
      }
      break;
      case 'Fixe':{
        newPost.feeTyp = FeeTyp.fixed;
      }
      break;
    }
    _priceTyp = newValue;
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
      print("Choosed categorie: " + categorieChoosed);
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

  Widget _buildPreviewImage() {
    return new Expanded(
      child: new Card(
        elevation: 3.0,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(
            new Radius.circular(4.0),
          ),
        ),
        child: new Stack(
          children: <Widget>[
            new Container(
              constraints: new BoxConstraints.expand(),
              child: imageFile == null
                  ? new Image.asset('images/profil.JPG', colorBlendMode: BlendMode.darken, color: Colors.black26, fit: BoxFit.cover)
                  : new Image.file(imageFile, fit: BoxFit.cover),
            ),
            new Align(
              alignment: AlignmentDirectional.center,
              child: imageFile == null
                  ? new Text(
                'No selected image',
                style: Theme.of(context).textTheme.title,
              )
                  : new Container(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new IconButton(
            icon: Icon(Icons.camera),
            onPressed: _takePhoto,
            tooltip: 'Take photo',
          ),
          new IconButton(
            icon: Icon(Icons.file_upload),
            onPressed: _uploadImage,
            tooltip: 'Upload image',
          ),
          new IconButton(
            icon: Icon(Icons.image),
            onPressed: _selectGalleryImage,
            tooltip: 'Select from gallery',
          ),
        ],
      ),
    );
  }

  _takePhoto() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  _showSnackbar(String text) => scaffoldKey.currentState?.showSnackBar(
    new SnackBar(
      content: new Text(text),
    ),
  );

  _uploadImage() async {
    if (imageFile == null) {
      return _showSnackbar('Please select image');
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new Center(
          child: new CircularProgressIndicator(),
        );
      },
      barrierDismissible: false,
    );

    try {
      final url = Uri.parse('$baseUrl/upload');
      final fileName = path.basename(imageFile.path);
      final bytes = await compute(compress, imageFile.readAsBytesSync());

      var request = http.MultipartRequest('POST', url)
        ..files.add(
          new http.MultipartFile.fromBytes(
            'image',
            bytes,
            filename: fileName,
          ),
        );

      var response = await request.send();
      var decoded = await response.stream.bytesToString().then(json.decode);

      Navigator.pop(context);
      if (response.statusCode == HttpStatus.OK) {
        _showSnackbar('Image uploaded, imageUrl = $baseUrl/${decoded['path']}');
      } else {
        _showSnackbar('Image failed: ${decoded['message']}');
      }
    } catch (e) {
      Navigator.pop(context);
      _showSnackbar('Image failed: $e');
    }
  }

  List<int> compress(List<int> bytes) {
    var image = img.decodeImage(bytes);
    var resize = img.copyResize(image, height: 480, width: 480);
    return img.encodePng(resize, level: 1);
  }
  _selectGalleryImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Form is not valide! Please review and correct.');
    } else if (_categorie.isEmpty) {
      showMessage(
          'Veuiillez choisir la categorie dans laquelle vous publiez votre post s´il vous pllait.');
    } else {
      form.save();

      newPost.category = _categorie;
      newPost.typ = _postTyp;



      print('Form save called, newContact is now up to date...');
      print('Titre: ${newPost.typ}');
      print('Typ: ${newPost.title}');
      print('Categorie: ${newPost.category}');
      print('Prix: ${newPost.fee}');
      print('Typ de prix: ${newPost.feeTyp}');
      print('Description: ${newPost.description}');
      print('========================================');
      print('Submitting to back end...');
      print('TODO - we will write the submission part next...');

      Navigator.of(context).pop(newPost);
    }
  }
}
