import 'package:emarket_app/pages/account/account_page.dart';
import 'package:emarket_app/pages/home/home_page.dart';
import 'package:emarket_app/pages/post/post_page.dart';
import 'package:emarket_app/pages/search/search_page.dart';
import 'package:flutter/material.dart';

import '../../custom_component/custom_linear_gradient.dart';
import '../message/message_page.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => new _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {

  int _selectedIndex = 0;

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    SearchPage(),
    PostPage(),
    AccountPage(),
    MessagePage(),
  ];
}
