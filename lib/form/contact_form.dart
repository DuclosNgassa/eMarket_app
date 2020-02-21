import 'package:emarket_app/localization/app_localizations.dart';
import 'package:emarket_app/model/user_notification.dart';
import 'package:emarket_app/services/global.dart';
import 'package:emarket_app/services/user_notification_service.dart';
import 'package:emarket_app/util/notification.dart';
import 'package:emarket_app/util/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/searchparameter.dart';
import '../validator/form_validator.dart';

class ContactForm extends StatefulWidget {
  ContactForm(BuildContext context);

  @override
  ContactFormState createState() => new ContactFormState();
}

class ContactFormState extends State<ContactForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  UserNotification _userNotification = new UserNotification();
  UserNotificationService _notificationService = new UserNotificationService();

  FormValidator formValidator = new FormValidator();
  SearchParameter searchParameter = new SearchParameter();
  FocusNode _subjectFocusNode;
  FocusNode _messageFocusNode;

  @override
  void initState() {
    super.initState();
    _subjectFocusNode = FocusNode();
    _messageFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _subjectFocusNode.dispose();
    _messageFocusNode.dispose();

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
            TextFormField(
              style: SizeConfig.styleFormGrey,
              textInputAction: TextInputAction.next,
              focusNode: _subjectFocusNode,
              onFieldSubmitted: (term) {
                _fieldFocusChange(_subjectFocusNode, _messageFocusNode);
              },
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).translate('give_title'),
                labelText: AppLocalizations.of(context).translate('title'),
                labelStyle: SizeConfig.styleFormBlack,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(30),
              ],
              onSaved: (val) => _userNotification.title = val,
            ),
            TextFormField(
              style: SizeConfig.styleFormGrey,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              focusNode: _messageFocusNode,
              onFieldSubmitted: (value) {
                _messageFocusNode.unfocus();
                _submitForm();
              },
              maxLines: 10,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).translate('give_your_message'),
                labelText: AppLocalizations.of(context).translate('message'),
                labelStyle: SizeConfig.styleFormBlack,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(500),
              ],
              validator: (val) => formValidator.isEmptyText(val)
                  ? AppLocalizations.of(context).translate('give_your_message')
                  : null,
              onSaved: (val) => _userNotification.message = val,
            ),
            Container(
              width: SizeConfig.screenWidth * 0.9,
              padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
              child: RaisedButton(
                shape: const StadiumBorder(),
                color: colorDeepPurple400,
                child: Text(AppLocalizations.of(context).translate('send'), style: SizeConfig.styleButtonWhite),
                onPressed: _submitForm,
              ),
            ),
          ],
        ),
      ),
    );
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
    } else {
      form.save();
      await _saveUserNotifikation();
      MyNotification.showInfoFlushbar(
          context,
          AppLocalizations.of(context).translate('info'),
          AppLocalizations.of(context).translate('thanks_for_your_message'),
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

  Future<UserNotification> _saveUserNotifikation() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    print("User-Firebase: " + user.email);

    _userNotification.created_at = DateTime.now();
    _userNotification.useremail = user.email;

    Map<String, dynamic> userNotificationParams =
        _userNotification.toMap(_userNotification);
    UserNotification savedUserNotification =
        await _notificationService.save(userNotificationParams);

    return savedUserNotification;
  }

  clearForm() {
    _formKey.currentState?.reset();
    setState(() {});
  }

  _fieldFocusChange(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
