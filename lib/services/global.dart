import 'dart:ui';

import 'package:flutter/material.dart';

const SERVER_URL = "http://192.168.2.120:3000"; // Local at home
//const SERVER_URL = "https://emarket-server.herokuapp.com"; //on Heroku
//const SERVER_URL = "http://172.20.10.5:3000";
//const SERVER_URL = "http://10.0.2.2:3000";

const URL_POSTS = SERVER_URL + "/posts";
const URL_POST_BY_ID = URL_POSTS + "/";
const URL_POST_BY_USEREMAIL = URL_POSTS + "/user/";

const URL_USERS = SERVER_URL + "/users";
const URL_USERS_BY_EMAIL = URL_USERS + "/email/";

const URL_IMAGES = SERVER_URL + "/images";
const URL_IMAGES_BY_ID = URL_IMAGES + "/";
const URL_IMAGES_UPLOAD = URL_IMAGES + "/upload";
const URL_IMAGES_BY_IMAGE_URL = URL_IMAGES + "/url/";
const URL_IMAGES_BY_POSTID = URL_IMAGES + "/post/";
const URL_IMAGES_BY_PATH = URL_IMAGES + "/server/";

const URL_CATEGORIES = SERVER_URL + "/categories";
const URL_CATEGORIES_BY_ID = URL_CATEGORIES + "/";

const URL_FAVORITS = SERVER_URL + "/favorits";
const URL_FAVORITS_BY_EMAIL = URL_FAVORITS + "/user/";

const URL_MESSAGES = SERVER_URL + "/messages";
const URL_MESSAGES_BY_EMAIL = URL_MESSAGES + "/email/";
const URL_MESSAGES_BY_POSTID = URL_MESSAGES + "/post/";
const URL_MESSAGES_BY_SENDER = URL_MESSAGES + "/sender/";
const URL_MESSAGES_BY_RECEIVER = URL_MESSAGES + "/receiver/";

const HOMEPAGE = 0;
const SEARCHPAGE = 1;
const POSTPAGE = 2;
const ACCOUNTPAGE = 3;
const MESSAGEPAGE = 4;

const String USER_EMAIL = "userEmail";
const String USER_NAME = "userName";

Color colorDeepPurple300 = Colors.deepPurple[300]; //Color(0xFF95E08E);
Color colorDeepPurple400 = Colors.deepPurple[400]; //Color(0xFF33BBB5);
Color colorDeepPurple500 = Colors.deepPurple[500]; //Color(0xFF00AA12);
Color backgroundColor = Color(0xFFEFEEF5);
Color colorRed = Colors.redAccent;
Color colorWhite = Colors.white;
Color colorTransparent = Colors.transparent;
Color colorBlue = Colors.blue;

const double BUTTON_FONT_SIZE = 10;

/*
TextStyle formStyle = new TextStyle(
    color: Colors.black,
    fontSize: 12);
*/

/*
TextStyle radioButtonStyle = new TextStyle(
    //fontFamily: 'Helvetica',
    color: Colors.black,
    fontSize: 10);
*/
/*
TextStyle priceStyle = new TextStyle(
    fontFamily: 'Avenir',
    color: colorDeepPurple500,
    fontWeight: FontWeight.bold,
    fontSize: 10);
*/

/*
TextStyle titleStyle = new TextStyle(
    fontFamily: 'Avenir',
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    fontSize: 12);
*/

/*
TextStyle cityStyle = new TextStyle(
  fontFamily: 'Avenir',
  color: Colors.black45,
  fontSize: 12,
);
*/

//TextStyle normalStyle = new TextStyle(color: Colors.black, fontSize: 12);
//TextStyle normalStyleWhite = new TextStyle(color: Colors.white, fontSize: 15);

/*
TextStyle styleButtonWhite = new TextStyle(
  color: Colors.white,
  fontSize: 12,
);
*/

/*
TextStyle priceDetailStyle = new TextStyle(
    color: colorDeepPurple500, fontWeight: FontWeight.bold, fontSize: 15);
*/

/*
TextStyle titleDetailStyle = new TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    fontSize: 20);
*/

/*
TextStyle styleTitleWhite = new TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    fontSize: 20);
*/

/*
TextStyle styleSubtitleWhite = new TextStyle(
    color: Colors.white, fontStyle: FontStyle.italic, fontSize: 15);
*/

//TextStyle greyDetailStyle = new TextStyle(color: Colors.black45, fontSize: 12);

//TextStyle normalDetailStyle = new TextStyle(color: Colors.black, fontSize: 20);
