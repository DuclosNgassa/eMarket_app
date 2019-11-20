import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emarket_app/model/categorie.dart';
import 'package:emarket_app/model/categorie_tile.dart';
import 'package:emarket_app/pages/categorie/categorie_page.dart';
import 'package:emarket_app/pages/post/images_detail.dart';
import 'package:emarket_app/services/categorie_service.dart';
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

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  FormValidator formValidator = new FormValidator();

  PostTyp _postTyp = PostTyp.offer;

  List<String> _feeTyps = <String>['Kdo', 'Negociable', 'Fixe'];
  String _feeTyp = 'Kdo';

  CategorieTile _categorieTile = new CategorieTile('', 0);

  int imageCount = 0;
  final int MAX_IMAGE = 4;

  File imageFile;

  List<File> newPostImages = List<File>();
  List<CachedNetworkImage> oldPostImages = new List();

  List<CachedNetworkImage> imageToRemove = new List();

  List<String> _imageUrls = List<String>();

  FocusNode _titelFocusNode;
  FocusNode _feeFocusNode;
  FocusNode _cityFocusNode;
  FocusNode _quarterFocusNode;
  FocusNode _phoneFocusNode;
  FocusNode _descriptionFocusNode;

  _PostEditFormState(this._post);

  @override
  void initState() {
    super.initState();
    _loadImages();
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

    return new Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 10,
                        top: SizeConfig.blockSizeVertical * 25),
                    constraints: BoxConstraints.expand(
                        height: SizeConfig.screenHeight / 5),
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
                  ),
                  Container(
                    constraints: BoxConstraints.expand(
                        height: SizeConfig.safeBlockVertical * 85),
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
                        children: <Widget>[
                          Text(
                            "Creation d´une annonce",
                            style: SizeConfig.styleTitleWhite,
                          ),

                          oldPostImages.length > 0
                              ? Container(
                                  alignment: Alignment.center,
                                  height: SizeConfig.blockSizeVertical * 13,
                                  child: buildOldImageGridView(),
                                )
                              : new Container(),
                          newPostImages.length > 0
                              ? new Container(
                                  alignment: Alignment.center,
                                  height: SizeConfig.blockSizeVertical * 13,
                                  child: buildNewImageGridView(),
                                )
                              : new Container(),
                          _buildButtons(),
                          Divider(),
                          _buildRadioButtons(),
                          TextFormField(
                            style: SizeConfig.styleForm,
                            textInputAction: TextInputAction.next,
                            autofocus: true,
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(
                                  _titelFocusNode, _feeFocusNode);
                            },
                            decoration: const InputDecoration(
                              hintText: 'Donnez le titre de votre post',
                              labelText: 'Titre',
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
                                    _fieldFocusChange(
                                        _feeFocusNode, _cityFocusNode);
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Donnez le prix',
                                    labelText: 'Prix (FCFA)',
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
                                  padding: const EdgeInsets.only(bottom: 7.0),
                                  child: FormField(
                                    builder: (FormFieldState state) {
                                      return InputDecorator(
                                        decoration: InputDecoration(
                                          labelText: 'Typ de prix',
                                          labelStyle: SizeConfig.styleForm,
                                          errorText: state.hasError
                                              ? state.errorText
                                              : null,
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
                                    style: SizeConfig.styleForm,
                                    textInputAction: TextInputAction.next,
                                    focusNode: _cityFocusNode,
                                    onFieldSubmitted: (term) {
                                      _fieldFocusChange(
                                          _cityFocusNode, _quarterFocusNode);
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Donnez la ville',
                                      labelText: 'Ville',
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
                                    style: SizeConfig.styleForm,
                                    textInputAction: TextInputAction.next,
                                    focusNode: _quarterFocusNode,
                                    onFieldSubmitted: (term) {
                                      _fieldFocusChange(
                                          _quarterFocusNode, _phoneFocusNode);
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Donnez le quartier',
                                      labelText: 'Quartier',
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
                            style: SizeConfig.styleForm,
                            textInputAction: TextInputAction.next,
                            focusNode: _phoneFocusNode,
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(
                                  _phoneFocusNode, _descriptionFocusNode);
                            },
                            decoration: const InputDecoration(
                              hintText: 'Donnez un numero de téléphone',
                              labelText: 'Numero de téléphone',
                            ),
                            initialValue: _post.phoneNumber,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(30),
                            ],
                            onSaved: (val) => _post.phoneNumber = val,
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
                            initialValue: _post.description,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(500),
                            ],
                            validator: (val) => formValidator.isEmptyText(val)
                                ? 'Donnez une description à votre post'
                                : null,
                            onSaved: (val) => _post.description = val,
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: RaisedButton(
                                  shape: const StadiumBorder(),
                                  color: Colors.red,
                                  child:
                                      Text('Retour', style: SizeConfig.styleButtonWhite),
                                  onPressed: _cancelChange,
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              Container(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: RaisedButton(
                                  shape: const StadiumBorder(),
                                  color: colorDeepPurple400,
                                  child: Text('Enregistrer les modifications',
                                      style: SizeConfig.styleButtonWhite),
                                  onPressed: _submitForm,
                                ),
                              ),
                            ],
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
                            return ImageDetailPage(null, oldPostImages);
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
                            child: oldPostImages[index] != null
                                ? oldPostImages[index]
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
                            imageCount--;
                            imageToRemove.add(oldPostImages.elementAt(index));
                            oldPostImages.removeAt(index);
                          });
                        }),
                  ],
                ),
              ),
            ),
        itemCount: oldPostImages.length);
  }

  Widget buildNewImageGridView() {
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
                            return ImageDetailPage(newPostImages, null);
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
                            child: newPostImages[index] != null
                                ? Image.file(newPostImages[index],
                                    fit: BoxFit.cover)
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
                            imageCount--;
                            newPostImages.removeAt(index);
                          });
                        }),
                  ],
                ),
              ),
            ),
        itemCount: newPostImages.length);
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
    if (imageCount < MAX_IMAGE) {
      imageCount++;
      imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
      if (imageFile != null) {
        newPostImages.add(imageFile);
      }
      setState(() {});
    } else {
      MyNotification.showInfoFlushbar(
          context,
          "Téléchargement d´images",
          "Vous ne pouvez que telecharger 4 photos",
          Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.red.shade300,
          ),
          Colors.red.shade300,
          3);
    }
  }

  _selectGalleryImage() async {
    if (imageCount < MAX_IMAGE) {
      imageCount++;
      imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        newPostImages.add(imageFile);
      }
      setState(() {});
    } else {
      MyNotification.showInfoFlushbar(
          context,
          "Téléchargement d´images",
          "Vous ne pouvez que telecharger 4 photos",
          Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.red.shade300,
          ),
          Colors.red.shade300,
          3);
    }
  }

  void _cancelChange() {
    Navigator.of(context).pop();
  }

  void _submitForm() async {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      MyNotification.showInfoFlushbar(
          context,
          "Erreur",
          "Le formulaire contient des érreurs! Corrigez les s´il vous plait",
          Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.red.shade300,
          ),
          Colors.red.shade300,
          3);
    } else if (_categorieTile.title.isEmpty) {
      MyNotification.showInfoFlushbar(
          context,
          "Erreur",
          "Veuillez choisir la categorie dans laquelle vous publiez votre post s´il vous pllait.",
          Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.red.shade300,
          ),
          Colors.red.shade300,
          3);
    } else {
      form.save();

      Post updatedPost = await _updatePost();
      await _uploadImageToServer();
      await _saveImages(updatedPost);
      await imageToRemove.forEach((item) => deleteByImageUrl(item.imageUrl));

      MyNotification.showInfoFlushbar(
          context,
          "Info",
          "Votre Post a été modifié. Les modifications seront controlées avant d´etre publiées.",
          Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.blue.shade300,
          ),
          Colors.blue.shade300,
          3);
    }
  }

  Future<Post> _updatePost() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print("User: " + user.email);

    setFeeTyp(_feeTyp);
    _post.categorieid = _categorieTile.id;
    _post.post_typ = _postTyp;
    Map<String, dynamic> postParams = _post.toMapUpdate(_post);
    Post updatedPost = await _postService.update(postParams);

    return updatedPost;
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
      for (var file in newPostImages) {
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
          MyNotification.showInfoFlushbar(
              context,
              "Info",
              "Image failed: ${decoded['message']}",
              Icon(
                Icons.info_outline,
                size: 28,
                color: Colors.red.shade300,
              ),
              Colors.red.shade300,
              3);
        }
      }
      Navigator.pop(context); //TODO Check this
      //END LOOP
    } catch (e) {
      Navigator.pop(context);
      MyNotification.showInfoFlushbar(
          context,
          "Info",
          "Image failed: $e",
          Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.red.shade300,
          ),
          Colors.red.shade300,
          3);
    }
  }

  Future<void> _saveImages(Post updatedPost) async {
    MyImage.PostImage newImage = new MyImage.PostImage();
    newImage.postid = updatedPost.id;
    newImage.created_at = DateTime.now();

    for (var item in _imageUrls) {
      newImage.image_url = item;
      Map<String, dynamic> imageParams = _imageService.toMap(newImage);
      await _imageService.saveImage(imageParams);
    }
  }

  Future<void> deleteByImageUrl(String url) async {
    _imageService.deleteByImageUrl(url);
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

  Future<void> _loadImages() async {
    _feeTyp = getFeeTyp(widget.post.fee_typ);
    _postTyp = widget.post.post_typ;
    oldPostImages =
        await _imageService.fetchCachedNetworkImageByPostId(widget.post.id);
    imageCount = oldPostImages.length;

    Categorie _categorie =
        await _categorieService.fetchCategorieByID(widget.post.categorieid);
    _categorieTile = new CategorieTile(_categorie.title, _categorie.id);
    setState(() {});
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
