import 'dart:convert';
import 'dart:io';

import 'package:emarket_app/pages/categorie/categorie_page.dart';
import 'package:emarket_app/pages/post/images_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../model/feetyp.dart';
import '../model/image.dart' as MyImage;
import '../model/post.dart';
import '../model/posttyp.dart';
import '../services/global.dart';
import '../services/image_service.dart';
import '../services/post_service.dart';
import '../validator/form_validator.dart';

class PostForm extends StatefulWidget {
  PostForm({Key key, this.scaffoldKey}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  PostFormState createState() => new PostFormState(Colors.lightBlueAccent);
}

class PostFormState extends State<PostForm> {
  PostService _postService = new PostService();
  ImageService _imageService = new ImageService();

  final Color color;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  FormValidator formValidator = new FormValidator();

  PostTyp _postTyp = PostTyp.offer;
  List<String> _feeTyps = <String>['Kdo', 'Negociable', 'Fixe'];
  String _feeTyp = 'Kdo';
  String _categorie = '';
  Post newPost = new Post();
  File imageFile;

  List<File> images = List<File>();
  List<String> _imageUrls = List<String>();

  PostFormState(this.color);

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
              height: 125.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: buildImageGridView(),
                  ),
                  _buildButtons(),
                ],
              ),
            ),
            Divider(),
            _buildRadioButtons(),
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
                  GestureDetector(
                    onTap: showCategoriePage,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(_categorie),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          tooltip: 'Choisir la catégorie',
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Donnez le prix',
                      labelText: 'Prix (FCFA)',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(30),
                    ],
                    validator: (val) => formValidator.isEmptyText(val)
                        ? 'Donnez un prix'
                        : null,
                    onSaved: (val) => newPost.fee = int.parse(val),
                  ),
                ),
                Expanded(
                  child: FormField(
                    builder: (FormFieldState state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Typ de prix',
                          labelStyle: TextStyle(color: Colors.white),
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
                ),
              ],
            ),
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Donnez la ville',
                        labelText: 'Ville',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(30),
                      ],
                      validator: (val) => formValidator.isEmptyText(val)
                          ? 'Donnez la ville'
                          : null,
                      onSaved: (val) => newPost.city = val,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Donnez le quartier',
                        labelText: 'Quartier',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(30),
                      ],
                      validator: (val) => formValidator.isEmptyText(val)
                          ? 'Donnez le quartier'
                          : null,
                      onSaved: (val) => newPost.quarter = val,
                    ),
                  ),
                ],
              ),
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
              validator: (val) => formValidator.isEmptyText(val)
                  ? 'Donnez une description à votre post'
                  : null,
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

  Widget buildImageGridView() {
    return GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 1,
      scrollDirection: Axis.horizontal,
      children: List.generate(
        images.length,
        (index) {
          File asset = images[index];
          return Dismissible(
            direction: DismissDirection.endToStart,
            key: Key(images[index].path),
            background: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: AspectRatio(
                aspectRatio: 0.3,
                child: Container(
                  color: Colors.red,
                  alignment: AlignmentDirectional.centerEnd,
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            onDismissed: (direction) => {
              setState(() {
                images.removeAt(index);
              })
            },
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<Null>(
                    builder: (BuildContext context) {
                      return ImageDetailPage(images);
                    },
                    fullscreenDialog: true,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(3.0, 6.0),
                          blurRadius: 10.0)
                    ]),
                    child: AspectRatio(
                      aspectRatio: 0.5,
                      child: Image.file(asset, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildButtons() {
    return new Padding(
      padding: const EdgeInsets.all(1.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new IconButton(
            icon: Icon(Icons.camera),
            onPressed: _takePhoto,
            tooltip: 'Take photo',
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

  Widget _buildRadioButtons() {
    return new Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          "Tous",
          style: new TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  _takePhoto() async {
    if (images.length < 4) {
      imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
      images.add(imageFile);
      setState(() {});
    } else {
      _showSnackbar('Vous ne pouvez que telecharger 4 photos');
    }
  }

  _selectGalleryImage() async {
    if (images.length < 4) {
      imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
      images.add(imageFile);
      setState(() {});
    } else {
      _showSnackbar('Vous ne pouvez que telecharger 4 photos');
    }
  }

  _showSnackbar(String text) => scaffoldKey.currentState?.showSnackBar(
        new SnackBar(
          content: new Text(text),
        ),
      );

  void _submitForm() async {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Form is not valide! Please review and correct.');
    } else if (_categorie.isEmpty) {
      showMessage(
          'Veuillez choisir la categorie dans laquelle vous publiez votre post s´il vous pllait.');
    } else {
      form.save();

      Post savedPost = await _savePost();
      await _uploadImage();

      for (var item in _imageUrls) {
        MyImage.Image newImage = new MyImage.Image();
        newImage.postid = savedPost.id;
        newImage.created_at = DateTime.now();
        newImage.image_url = item;
        Map<String, dynamic> imageParams = _imageService.toMap(newImage);
        MyImage.Image savedImage =
            await _imageService.saveImage(http.Client(), imageParams);
      }

      //Save ImageUrl and PostId in the DB
      print('Form save called, newContact is now up to date...');
      print('Titre: ${newPost.post_typ}');
      print('Typ: ${newPost.title}');
      print('Categorie: ${newPost.categorieid}');
      print('Prix: ${newPost.fee}');
      print('Typ de prix: ${newPost.fee_typ}');
      print('Description: ${newPost.description}');
      print('========================================');
      print('Submitting to back end...');
      print('TODO - we will write the submission part next...');

      Navigator.of(context).pop(newPost);
    }
  }

  Future<Post> _savePost() async{
    setFeeTyp(_feeTyp);
    newPost.categorieid = 1;
    newPost.post_typ = _postTyp;
    newPost.userid = 2;
    newPost.rating = 6;
    newPost.created_at = DateTime.now();
    Map<String, dynamic> postParams = newPost.toMap(newPost);
    Post savedPost = await _postService.savePost(postParams);

    return savedPost;
  }

  _uploadImage() async {

    if (images.isEmpty) {
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
      final url = Uri.parse(URL_IMAGES_UPLOAD);
      //BEGIN LOOP
      for (var file in images) {
        var fileName = path.basename(file.path);
        var bytes = await compute(compress, file.readAsBytesSync());

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

        if (response.statusCode == HttpStatus.OK) {
          _imageUrls.add('$SERVER_URL/${decoded['path']}');

          _showSnackbar(
              'Image uploaded, imageUrl = $SERVER_URL/${decoded['path']}');
        } else {
          _showSnackbar('Image failed: ${decoded['message']}');
        }
      }
      Navigator.pop(context); //TODO Check this
      //END LOOP
    } catch (e) {
      Navigator.pop(context);
      _showSnackbar('Image failed: $e');
    }
  }

  void setFeeTyp(String newValue) {
    setState(() {
      switch (newValue) {
        case 'Kdo':
          {
            newPost.fee_typ = FeeTyp.gift;
          }
          break;
        case 'Negociable':
          {
            newPost.fee_typ = FeeTyp.negotiable;
          }
          break;
        case 'Fixe':
          {
            newPost.fee_typ = FeeTyp.fixed;
          }
          break;
      }

    });
  }
}

List<int> compress(List<int> bytes) {
  var image = img.decodeImage(bytes);
  var resize = img.copyResize(image, height: 480, width: 480);
  return img.encodePng(resize, level: 1);
}
