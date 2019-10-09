import 'dart:ui';

import 'package:flutter/material.dart';

const SERVER_URL           = "http://192.168.2.120:3000";

const URL_POSTS            = SERVER_URL + "/posts";

const URL_USERS            = SERVER_URL + "/users";

const URL_IMAGES           = SERVER_URL + "/images";
const URL_IMAGES_UPLOAD    = URL_IMAGES + "/upload";
const URL_IMAGES_BY_POSTID = URL_IMAGES + "/post/";

const URL_CATEGORIES       = SERVER_URL + "/categories";

Color lightGreen = Color(0xFF95E08E);
Color lightBlueIsh = Color(0xFF33BBB5);
Color darkGreen = Color(0xFF00AA12);
Color backgroundColor = Color(0xFFEFEEF5);


TextStyle titleStyleWhite = new TextStyle(
    fontFamily: 'Helvetica',
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 25
);
TextStyle jobCardTitileStyleBlue = new TextStyle(
    fontFamily: 'Avenir',
    color: lightBlueIsh,
    fontWeight: FontWeight.bold,
    fontSize: 12
);
TextStyle jobCardTitileStyleBlack = new TextStyle(
    fontFamily: 'Avenir',
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 12
);
TextStyle titileStyleLighterBlack = new TextStyle(
    fontFamily: 'Avenir',
    color: Color(0xFF34475D),
    fontWeight: FontWeight.bold,
    fontSize: 20
);

TextStyle titileStyleBlack = new TextStyle(
    fontFamily: 'Helvetica',
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 20
);
TextStyle salaryStyle = new TextStyle(
    fontFamily: 'Avenir',
    color: darkGreen,
    fontWeight: FontWeight.bold,
    fontSize: 12
);

TextStyle formStyle = new TextStyle(
    //fontFamily: 'Helvetica',
    color: Colors.black,
    fontSize: 15
);
