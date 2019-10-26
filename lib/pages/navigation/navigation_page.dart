import 'package:emarket_app/pages/account/account_page.dart';
import 'package:emarket_app/pages/home/home_page.dart';
import 'package:emarket_app/pages/post/post_page.dart';
import 'package:emarket_app/pages/search/search_page.dart';
import 'package:emarket_app/services/global.dart';
import 'package:flutter/material.dart';

import '../message/message_page.dart';

class NavigationPage extends StatefulWidget {
  int _selectedIndex = 0;

  NavigationPage(this._selectedIndex);

  @override
  _NavigationPageState createState() => new _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {

  int _localSelectedIndex = 0;
  static bool isLogedIn = false;

  @override
  void initState() {
    _localSelectedIndex = widget._selectedIndex;
    if (_localSelectedIndex > 0) {
      isLogedIn = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = size.height;
    final double itemWidth = size.width;

    return new Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 10, top: 25),
                    constraints: BoxConstraints.expand(height: itemHeight / 4),
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [colorDeepPurple400, colorDeepPurple300],
                          begin: const FractionalOffset(1.0, 1.0),
                          end: const FractionalOffset(0.2, 0.2),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Container(
                      //padding: EdgeInsets.only(top: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'eMarket',
                              style: titleStyleWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 55),
                    constraints:
                        BoxConstraints.expand(height: itemHeight * 0.80),
                    child: _widgetOptions.elementAt(_localSelectedIndex),
                  ),
                ],
              )
            ],
          ),
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
        currentIndex: _localSelectedIndex,
        selectedItemColor: colorDeepPurple400,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _localSelectedIndex = index;
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
