import 'package:emarket_app/pages/account/account_page.dart';
import 'package:emarket_app/pages/home/home_page.dart';
import 'package:emarket_app/pages/post/post_page.dart';
import 'package:emarket_app/pages/search/search_page.dart';
import 'package:flutter/material.dart';

import '../../custom_component/custom_linear_gradient.dart';
import '../../model/feetyp.dart';
import '../../model/post.dart';
import '../../model/posttyp.dart';
import '../../model/status.dart';
import '../message/message_page.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => new _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("My eMarket App"),
        backgroundColor: Colors.deepPurple,
      ),
      body: CustomLinearGradient(
        myChild: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Rechercher'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text('Inserer'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Mon compte'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text('Message'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Future _showPostForm() async {
    Navigator.of(context).pop();
    Post post = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PostPage(),
      ),
    );
    if (post != null) {
      //insert new Post in the postList
      //send new Post to backend

    }
  }

  static List<Post> postList = []
    ..add(Post(id: 2,title: 'Vélo', created_at: new DateTime(2013, 9, 7, 17, 30), post_typ: PostTyp.offer, description: 'description Vélo', fee: 250000, fee_typ: FeeTyp.negotiable, city: 'Ngaoundal', quarter: 'Gare', status: Status.created, rating: 6, userid: 1, categorieid: 2))
    ..add(Post(id: 2,title: 'Vélo', created_at: new DateTime(2013, 9, 7, 17, 30), post_typ: PostTyp.offer, description: 'description Vélo', fee: 250000, fee_typ: FeeTyp.negotiable, city: 'Ngaoundal', quarter: 'Gare', status: Status.created, rating: 6, userid: 1, categorieid: 2))
    ..add(Post(id: 2,title: 'Vélo', created_at: new DateTime(2013, 9, 7, 17, 30), post_typ: PostTyp.offer, description: 'description Vélo', fee: 250000, fee_typ: FeeTyp.negotiable, city: 'Ngaoundal', quarter: 'Gare', status: Status.created, rating: 6, userid: 1, categorieid: 2))
    ..add(Post(id: 2,title: 'Vélo', created_at: new DateTime(2013, 9, 7, 17, 30), post_typ: PostTyp.offer, description: 'description Vélo', fee: 250000, fee_typ: FeeTyp.negotiable, city: 'Ngaoundal', quarter: 'Gare', status: Status.created, rating: 6, userid: 1, categorieid: 2))
    ..add(Post(id: 2,title: 'Vélo', created_at: new DateTime(2013, 9, 7, 17, 30), post_typ: PostTyp.offer, description: 'description Vélo', fee: 250000, fee_typ: FeeTyp.negotiable, city: 'Ngaoundal', quarter: 'Gare', status: Status.created, rating: 6, userid: 1, categorieid: 2))
    ..add(Post(id: 2,title: 'Vélo', created_at: new DateTime(2013, 9, 7, 17, 30), post_typ: PostTyp.offer, description: 'description Vélo', fee: 250000, fee_typ: FeeTyp.negotiable, city: 'Ngaoundal', quarter: 'Gare', status: Status.created, rating: 6, userid: 1, categorieid: 2))
    ..add(Post(id: 2,title: 'Vélo', created_at: new DateTime(2013, 9, 7, 17, 30), post_typ: PostTyp.offer, description: 'description Vélo', fee: 250000, fee_typ: FeeTyp.negotiable, city: 'Ngaoundal', quarter: 'Gare', status: Status.created, rating: 6, userid: 1, categorieid: 2))
    ..add(Post(id: 2,title: 'Vélo', created_at: new DateTime(2013, 9, 7, 17, 30), post_typ: PostTyp.offer, description: 'description Vélo', fee: 250000, fee_typ: FeeTyp.negotiable, city: 'Ngaoundal', quarter: 'Gare', status: Status.created, rating: 6, userid: 1, categorieid: 2))
    ..add(Post(id: 2,title: 'Vélo', created_at: new DateTime(2013, 9, 7, 17, 30), post_typ: PostTyp.offer, description: 'description Vélo', fee: 250000, fee_typ: FeeTyp.negotiable, city: 'Ngaoundal', quarter: 'Gare', status: Status.created, rating: 6, userid: 1, categorieid: 2))
    ..add(Post(id: 2,title: 'Vélo', created_at: new DateTime(2013, 9, 7, 17, 30), post_typ: PostTyp.offer, description: 'description Vélo', fee: 250000, fee_typ: FeeTyp.negotiable, city: 'Ngaoundal', quarter: 'Gare', status: Status.created, rating: 6, userid: 1, categorieid: 2))
    ..add(Post(id: 2,title: 'Vélo', created_at: new DateTime(2013, 9, 7, 17, 30), post_typ: PostTyp.offer, description: 'description Vélo', fee: 250000, fee_typ: FeeTyp.negotiable, city: 'Ngaoundal', quarter: 'Gare', status: Status.created, rating: 6, userid: 1, categorieid: 2))
    ..add(Post(id: 2,title: 'Vélo', created_at: new DateTime(2013, 9, 7, 17, 30), post_typ: PostTyp.offer, description: 'description Vélo', fee: 250000, fee_typ: FeeTyp.negotiable, city: 'Ngaoundal', quarter: 'Gare', status: Status.created, rating: 6, userid: 1, categorieid: 2))
    ..add(Post(id: 2,title: 'Vélo', created_at: new DateTime(2013, 9, 7, 17, 30), post_typ: PostTyp.offer, description: 'description Vélo', fee: 250000, fee_typ: FeeTyp.negotiable, city: 'Ngaoundal', quarter: 'Gare', status: Status.created, rating: 6, userid: 1, categorieid: 2))
    ..add(Post(id: 2,title: 'Vélo', created_at: new DateTime(2013, 9, 7, 17, 30), post_typ: PostTyp.offer, description: 'description Vélo', fee: 250000, fee_typ: FeeTyp.negotiable, city: 'Ngaoundal', quarter: 'Gare', status: Status.created, rating: 6, userid: 1, categorieid: 2));

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    SearchPage(postList),
    PostPage(),
    AccountPage(),
    MessagePage(),
  ];
}
