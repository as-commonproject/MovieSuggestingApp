import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:moviesapp/pages/placeholderPage.dart';
import 'package:moviesapp/pages/profilePage.dart';
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
        return PlaceholderWidget(i:2);

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
            child: bottomNavigationBar,
          )
        ],
      )
    );
  }

  Widget get bottomNavigationBar {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(35),
        topLeft: Radius.circular(35),
      ),
      child: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        backgroundColor: Theme.of(context).accentColor,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedItemColor: Theme.of(context).scaffoldBackgroundColor,
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
            title: Text("Feeds"),
            icon: Icon(MdiIcons.movieOutline),
          ),
          BottomNavigationBarItem(
            title: Text("Search"),
            icon: Icon(MdiIcons.searchWeb),
          ),
          BottomNavigationBarItem(
            title: Text("Profile"),
            icon: Icon(MdiIcons.face),
          ),
        ],
      ),
    );
  }
}
