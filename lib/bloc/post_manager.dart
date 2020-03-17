import 'package:emarket_app/model/favorit.dart';
import 'package:emarket_app/model/post.dart';
import 'package:emarket_app/model/post_wrapper.dart';
import 'package:emarket_app/services/favorit_service.dart';
import 'package:emarket_app/services/post_service.dart';
import 'package:emarket_app/services/sharedpreferences_service.dart';
import 'package:emarket_app/util/global.dart';
import 'package:emarket_app/util/util.dart';

class PostManager {
  PostService _postService = new PostService();
  FavoritService _favoritService = new FavoritService();
  SharedPreferenceService _sharedPreferenceService =
      new SharedPreferenceService();

  List<Post> _postList = new List();
  List<Favorit> _favoritList = new List();
  bool _showPictures;
  PostWrapper _postWrapper = new PostWrapper();

  Stream<PostWrapper> get postWrapper async* {
    _postList = await _postService.fetchActivePosts();
    String userEmail = await _sharedPreferenceService.read(USER_EMAIL);
    if (userEmail != null && userEmail.isNotEmpty) {
      _favoritList = await _favoritService.fetchFavoritByUserEmail(userEmail);
    }
    _showPictures = await Util.readShowPictures(_sharedPreferenceService);

    _postWrapper.postList = _postList;
    _postWrapper.favoritList = _favoritList;
    _postWrapper.showPictures = _showPictures;

    yield _postWrapper;
  }

  Stream<List<Post>> get myPosts async* {
    String userEmail = await _sharedPreferenceService.read(USER_EMAIL);
    List<Post> myPostList = await _postService.fetchPostByUserEmail(userEmail);

    yield myPostList;
  }
}
