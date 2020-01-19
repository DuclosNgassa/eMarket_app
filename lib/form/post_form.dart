import 'dart:convert';
import 'dart:io';

import 'package:emarket_app/converter/utils.dart' as utils;
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/categorie_tile.dart';
import 'package:emarket_app/model/status.dart';
import 'package:emarket_app/pages/categorie/categorie_page.dart';
import 'package:emarket_app/pages/image/images_detail.dart';
import 'package:emarket_app/util/notification.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

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
  static const int MAX_IMAGE = 4;

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

    return Form(
      key: _formKey,
      autovalidate: false,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 2),
        child: Column(
          children: <Widget>[
            Container(
              height: SizeConfig.blockSizeVertical * 25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate('advert_creation'),
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
              style: SizeConfig.styleFormGrey,
              textInputAction: TextInputAction.next,
              autofocus: true,
              onFieldSubmitted: (term) {
                _fieldFocusChange(_titelFocusNode, _feeFocusNode);
              },
              decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).translate('give_title'),
                  labelText: AppLocalizations.of(context).translate('title'),
                  labelStyle: SizeConfig.styleFormBlack),
              inputFormatters: [
                LengthLimitingTextInputFormatter(30),
              ],
              validator: (val) =>
                  formValidator.isEmptyText(val) ? AppLocalizations.of(context).translate('give_title') : null,
              onSaved: (val) => newPost.title = val,
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
                      style: SizeConfig.styleFormBlack,
                    ),
                  ),
                  GestureDetector(
                    onTap: showCategoriePage,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            _categorieTile.title,
                            style: SizeConfig.styleFormGrey,
                          ),
                        ),
                        IconButton(
                          onPressed: showCategoriePage,
                          icon: Icon(Icons.arrow_forward_ios),
                          tooltip: AppLocalizations.of(context).translate('choose_category'),
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
                    style: SizeConfig.styleFormGrey,
                    textInputAction: TextInputAction.next,
                    focusNode: _feeFocusNode,
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(_feeFocusNode, _cityFocusNode);
                    },
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).translate('give_price'),
                      labelText: AppLocalizations.of(context).translate('price') + ' (' + AppLocalizations.of(context).translate('fcfa') + ')',
                      labelStyle: SizeConfig.styleFormBlack,
                    ),
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    validator: (val) => formValidator.isEmptyText(val)
                        ? AppLocalizations.of(context).translate('give_price')
                        : null,
                    onSaved: (val) => newPost.fee = int.parse(val),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.only(bottom: SizeConfig.blockSizeVertical),
                    child: FormField(
                      builder: (FormFieldState state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context).translate('price_typ'),
                            labelStyle: SizeConfig.styleFormBlack,
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
                                  child: Text(value,
                                      style: SizeConfig.styleFormGrey),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                      validator: (val) => formValidator.isEmptyText(val)
                          ? AppLocalizations.of(context).translate('choose_price_typ')
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
                      style: SizeConfig.styleFormGrey,
                      textInputAction: TextInputAction.next,
                      focusNode: _cityFocusNode,
                      onFieldSubmitted: (term) {
                        _fieldFocusChange(_cityFocusNode, _quarterFocusNode);
                      },
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).translate('give_city'),
                        labelText: AppLocalizations.of(context).translate('city'),
                        labelStyle: SizeConfig.styleFormBlack,
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(30),
                      ],
                      validator: (val) => formValidator.isEmptyText(val)
                          ? AppLocalizations.of(context).translate('give_city')
                          : null,
                      onSaved: (val) => newPost.city = val,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      style: SizeConfig.styleFormGrey,
                      textInputAction: TextInputAction.next,
                      focusNode: _quarterFocusNode,
                      onFieldSubmitted: (term) {
                        _fieldFocusChange(_quarterFocusNode, _phoneFocusNode);
                      },
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).translate('give_neighborhood'),
                        labelText: AppLocalizations.of(context).translate('neighborhood'),
                        labelStyle: SizeConfig.styleFormBlack,
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(30),
                      ],
                      validator: (val) => formValidator.isEmptyText(val)
                          ? AppLocalizations.of(context).translate('give_neighborhood')
                          : null,
                      onSaved: (val) => newPost.quarter = val,
                    ),
                  ),
                ],
              ),
            ),
            TextFormField(
              style: SizeConfig.styleFormGrey,
              textInputAction: TextInputAction.next,
              focusNode: _phoneFocusNode,
              onFieldSubmitted: (term) {
                _fieldFocusChange(_phoneFocusNode, _descriptionFocusNode);
              },
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).translate('give_phonenumber'),
                labelText: AppLocalizations.of(context).translate('phonenumber'),
                labelStyle: SizeConfig.styleFormBlack,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(30),
                WhitelistingTextInputFormatter.digitsOnly,
              ],
              onSaved: (val) => newPost.phoneNumber = val,
            ),
            TextFormField(
              style: SizeConfig.styleFormGrey,
              textInputAction: TextInputAction.done,
              focusNode: _descriptionFocusNode,
              onFieldSubmitted: (value) {
                _descriptionFocusNode.unfocus();
                _submitForm();
              },
              maxLines: 4,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).translate('advert_description'),
                labelText: AppLocalizations.of(context).translate('description'),
                labelStyle: SizeConfig.styleFormBlack,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(500),
              ],
              validator: (val) => formValidator.isEmptyText(val)
                  ? AppLocalizations.of(context).translate('give_advert_description')
                  : null,
              onSaved: (val) => newPost.description = val,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: SizeConfig.screenWidth * 0.9,
                padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                child: RaisedButton(
                  shape: const StadiumBorder(),
                  color: colorDeepPurple400,
                  child: Text(AppLocalizations.of(context).translate('save'), style: SizeConfig.styleButtonWhite),
                  onPressed: _submitForm,
                ),
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
    setState(() {});
  }

  Widget buildImageListView() {
    SizeConfig().init(context);

    return new ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical),
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
                      padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 2),
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
                                ? Image.file(
                                    images[index],
                                    fit: BoxFit.cover,
                                  )
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
            tooltip: AppLocalizations.of(context).translate('take_photo'),
          ),
          new IconButton(
            icon: Icon(
              Icons.image,
              color: Colors.deepPurple,
            ),
            onPressed: _selectGalleryImage,
            tooltip: AppLocalizations.of(context).translate('select_from_gallery'),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioButtons() {
    return Padding(
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
            AppLocalizations.of(context).translate('search'),
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
            AppLocalizations.of(context).translate('all'),
            style: SizeConfig.styleRadioButton,
          ),
        ],
      ),
    );
  }

  _takePhoto() async {
    if (images.length < MAX_IMAGE) {
      File picture = await ImagePicker.pickImage(
          source: ImageSource.camera, maxWidth: 800.0, maxHeight: 800.0);

      if (picture != null) {
        setState(() {
          images.add(picture);
          imageFile = picture;
        });
      }
    } else {
      MyNotification.showInfoFlushbar(
          context,
          AppLocalizations.of(context).translate('info'),
          AppLocalizations.of(context).translate('download_only') + ' ' + MAX_IMAGE.toString() + ' ' + AppLocalizations.of(context).translate('pictures'),
          Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.blue.shade300,
          ),
          Colors.blue.shade300,
          2);
    }
  }

  _selectGalleryImage() async {
    if (images.length < MAX_IMAGE) {
      File picture = await ImagePicker.pickImage(
          source: ImageSource.gallery, maxWidth: 800.0, maxHeight: 800.0);

      if (picture != null) {
        setState(() {
          images.add(picture);
          imageFile = picture;
        });
      }
    } else {
      MyNotification.showInfoFlushbar(
          context,
          AppLocalizations.of(context).translate('info'),
          AppLocalizations.of(context).translate('download_only') + ' ' + MAX_IMAGE.toString() + ' ' + AppLocalizations.of(context).translate('pictures'),
          Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.blue.shade300,
          ),
          Colors.blue.shade300,
          2);
    }
  }

  void _submitForm() async {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      MyNotification.showInfoFlushbar(
          context,
          AppLocalizations.of(context).translate('info'),
          AppLocalizations.of(context).translate('correct_form_errors'),
          Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.red.shade300,
          ),
          Colors.red.shade300,
          2);
    } else if (_categorieTile.title.isEmpty) {
      MyNotification.showInfoFlushbar(
          context,
          AppLocalizations.of(context).translate('info'),
          AppLocalizations.of(context).translate('choose_category_please'),
          Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.red.shade300,
          ),
          Colors.red.shade300,
          2);
    } else {
      form.save();

      Post savedPost = await _savePost();
      await _uploadImageToServer();
      await _saveImages(savedPost);

      MyNotification.showInfoFlushbar(
          context,
          AppLocalizations.of(context).translate('info'),
          AppLocalizations.of(context).translate('advert_save_success_message'),
          Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.blue.shade300,
          ),
          Colors.blue.shade300,
          2);

      clearForm();
    }
  }

  Future<Post> _savePost() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print("User: " + user.email);

    newPost.fee_typ = utils.Converter.convertStringToFeeTyp(_feeTyp);
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
      for (var file in images) {
        http.StreamedResponse response = await _imageService.uploadImage(file);
        var decoded = await response.stream.bytesToString().then(json.decode);

        if (response.statusCode == HttpStatus.ok) {
          _imageUrls.add('$SERVER_URL/${decoded['path']}');
        } else {
          MyNotification.showInfoFlushbar(
              context,
              AppLocalizations.of(context).translate('info'),
              "Image failed: ${decoded['message']}",
              Icon(
                Icons.info_outline,
                size: 28,
                color: Colors.blue.shade300,
              ),
              Colors.blue.shade300,
              2);
        }
      }
      Navigator.pop(context); //TODO Check this
    } catch (e) {
      Navigator.pop(context);
      MyNotification.showInfoFlushbar(
          context,
          AppLocalizations.of(context).translate('error'),
          "Image failed: $e",
          Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.red.shade300,
          ),
          Colors.red.shade300,
          2);
    }
  }

  Future<void> _saveImages(Post savedPost) async {
    MyImage.PostImage newImage = new MyImage.PostImage();
    newImage.postid = savedPost.id;
    newImage.created_at = DateTime.now();

    for (var item in _imageUrls) {
      newImage.image_url = item;
      Map<String, dynamic> imageParams = _imageService.toMap(newImage);
      await _imageService.saveImage(imageParams);
    }
  }

  clearForm() {
    _formKey.currentState?.reset();
    images.clear();
    _imageUrls.clear();
    _categorieTile = new CategorieTile('', 0);
    setState(() {});
  }

  _fieldFocusChange(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
