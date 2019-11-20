import 'dart:convert';
import 'dart:io';

import 'package:emarket_app/model/categorie_tile.dart';
import 'package:emarket_app/model/status.dart';
import 'package:emarket_app/pages/categorie/categorie_page.dart';
import 'package:emarket_app/pages/post/images_detail.dart';
import 'package:emarket_app/util/notification.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../model/feetyp.dart';
import '../model/post.dart';
import '../model/post_image.dart' as MyImage;
import '../model/posttyp.dart';
import '../services/global.dart';
import '../services/image_service.dart';
import '../services/post_service.dart';
import '../validator/form_validator.dart';

class PostForm extends StatefulWidget {
  PostForm({Key key, this.scaffoldKey}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  PostFormState createState() => new PostFormState();
}

class PostFormState extends State<PostForm> {
  PostService _postService = new PostService();
  ImageService _imageService = new ImageService();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  FormValidator formValidator = new FormValidator();

  PostTyp _postTyp = PostTyp.offer;
  List<String> _feeTyps = <String>['Kdo', 'Negociable', 'Fixe'];
  String _feeTyp = 'Kdo';
  CategorieTile _categorieTile = new CategorieTile('', 0);
  Post newPost = new Post();
  File imageFile;

  List<File> images = List<File>();
  List<String> _imageUrls = List<String>();

  FocusNode _titelFocusNode;
  FocusNode _feeFocusNode;
  FocusNode _cityFocusNode;
  FocusNode _quarterFocusNode;
  FocusNode _phoneFocusNode;
  FocusNode _descriptionFocusNode;

  @override
  void initState() {
    super.initState();
    _titelFocusNode = FocusNode();
    _feeFocusNode = FocusNode();
    _cityFocusNode = FocusNode();
    _quarterFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _titelFocusNode.dispose();
    _feeFocusNode.dispose();
    _cityFocusNode.dispose();
    _quarterFocusNode.dispose();
    _phoneFocusNode.dispose();
    _descriptionFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    TextStyle textStyle = TextStyle(
        color: Colors.black, fontSize: SizeConfig.safeBlockHorizontal * 4);

    return Form(
      key: _formKey,
      autovalidate: false,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Column(
          children: <Widget>[
            Container(
              height: SizeConfig.blockSizeVertical * 25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Creation d´une annonce",
                    style: SizeConfig.styleTitleWhite,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: buildImageListView(),
                    ),
                  ),
                  _buildButtons(),
                ],
              ),
            ),
            Divider(),
            _buildRadioButtons(),
            TextFormField(
              style: SizeConfig.styleForm,
              textInputAction: TextInputAction.next,
              autofocus: true,
              onFieldSubmitted: (term) {
                _fieldFocusChange(_titelFocusNode, _feeFocusNode);
              },
              decoration: const InputDecoration(
                hintText: 'Donnez le titre de votre post',
                labelText: 'Titre',
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
                      style: SizeConfig.styleForm,
                    ),
                  ),
                  GestureDetector(
                    onTap: showCategoriePage,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(_categorieTile.title),
                        ),
                        IconButton(
                          onPressed: showCategoriePage,
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
                  child: TextFormField(
                    style: SizeConfig.styleForm,
                    textInputAction: TextInputAction.next,
                    focusNode: _feeFocusNode,
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(_feeFocusNode, _cityFocusNode);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Donnez le prix',
                      labelText: 'Prix (FCFA)',
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
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 7.0),
                    child: FormField(
                      builder: (FormFieldState state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Typ de prix',
                            labelStyle: SizeConfig.styleForm,
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
                              items: _feeTyps.map<DropdownMenuItem<String>>(
                                  (String value) {
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
                      style: SizeConfig.styleForm,
                      textInputAction: TextInputAction.next,
                      focusNode: _cityFocusNode,
                      onFieldSubmitted: (term) {
                        _fieldFocusChange(_cityFocusNode, _quarterFocusNode);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Donnez la ville',
                        labelText: 'Ville',
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
                      style: SizeConfig.styleForm,
                      textInputAction: TextInputAction.next,
                      focusNode: _quarterFocusNode,
                      onFieldSubmitted: (term) {
                        _fieldFocusChange(_quarterFocusNode, _phoneFocusNode);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Donnez le quartier',
                        labelText: 'Quartier',
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
              style: SizeConfig.styleForm,
              textInputAction: TextInputAction.next,
              focusNode: _phoneFocusNode,
              onFieldSubmitted: (term) {
                _fieldFocusChange(_phoneFocusNode, _descriptionFocusNode);
              },
              decoration: const InputDecoration(
                hintText: 'Donnez un numero de téléphone',
                labelText: 'Numero de téléphone',
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(30),
              ],
              onSaved: (val) => newPost.phoneNumber = val,
            ),
            TextFormField(
              style: SizeConfig.styleForm,
              textInputAction: TextInputAction.done,
              focusNode: _descriptionFocusNode,
              onFieldSubmitted: (value) {
                _descriptionFocusNode.unfocus();
                _submitForm();
              },
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Description de votre post',
                labelText: 'Description',
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(500),
              ],
              validator: (val) => formValidator.isEmptyText(val)
                  ? 'Donnez une description à votre post'
                  : null,
              onSaved: (val) => newPost.description = val,
            ),
            Container(
              padding: const EdgeInsets.only(top: 10.0),
              child: RaisedButton(
                shape: const StadiumBorder(),
                color: colorDeepPurple400,
                child: Text('Transmettre', style: SizeConfig.styleButtonWhite),
                onPressed: _submitForm,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future showCategoriePage() async {
    _categorieTile = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return CategoriePage();
        },
      ),
    );
    setState(() {
      print("Choosed categorie: " + _categorieTile.title);
    });
  }

  Widget buildImageListView() {
    SizeConfig().init(context);

    return new ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Center(
                child: Slidable(
                  actionPane: SlidableBehindActionPane(),
                  actionExtentRatio: 0.25,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return ImageDetailPage(images, null);
                          },
                          fullscreenDialog: true,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Container(
                          width: SizeConfig.blockSizeHorizontal * 20,
                          height: SizeConfig.blockSizeVertical * 25,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(3.0, 6.0),
                                    blurRadius: 10.0)
                              ]),
                          child: AspectRatio(
                            aspectRatio: 0.5,
                            child: images[index] != null
                                ? Image.file(images[index], fit: BoxFit.cover)
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                        color: colorRed,
                        icon: Icons.delete,
                        onTap: () {
                          setState(() {
                            images.removeAt(index);
                          });
                        }),
                  ],
                ),
              ),
            ),
        itemCount: images.length);
  }

  Widget _buildButtons() {
    return new Padding(
      padding: const EdgeInsets.all(1.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new IconButton(
            icon: Icon(
              Icons.add_a_photo,
              color: Colors.deepPurple,
            ),
            onPressed: _takePhoto,
            tooltip: 'Take photo',
          ),
          new IconButton(
            icon: Icon(
              Icons.image,
              color: Colors.deepPurple,
            ),
            onPressed: _selectGalleryImage,
            tooltip: 'Select from gallery',
          ),
        ],
      ),
    );
  }

  Widget _buildRadioButtons() {
    return Center(
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
            "J'offre",
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
          Expanded(
            child: Text(
              "Je recherche",
              style: SizeConfig.styleRadioButton,
            ),
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
          Expanded(
            child: Text(
              "Tous",
              style: SizeConfig.styleRadioButton,
            ),
          ),
        ],
      ),
    );
  }

  _takePhoto() async {
    if (images.length < 4) {
      imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

      if (imageFile != null) {
        images.add(imageFile);
      }
      setState(() {});
    } else {
      _showMessage('Vous ne pouvez que telecharger 4 photos');
    }
  }

  _selectGalleryImage() async {
    if (images.length < 4) {
      imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

      if (imageFile != null) {
        images.add(imageFile);
      }
      setState(() {});
    } else {
      _showMessage('Vous ne pouvez que telecharger 4 photos');
    }
  }

  void _submitForm() async {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      _showMessage(
          'Le formulaire contient des érreurs! Corrigez le s´il vous plait');
    } else if (_categorieTile.title.isEmpty) {
      _showMessage(
          'Veuillez choisir la categorie dans laquelle vous publiez votre post s´il vous pllait.');
    } else {
      form.save();

      Post savedPost = await _savePost();
      await _uploadImageToServer();
      await _saveImages(savedPost);

      MyNotification.showInfoFlushbar(
          context,
          "Info",
          "Votre Post a été enregistré. Il sera controlé avant d´etre publié.",
          Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.blue.shade300,
          ),
          Colors.blue.shade300,
          5);

      clearForm();
    }
  }

  Future<Post> _savePost() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print("User: " + user.email);

    setFeeTyp(_feeTyp);
    newPost.categorieid = _categorieTile.id;
    newPost.post_typ = _postTyp;
    newPost.useremail = user.email;
    newPost.rating = 5;
    newPost.status = Status.created;
    newPost.created_at = DateTime.now();
    Map<String, dynamic> postParams = newPost.toMap(newPost);
    Post savedPost = await _postService.save(postParams);

    return savedPost;
  }

  Future<void> _uploadImageToServer() async {
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

        if (response.statusCode == HttpStatus.ok) {
          _imageUrls.add('$SERVER_URL/${decoded['path']}');
        } else {
          _showMessage('Image failed: ${decoded['message']}');
        }
      }
      Navigator.pop(context); //TODO Check this
      //END LOOP
    } catch (e) {
      Navigator.pop(context);
      _showMessage('Image failed: $e');
    }
  }

  Future<void> _saveImages(Post savedPost) async {
    MyImage.PostImage newImage = new MyImage.PostImage();
    newImage.postid = savedPost.id;
    newImage.created_at = DateTime.now();

    for (var item in _imageUrls) {
      newImage.image_url = item;
      Map<String, dynamic> imageParams = _imageService.toMap(newImage);
      MyImage.PostImage savedImage = await _imageService.saveImage(imageParams);
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

  clearForm() {
    _formKey.currentState?.reset();
    images.clear();
    _imageUrls.clear();
    _categorieTile = new CategorieTile('', 0);
    setState(() {});
  }

  void _showMessage(String message, [MaterialColor color = Colors.red]) {
    widget.scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(message),
      backgroundColor: color,
    ));
  }

  _fieldFocusChange(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}

List<int> compress(List<int> bytes) {
  var image = img.decodeImage(bytes);
  var resize = img.copyResize(image, height: 480, width: 480);
  return img.encodePng(resize, level: 1);
}
