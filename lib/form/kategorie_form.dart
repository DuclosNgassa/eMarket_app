import 'package:flutter/material.dart';

class KategorieForm extends StatefulWidget {
  @override
  KategorieFormState createState() {
    return KategorieFormState();
  }
}

class KategorieFormState extends State<KategorieForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration:
                InputDecoration(border: InputBorder.none, labelText: 'Name'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Geben Sie einen Text!';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: Text('Daten werden bearbeiten')),
                    ),
                  );
                }
              },
              child: Text('Submit'),
            ),
          )
        ],
      ),
    );
  }
}
