const APP_URL =
    "https://play.google.com/store/apps/details?id=com.softsolution.emarket_app";
//const SITE_WEB = "https://kmersoftdesign.wordpress.com/";
const SITE_WEB = "https://www.kmerconsulting.com/";
const PRIVACY_POLICY_URL =
    "https://kmersoftdesign.wordpress.com/datenschutzerklarung/";

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
