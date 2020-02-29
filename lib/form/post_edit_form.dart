import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emarket_app/converter/utils.dart' as utils;
import 'package:emarket_app/custom_component/custom_shape_clipper.dart';
import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/categorie.dart';
import 'package:emarket_app/model/categorie_tile.dart';
import 'package:emarket_app/pages/categorie/categorie_page.dart';
import 'package:emarket_app/pages/image/images_detail.dart';
import 'package:emarket_app/services/categorie_service.dart';
import 'package:emarket_app/util/notification.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../model/enumeration/feetyp.dart';
import '../model/enumeration/posttyp.dart';
import '../model/post.dart';
import '../model/post_image.dart' as MyImage;
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

  CategorieTile _categorieTile = new CategorieTile('Categorie', 0);

  int imageCount = 0;
  static const int MAX_IMAGE = 4;

  File imageFile;

  List<File> newPostImages = List<File>();
  List<MyImage.PostImage> oldPostImages = new List();

  List<MyImage.PostImage> imageToRemove = new List();

  List<String> _imageUrls = List<String>();

  bool isSaved = false;

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
                  ClipPath(
                    clipper: CustomShapeClipper(),
                    child: Container(
                      height: SizeConfig.screenHeight / 4,
                      decoration: BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [colorDeepPurple400, colorDeepPurple300],
                            begin: const FractionalOffset(1.0, 1.0),
                            end: const FractionalOffset(0.2, 0.2),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                    ),
                  ),
                  Container(
                    constraints:
                        BoxConstraints.expand(height: SizeConfig.screenHeight),
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
                      padding:
                          EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical * 5.0),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('modify_advert'),
                              style: SizeConfig.styleTitleWhite,
                            ),
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
                            style: SizeConfig.styleFormGrey,
                            textInputAction: TextInputAction.next,
                            autofocus: true,
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(_titelFocusNode, _feeFocusNode);
                            },
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)
                                  .translate('give_advert_title'),
                              labelText: AppLocalizations.of(context)
                                  .translate('title'),
                              labelStyle: SizeConfig.styleFormBlack,
                            ),
                            initialValue: _post.title,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(30),
                            ],
                            validator: (val) => formValidator.isEmptyText(val)
                                ? AppLocalizations.of(context)
                                    .translate('give_title')
                                : null,
                            onSaved: (val) => _post.title = val,
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.blockSizeVertical * 2),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('category'),
                                    style: SizeConfig.styleFormBlack,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: showCategoriePage,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(_categorieTile.title,
                                            style: SizeConfig.styleFormGrey),
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
                                    _fieldFocusChange(
                                        _feeFocusNode, _cityFocusNode);
                                  },
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)
                                        .translate('give_price'),
                                    labelText: AppLocalizations.of(context)
                                            .translate('price') +
                                        ' (' +
                                        AppLocalizations.of(context)
                                            .translate('fcfa') +
                                        ')',
                                    labelStyle: SizeConfig.styleFormBlack,
                                  ),
                                  initialValue: _post.fee.toString(),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(30),
                                    WhitelistingTextInputFormatter.digitsOnly,
                                  ],
                                  validator: (val) =>
                                      formValidator.isEmptyText(val)
                                          ? AppLocalizations.of(context)
                                              .translate('give_price')
                                          : null,
                                  onSaved: (val) => _post.fee = int.parse(val),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: SizeConfig.blockSizeVertical),
                                  child: FormField(
                                    builder: (FormFieldState state) {
                                      return InputDecorator(
                                        decoration: InputDecoration(
                                          labelText:
                                              AppLocalizations.of(context)
                                                  .translate('price_typ'),
                                          labelStyle: SizeConfig.styleFormBlack,
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
                                            items: _feeTyps
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style:
                                                      SizeConfig.styleFormGrey,
                                                ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: TextFormField(
                                    style: SizeConfig.styleFormGrey,
                                    textInputAction: TextInputAction.next,
                                    focusNode: _cityFocusNode,
                                    onFieldSubmitted: (term) {
                                      _fieldFocusChange(
                                          _cityFocusNode, _quarterFocusNode);
                                    },
                                    decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)
                                          .translate('give_city'),
                                      labelText: AppLocalizations.of(context)
                                          .translate('city'),
                                      labelStyle: SizeConfig.styleFormBlack,
                                    ),
                                    initialValue: _post.city,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(30),
                                    ],
                                    validator: (val) =>
                                        formValidator.isEmptyText(val)
                                            ? AppLocalizations.of(context)
                                                .translate('give_city')
                                            : null,
                                    onSaved: (val) => _post.city = val,
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    style: SizeConfig.styleFormGrey,
                                    textInputAction: TextInputAction.next,
                                    focusNode: _quarterFocusNode,
                                    onFieldSubmitted: (term) {
                                      _fieldFocusChange(
                                          _quarterFocusNode, _phoneFocusNode);
                                    },
                                    decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)
                                          .translate('give_neighborhood'),
                                      labelText: AppLocalizations.of(context)
                                          .translate('neighborhood'),
                                      labelStyle: SizeConfig.styleFormBlack,
                                    ),
                                    initialValue: _post.quarter,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(30),
                                    ],
                                    validator: (val) =>
                                        formValidator.isEmptyText(val)
                                            ? AppLocalizations.of(context)
                                                .translate('give_neighborhood')
                                            : null,
                                    onSaved: (val) => _post.quarter = val,
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
                              _fieldFocusChange(
                                  _phoneFocusNode, _descriptionFocusNode);
                            },
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)
                                  .translate('give_phonenumber'),
                              labelText: AppLocalizations.of(context)
                                  .translate('phonenumber'),
                              labelStyle: SizeConfig.styleFormBlack,
                            ),
                            initialValue: _post.phoneNumber,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(30),
                              WhitelistingTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.number,
                            onSaved: (val) => _post.phoneNumber = val,
                          ),
                          TextFormField(
                            style: SizeConfig.styleFormGrey,
                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.multiline,
                            focusNode: _descriptionFocusNode,
                            onFieldSubmitted: (value) {
                              _descriptionFocusNode.unfocus();
                              _submitForm();
                            },
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)
                                  .translate('advert_description'),
                              labelText: AppLocalizations.of(context)
                                  .translate('description'),
                              labelStyle: SizeConfig.styleFormBlack,
                            ),
                            initialValue: _post.description,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(500),
                            ],
                            validator: (val) => formValidator.isEmptyText(val)
                                ? AppLocalizations.of(context)
                                    .translate('give_advert_description')
                                : null,
                            onSaved: (val) => _post.description = val,
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.blockSizeVertical * 2),
                                child: RaisedButton(
                                  shape: const StadiumBorder(),
                                  color: Colors.red,
                                  child: Text(
                                      AppLocalizations.of(context)
                                          .translate('cancel'),
                                      style: SizeConfig.styleButtonWhite),
                                  onPressed: _cancelChange,
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              isSaved
                                  ? new Container()
                                  : Container(
                                      padding: EdgeInsets.only(
                                          top:
                                              SizeConfig.blockSizeVertical * 2),
                                      child: RaisedButton(
                                        shape: const StadiumBorder(),
                                        color: colorDeepPurple400,
                                        child: Text(
                                            AppLocalizations.of(context)
                                                .translate('save'),
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
    setState(() {});
  }

  Widget buildOldImageGridView() {
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
                            return ImageDetailPage(null, oldPostImages);
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
                            child: oldPostImages[index] != null
                                ? CachedNetworkImage(
                                    placeholder: (context, url) => Image.asset(
                                        "assets/gif/loading-world.gif"),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    imageUrl: oldPostImages[index].image_url,
                                    fit: BoxFit.fill,
                                  )
                                : new Container(
                                    width: 0.0,
                                    height: 0.0,
                                  ),
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
                            return ImageDetailPage(newPostImages, null);
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
            tooltip: AppLocalizations.of(context).translate('take_photo'),
          ),
          new IconButton(
            icon: Icon(
              Icons.image,
              color: Colors.deepPurple,
            ),
            onPressed: _selectGalleryImage,
            tooltip:
                AppLocalizations.of(context).translate('select_from_gallery'),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal),
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
          Expanded(
            child: Text(
              AppLocalizations.of(context).translate('search'),
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
              AppLocalizations.of(context).translate('all'),
              style: SizeConfig.styleRadioButton,
            ),
          ),
        ],
      ),
    );
  }

  _takePhoto() async {
    if (imageCount < MAX_IMAGE) {
      File picture = await ImagePicker.pickImage(
          source: ImageSource.camera, maxWidth: 800.0, maxHeight: 800.0);

      if (picture != null) {
        setState(() {
          imageCount++;
          newPostImages.add(picture);
          imageFile = picture;
        });
      }
    } else {
      MyNotification.showInfoFlushbar(
          context,
          AppLocalizations.of(context).translate('downloading_images'),
          AppLocalizations.of(context).translate('download_only') +
              ' ' +
              MAX_IMAGE.toString() +
              ' ' +
              AppLocalizations.of(context).translate('pictures'),
          Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.red.shade300,
          ),
          Colors.red.shade300,
          2);
    }
  }

  _selectGalleryImage() async {
    if (imageCount < MAX_IMAGE) {
      File picture = await ImagePicker.pickImage(
          source: ImageSource.gallery, maxWidth: 800.0, maxHeight: 800.0);

      if (picture != null) {
        setState(() {
          imageCount++;
          newPostImages.add(picture);
          imageFile = picture;
        });
      }
    } else {
      MyNotification.showInfoFlushbar(
          context,
          AppLocalizations.of(context).translate('downloading_images'),
          AppLocalizations.of(context).translate('download_only') +
              ' ' +
              MAX_IMAGE.toString() +
              ' ' +
              AppLocalizations.of(context).translate('pictures'),
          Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.red.shade300,
          ),
          Colors.red.shade300,
          2);
    }
  }

  void _cancelChange() {
    Navigator.of(context).pop();
  }

  void _submitForm() async {
    final FormState form = _formKey.currentState;

    if (!isSaved) {
      if (!form.validate()) {
        MyNotification.showInfoFlushbar(
            context,
            AppLocalizations.of(context).translate('errors'),
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
            AppLocalizations.of(context).translate('error'),
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

        Post updatedPost = await _updatePost();
        await _uploadImageToServer();
        await _saveImages(updatedPost);
        await imageToRemove.forEach((item) => deleteByImageUrl(item.image_url));
        isSaved = true;
        MyNotification.showInfoFlushbar(
            context,
            AppLocalizations.of(context).translate('info'),
            AppLocalizations.of(context)
                .translate('advert_changed_success_message'),
            Icon(
              Icons.info_outline,
              size: 28,
              color: Colors.blue.shade300,
            ),
            Colors.blue.shade300,
            2);
        setState(() {});
      }
    }
  }

  Future<Post> _updatePost() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print("User: " + user.email);

    _post.fee_typ = utils.Converter.convertStringToFeeTyp(_feeTyp);
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
      for (var file in newPostImages) {
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
                color: Colors.red.shade300,
              ),
              Colors.red.shade300,
              2);
        }
      }
      Navigator.pop(context); //TODO Check this
    } catch (e) {
      Navigator.pop(context);
      MyNotification.showInfoFlushbar(
          context,
          AppLocalizations.of(context).translate('info'),
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
    return 'Negociable';
  }

  Future<void> _loadImages() async {
    _feeTyp = getFeeTyp(widget.post.fee_typ);
    _postTyp = widget.post.post_typ;
    oldPostImages = await _imageService.fetchImagesByPostID(widget.post.id);
    imageCount = oldPostImages.length;

    Categorie _categorie =
        await _categorieService.fetchCategorieByID(widget.post.categorieid);
    String translatedCategory =
        AppLocalizations.of(context).translate(_categorie.title);

    _categorieTile = new CategorieTile(
        translatedCategory == null ? _categorieTile.title : translatedCategory,
        _categorie.id);
    setState(() {});
  }

  _fieldFocusChange(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
