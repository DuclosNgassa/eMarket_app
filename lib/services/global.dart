import 'dart:ui';

import 'package:emarket_app/pages/home/home_page.dart';
import 'package:flutter/material.dart';

//const SERVER_URL           = "http://192.168.2.120:3000";
const SERVER_URL = "http://172.20.10.5:3000";

const URL_POSTS = SERVER_URL + "/posts";

const URL_USERS = SERVER_URL + "/users";

const URL_IMAGES = SERVER_URL + "/images";
const URL_IMAGES_UPLOAD = URL_IMAGES + "/upload";
const URL_IMAGES_BY_POSTID = URL_IMAGES + "/post/";

const URL_CATEGORIES = SERVER_URL + "/categories";

const HOMEPAGE = 0;
const SEARCHPAGE = 1;
const POSTPAGE = 2;
const ACCOUNTPAGE = 3;
const MESSAGEPAGE = 4;

Color colorDeepPurple300 = Colors.deepPurple[300]; //Color(0xFF95E08E);
Color colorDeepPurple400 = Colors.deepPurple[400]; //Color(0xFF33BBB5);
Color colorDeepPurple500 = Colors.deepPurple[500]; //Color(0xFF00AA12);
Color backgroundColor = Color(0xFFEFEEF5);
Color colorRed = Colors.redAccent;

const double BUTTON_FONT_SIZE = 10;

TextStyle titleStyleWhite = new TextStyle(
    fontFamily: 'Helvetica',
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 25);
TextStyle jobCardTitileStyleBlue = new TextStyle(
    fontFamily: 'Avenir',
    color: colorDeepPurple400,
    fontWeight: FontWeight.bold,
    fontSize: 12);
TextStyle jobCardTitileStyleBlack = new TextStyle(
    fontFamily: 'Avenir',
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 12);
TextStyle titileStyleLighterBlack = new TextStyle(
    fontFamily: 'Avenir',
    color: Color(0xFF34475D),
    fontWeight: FontWeight.bold,
    fontSize: 20);

TextStyle titileStyleBlack = new TextStyle(
    fontFamily: 'Helvetica',
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 20);
TextStyle salaryStyle = new TextStyle(
    fontFamily: 'Avenir',
    color: colorDeepPurple500,
    fontWeight: FontWeight.bold,
    fontSize: 12);

TextStyle formStyle = new TextStyle(
    //fontFamily: 'Helvetica',
    color: Colors.black,
    fontSize: 12);

TextStyle radioButtonStyle = new TextStyle(
    //fontFamily: 'Helvetica',
    color: Colors.black,
    fontSize: 10);

TextStyle priceStyle = new TextStyle(
    fontFamily: 'Avenir',
    color: colorDeepPurple500,
    fontWeight: FontWeight.bold,
    fontSize: 12);

TextStyle titleStyle = new TextStyle(
    fontFamily: 'Avenir',
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    fontSize: 12);

TextStyle cityStyle =
    new TextStyle(fontFamily: 'Avenir', color: Colors.black45, fontSize: 12);

TextStyle normalStyle = new TextStyle(color: Colors.black, fontSize: 12);

TextStyle styleButtonWhite = new TextStyle(color: Colors.white, fontSize: 12);

TextStyle priceDetailStyle = new TextStyle(
    color: colorDeepPurple500, fontWeight: FontWeight.bold, fontSize: 20);

TextStyle titleDetailStyle = new TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    fontSize: 20);

TextStyle greyDetailStyle = new TextStyle(color: Colors.black45, fontSize: 12);

TextStyle normalDetailStyle = new TextStyle(color: Colors.black, fontSize: 20);
