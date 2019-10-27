import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emarket_app/model/categorie.dart';
import 'package:emarket_app/model/categorie_tile.dart';
import 'package:emarket_app/pages/categorie/categorie_page.dart';
import 'package:emarket_app/pages/post/images_detail.dart';
import 'package:emarket_app/services/categorie_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class PostEditForm extends StatefulWidget {
  PostEditForm(this.post, this.scaffoldKey);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final Post post;

  @override
  _PostEditFormState createState() => new _PostEditFormState(post);
}

class _PostEditFormState extends State<PostEditForm> {
  Post _post;
  PostService _postService = new PostService();
  ImageService _imageService = new ImageService();
  CategorieService _categorieService = new CategorieService();

  List<CachedNetworkImage> postImages = new List();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  FormValidator formValidator = new FormValidator();

  PostTyp _postTyp = PostTyp.offer;
  List<String> _feeTyps = <String>['Kdo', 'Negociable', 'Fixe'];
  String _feeTyp = 'Kdo';
  CategorieTile _categorieTile = new CategorieTile('', 0);
  //Post newPost = new Post();
  File imageFile;

  List<File> images = List<File>();
  List<Image> imageList = List();
  List<String> _imageUrls = List<String>();

  _PostEditFormState(this._post);

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = size.height;
    final double itemWidth = size.width;

    return new Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 10, top: 25),
                    constraints: BoxConstraints.expand(height: itemHeight / 4),
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [colorDeepPurple400, colorDeepPurple300],
                          begin: const FractionalOffset(1.0, 1.0),
                          end: const FractionalOffset(0.2, 0.2),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Container(
                      //padding: EdgeInsets.only(top: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'eMarket',
                              style: titleStyleWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 55),
                    constraints:
                        BoxConstraints.expand(height: itemHeight * 0.80),
                    child: buildEditForm(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEditForm() {
    return new Container(
      child: new SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Form(
                      key: _formKey,
                      autovalidate: false,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          //padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          children: <Widget>[
                            Container(
                              height: 125.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        buildOldImageGridView(),
                                        buildNewImageGridView(),
                                      ],
                                    ),
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
                                labelStyle: TextStyle(
                                    //fontFamily: 'Helvetica',
                                    color: Colors.black,
                                    fontSize: 15),
                              ),
                              initialValue: _post.title,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(30),
                              ],
                              validator: (val) => formValidator.isEmptyText(val)
                                  ? 'Donnez un titre'
                                  : null,
                              onSaved: (val) => _post.title = val,
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: Text(
                                      "Categorie",
                                      style: formStyle,
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
                                    decoration: const InputDecoration(
                                      hintText: 'Donnez le prix',
                                      labelText: 'Prix (FCFA)',
                                      labelStyle: TextStyle(
                                          //fontFamily: 'Helvetica',
                                          color: Colors.black,
                                          fontSize: 15),
                                    ),
                                    initialValue: _post.fee.toString(),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(30),
                                    ],
                                    validator: (val) =>
                                        formValidator.isEmptyText(val)
                                            ? 'Donnez un prix'
                                            : null,
                                    onSaved: (val) =>
                                    _post.fee = int.parse(val),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 3.0),
                                    child: FormField(
                                      builder: (FormFieldState state) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
                                            labelText: 'Typ de prix',
                                            labelStyle: formStyle,
                                            errorText: state.hasError
                                                ? state.errorText
                                                : null,
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              value: getFeeTyp(_post.fee_typ),
                                              isDense: true,
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  _feeTyp = newValue;
                                                  state.didChange(newValue);
                                                });
                                              },
                                              items: _feeTyps.map<
                                                  DropdownMenuItem<
                                                      String>>((String value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                      validator: (val) => formValidator
                                              .isEmptyText(val)
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        hintText: 'Donnez la ville',
                                        labelText: 'Ville',
                                        labelStyle: TextStyle(
                                            //fontFamily: 'Helvetica',
                                            color: Colors.black,
                                            fontSize: 15),
                                      ),
                                      initialValue: _post.city,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(30),
                                      ],
                                      validator: (val) =>
                                          formValidator.isEmptyText(val)
                                              ? 'Donnez la ville'
                                              : null,
                                      onSaved: (val) => _post.city = val,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        hintText: 'Donnez le quartier',
                                        labelText: 'Quartier',
                                        labelStyle: TextStyle(
                                            //fontFamily: 'Helvetica',
                                            color: Colors.black,
                                            fontSize: 15),
                                      ),
                                      initialValue: _post.quarter,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(30),
                                      ],
                                      validator: (val) =>
                                          formValidator.isEmptyText(val)
                                              ? 'Donnez le quartier'
                                              : null,
                                      onSaved: (val) => _post.quarter = val,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Donnez un numero de téléphone',
                                labelText: 'Numero de téléphone',
                                labelStyle: TextStyle(
                                    //fontFamily: 'Helvetica',
                                    color: Colors.black,
                                    fontSize: 15),
                              ),
                              initialValue: _post.phoneNumber,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(30),
                              ],
                              onSaved: (val) => _post.phoneNumber = val,
                            ),
                            TextFormField(
                              maxLines: 2,
                              decoration: const InputDecoration(
                                hintText: 'Description de votre post',
                                labelText: 'Description',
                                labelStyle: TextStyle(
                                    //fontFamily: 'Helvetica',
                                    color: Colors.black,
                                    fontSize: 15),
                              ),
                              initialValue: _post.description,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(500),
                              ],
                              validator: (val) => formValidator.isEmptyText(val)
                                  ? 'Donnez une description à votre post'
                                  : null,
                              onSaved: (val) => _post.description = val,
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: RaisedButton(
                                shape: const StadiumBorder(),
                                color: colorDeepPurple400,
                                child: Text('Enregistrer les modifications',
                                    style: styleButtonWhite),
                                onPressed: _submitForm,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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

  Widget buildOldImageGridView() {
    return GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 1,
      scrollDirection: Axis.horizontal,
      children: List.generate(
        postImages.length,
        (index) {
          CachedNetworkImage asset = postImages[index];
          return Dismissible(
            direction: DismissDirection.endToStart,
            key: Key('default'),
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
                      child: asset != null ? asset : null,
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

  Widget buildNewImageGridView() {
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
            key: Key('default'),
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
                      child: asset != null
                          ? Image.file(asset, fit: BoxFit.cover)
                          : null,
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
    return Row(
      //mainAxisSize: MainAxisSize.min,
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
          style: radioButtonStyle,
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
            style: radioButtonStyle,
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
            style: radioButtonStyle,
          ),
        ),
      ],
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
    } else if (images.isEmpty) {
      return _showMessage('Veuillez choisir une image s´il vous plait.');
    } else {
      form.save();

      Post updatedPost = await _updatePost();
//      await _uploadImageToServer();
//      await _saveImages(updatedPost);

      _showInfoFlushbar(context,
          'Votre Post a été modifié. Il sera controlé avant d´etre publié.');

      clearForm();
    }
  }

  Future<Post> _updatePost() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print("User: " + user.email);

    setFeeTyp(_feeTyp);
    _post.categorieid = _categorieTile.id;
    _post.post_typ = _postTyp;
    Map<String, dynamic> postParams = _post.toMapUpdate(_post);
    Post savedPost = await _postService.update(postParams);

    return savedPost;
  }

  Future _uploadImageToServer() async {
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

  Future _saveImages(Post savedPost) async {
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
            _post.fee_typ = FeeTyp.gift;
          }
          break;
        case 'Negociable':
          {
            _post.fee_typ = FeeTyp.negotiable;
          }
          break;
        case 'Fixe':
          {
            _post.fee_typ = FeeTyp.fixed;
          }
          break;
      }
    });
  }

  String getFeeTyp(FeeTyp feeTyp) {
    switch (feeTyp) {
      case FeeTyp.gift:
        {
          return 'Kdo';
        }
        break;
      case FeeTyp.negotiable:
        {
          return 'Negociable';
        }
        break;
      case FeeTyp.fixed:
        {
          return 'Fixe';
        }
        break;
    }
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

  void _showInfoFlushbar(BuildContext context, String message) {
    Flushbar(
      title: 'Info',
      message: message,
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: Colors.blue.shade300,
      ),
      leftBarIndicatorColor: Colors.blue.shade300,
      duration: Duration(seconds: 5),
    )..show(context);
  }

  Future<void> _loadImages() async {
    _postTyp = widget.post.post_typ;
    postImages = await _postService.fetchImages(widget.post.id);
    Categorie _categorie =
        await _categorieService.fetchCategorieByID(widget.post.categorieid);
    _categorieTile = new CategorieTile(_categorie.title, _categorie.id);
    setState(() {});
  }
}

List<int> compress(List<int> bytes) {
  var image = img.decodeImage(bytes);
  var resize = img.copyResize(image, height: 480, width: 480);
  return img.encodePng(resize, level: 1);
}
