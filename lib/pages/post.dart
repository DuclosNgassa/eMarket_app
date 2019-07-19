import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../converter/date_converter.dart';
import '../validator/form_validator.dart';
import '../model/contact.dart';

class Post extends StatefulWidget {
  Post({Key key, this.pageTitle}) : super(key: key);
  final String pageTitle;

  @override
  _PostPageState createState() => new _PostPageState();
}

class _PostPageState extends State<Post> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final TextEditingController _controller = new TextEditingController();

  List<String> _colors = <String>['', 'red', 'green', 'orange'];
  String _color = '';
  DateConverter dateConverter = new DateConverter();
  FormValidator formValidator = new FormValidator();
  Contact newContact = new Contact();

  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = initialDateString.isNotEmpty ? dateConverter.convertToDate(initialDateString) : now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);
    var result = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (result == null) return;
    setState(() {
      _controller.text = DateFormat.yMd().format(result);
    });
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Form is not valide! Please review and correct.');
    } else {
      form.save();
      print('Form save called, newContact is now up to date...');
      print('Email: ${newContact.name}');
      print('Dob: ${newContact.dob}');
      print('Phone: ${newContact.phone}');
      print('Email: ${newContact.email}');
      print('Favorite Color: ${newContact.favoriteColor}');
      print('========================================');
      print('Submitting to back end...');
      print('TODO - we will write the submission part next...');
    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(message),
      backgroundColor: color,
    ));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.pageTitle),
        backgroundColor: Colors.redAccent,
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  hintText: 'Enter your first and last name',
                  labelText: 'Name',
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(30),
                ],
                validator: (val) =>
                    formValidator.isEmptyText(val) ? 'Enter a name' : null,
                onSaved: (val) => newContact.name = val,
              ),
              Row(
                children: <Widget>[
                  new Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.calendar_today),
                        hintText: 'Enter your date of birth',
                        labelText: 'Dob',
                      ),
                      controller: _controller,
                      keyboardType: TextInputType.datetime,
                      validator: (val) => formValidator.isValidDob(val)
                          ? null
                          : 'Not a valid date',
                      onSaved: (val) =>
                          newContact.dob = dateConverter.convertToDate(val),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_horiz),
                    tooltip: 'Choose date',
                    onPressed: (() {
                      _chooseDate(context, _controller.text);
                    }),
                  )
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.phone),
                  hintText: 'Enter a phone number',
                  labelText: 'Phone',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  new WhitelistingTextInputFormatter(
                      new RegExp(r'^[()\d -]{1,15}$')),
                ],
                validator: (value) => formValidator.isValidPhoneNumber(value)
                    ? null
                    : 'Phone number must be entered as (###)###-####',
                onSaved: (val) => newContact.phone = val,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.email),
                  hintText: 'Enter a mail address',
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [LengthLimitingTextInputFormatter(50)],
                validator: (value) => formValidator.isValidEmail(value)
                    ? null
                    : 'Please enter a valid email address',
                onSaved: (val) => newContact.email = val,
              ),
              FormField(
                builder: (FormFieldState state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      icon: Icon(Icons.color_lens),
                      labelText: 'Color',
                      errorText: state.hasError ? state.errorText : null,
                    ),
                    isEmpty: _color == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: _color,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(() {
                            newContact.favoriteColor = newValue;
                            _color = newValue;
                            state.didChange(newValue);
                          });
                        },
                        items: _colors.map((String value) {
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
                    ? 'Please select a color'
                    : null,
              ),
              new Container(
                padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                child: RaisedButton(
                  child: Text('Submit'),
                  onPressed: _submitForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
