import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:moviesapp/pages/placeholderPage.dart';
import 'package:moviesapp/pages/profilePage.dart';
import 'package:moviesapp/pages/searchPage.dart';
import 'package:moviesapp/size_config/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  SharedPreferences prefs;
  String name, photo;

  getPage(int index){
    switch(index){
      case 0:
        return PlaceholderWidget(i: 1);

      case 1:
        return SearchPage();

      case 2:
        return Profile(name: name, photo: photo,);
    }
  }

  onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  getDetails() async{
    prefs = await SharedPreferences.getInstance();
    name = prefs.getString('username');
    photo = prefs.getString('photo');
  }

  void initState() {
    super.initState();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).scaffoldBackgroundColor == Color.fromRGBO(1, 1, 1, 1);
    SizeConfig().init(context);
    return Scaffold(
        body: Stack(
          children: [
            Container(
              width: SizeConfig.blockSizeHorizontal*100,
              height: SizeConfig.blockSizeVertical*100,
              child: getPage(_currentIndex),
            ),

            Positioned(
              left: 0, bottom: 0, right: 0,
              child: bottomNavigationBar(isDark),
            ),
          ],
        )
    );
  }

  Widget bottomNavigationBar(bool isDark) {
    return CurvedNavigationBar(
      onTap: onTabTapped,
      index: _currentIndex,
      backgroundColor: Colors.transparent,
      items: <Widget>[
          Icon(MdiIcons.movieOutline, size: 35,),
          Icon(MdiIcons.searchWeb, size: 35,),
          Icon(MdiIcons.face, size: 35,),
      ],
      color: isDark ? Color.fromRGBO(41, 41, 41, 1) :  Color.fromRGBO(221, 221, 221, 1),
      height: SizeConfig.blockSizeVertical*7,
      buttonBackgroundColor: isDark ? Color.fromRGBO(41, 41, 41, 1) :  Color.fromRGBO(221, 221, 221, 1),
      animationCurve: Curves.easeInOut,
      animationDuration: Duration(milliseconds: 500),
    );
  }
}





//************BottomNavBarShadow************
//          Positioned(
//              left: 0, bottom: 0, right: 0,
//              child: Container(
//                height: 60,
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.only(
//                      topRight: Radius.circular(35),
//                      topLeft: Radius.circular(35),
//                    ),
//                    color: Colors.transparent,
//                    boxShadow: [BoxShadow(
//                        color: Colors.black.withOpacity(0.2),
//                        spreadRadius: 0.01,
//                        blurRadius: 20,
//                        offset: Offset(0, -2)
//                    )
//                    ]
//                ),
//              ),
//            ),