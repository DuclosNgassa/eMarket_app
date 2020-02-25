import 'dart:ui';

import 'package:flutter/material.dart';

const APP_URL = "https://play.google.com/store/apps/details?id=com.softsolution.emarket_app";
//const SITE_WEB = "https://kmersoftdesign.wordpress.com/";
const SITE_WEB = "https://www.kmerconsulting.com/";
const PRIVACY_POLICY_URL = "https://kmersoftdesign.wordpress.com/datenschutzerklarung/";

const SERVER_URL = "https://emarket.kmerconsulting.com"; // Server
//const SERVER_URL = "http://192.168.2.120:3000"; // Local
//const SERVER_URL = "http://10.2.17.228:3000"; // Office
//const SERVER_URL = "https://emarket-server.herokuapp.com"; //on Heroku
//const SERVER_URL = "http://172.20.10.5:3000";
//const SERVER_URL = "http://10.0.2.2:3000";

const URL_POSTS = SERVER_URL + "/posts";
const URL_POST_BY_ID = URL_POSTS + "/";
const URL_POST_ACTIVE = URL_POSTS + "/active";
const URL_POST_VIEW = URL_POSTS + "/view/";
const URL_POST_BY_USEREMAIL = URL_POSTS + "/user/";
const URL_POST_BY_CATEGORY = URL_POSTS + "/categorie/";

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

const URL_USER_NOTIFICATION = SERVER_URL + "/userNotification";
const URL_USER_NOTIFICATION_BY_EMAIL = URL_FAVORITS + "/useremail/";

const URL_MESSAGES = SERVER_URL + "/messages";
const URL_MESSAGES_BY_EMAIL = URL_MESSAGES + "/email/";
const URL_MESSAGES_BY_POSTID = URL_MESSAGES + "/post/";
const URL_MESSAGES_BY_SENDER = URL_MESSAGES + "/sender/";
const URL_MESSAGES_BY_RECEIVER = URL_MESSAGES + "/receiver/";

const HOMEPAGE = 0;
const POSTPAGE = 1;
const ACCOUNTPAGE = 2;
const MESSAGEPAGE = 3;
const CONFIGURATIONPAGE = 4;

const String USER_EMAIL = "USER_EMAIL";
const String USER_NAME = "USER_NAME";
const String DEVICE_TOKEN = "DEVICE_TOKEN";
const String AUTHENTICATION_TOKEN = "auth-token";
const String NEW_MESSAGE = "NEW_MESSAGE";
const String POST_LIST = "POST_LIST";
const String POST_LIST_CACHE_TIME = "POST_LIST_CACHE_TIME";
const String CATEGORIE_LIST = "CATEGORIE_LIST";
const String PARENT_CATEGORIE_LIST = "PARENT_CATEGORIE_LIST";

Color colorDeepPurple300 = Colors.deepPurple[300]; //Color(0xFF95E08E);
Color colorDeepPurple400 = Colors.deepPurple[400]; //Color(0xFF33BBB5);
Color colorDeepPurple500 = Colors.deepPurple[500]; //Color(0xFF00AA12);
Color backgroundColor = Color(0xFFEFEEF5);
Color colorRed = Colors.redAccent;
Color colorWhite = Colors.white;
Color colorTransparent = Colors.transparent;
Color colorBlue = Colors.blue;
Color colorGrey400 = Colors.grey;
Color colorGrey300 = Colors.grey[300];
Color colorGrey100 = Colors.grey[100];

final int  MAX_RATING = 5;

final String SERVER_KEY = "AAAA3RFWb2g:APA91bHZ8ZgSyvEpVclsAjKmLjUndGnuQK4ZK6302Anw3Vfout-Ffb7s2Xum8wGSiZi0xlOE8v1Y9bZ9gZDyocYe7a4-nNSpk7FcSvmO4Z52rfCpMJR_sFdO2yWeo8NKhKHtbYMIGOQg";
final String GOOGLE_FCM_END_POINT = 'https://fcm.googleapis.com/fcm/send';