import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:moviesapp/login_signup/index.dart';
import 'package:moviesapp/size_config/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final String name, photo;

  Profile({
    this.photo,
    this.name
  });
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  SharedPreferences prefs;


  Future<Null> handleSignout() async{
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
    prefs.setBool('isSignedIn', false);
    await FirebaseAuth.instance.signOut();
    if(await _googleSignIn.isSignedIn()){
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
    }

    Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (_)=> Index()),
            (Route<dynamic> route) => false
    );
  }

  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme
        .of(context)
        .scaffoldBackgroundColor == Color.fromRGBO(1, 1, 1, 1);
    SizeConfig().init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: SizeConfig.blockSizeHorizontal * 100,
              height: 220,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [Theme
                              .of(context)
                              .accentColor, Colors.greenAccent.withBlue(220)],
                        ),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15))
                    ),
                    width: SizeConfig.blockSizeHorizontal * 50,
                    child: widget.photo != null ?
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15)),
                      child: Image(
                        image: NetworkImage(widget.photo),
                        fit: BoxFit.fill,
                      ),
                    )
                        : null,
                  ),
                  Positioned(
                    top: 190,
                    left: SizeConfig.blockSizeHorizontal * 55,
                    child: Container(
                      child: Text(
                        widget.name.split(" ")[0],
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical * 3.3,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: SizeConfig.blockSizeVertical * 4,
                    right: 0,
                    child: Container(
                      width: SizeConfig.blockSizeHorizontal * 17.5,
                      height: SizeConfig.blockSizeVertical * 5.5,
                      decoration: BoxDecoration(
                          color: isDark ? Color.fromRGBO(61, 61, 61, 1) : Colors
                              .white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(2, 0)
                            )
                          ]
                      ),
                      child: Center(
                          child: GestureDetector(
                              onTap: handleSignout,
                              child: Icon(MdiIcons.logoutVariant)
                          )
                      ),
                    ),
                  )
                ],
              ),
            ),


            Container(
              padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 4),
              width: SizeConfig.blockSizeHorizontal * 100,
              height: SizeConfig.blockSizeVertical * 22,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UserDetails("99", "likes", isDark, MdiIcons.heart),
                  UserDetails("3,875", "followers", isDark, MdiIcons.starFace),
                  UserDetails(
                      "1,922", "following", isDark, MdiIcons.humanGreeting)
                ],
              ),
            ),
            Container(
              width: SizeConfig.blockSizeHorizontal * 90,
              height: SizeConfig.blockSizeVertical * 11,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [Theme
                        .of(context)
                        .accentColor, Theme
                        .of(context)
                        .accentColor
                        .withGreen(230)
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.greenAccent.withBlue(220).withOpacity(
                            0.2),
                        spreadRadius: 3,
                        blurRadius: 15,
                        offset: Offset(0, 10)
                    )
                  ]
              ),
              child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Rate Us on Play Store",
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical * 2.5,
                            color: Theme
                                .of(context)
                                .scaffoldBackgroundColor,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(MdiIcons.star, color: Theme
                              .of(context)
                              .scaffoldBackgroundColor,
                            size: SizeConfig.blockSizeVertical * 2,),
                          Icon(MdiIcons.star, color: Theme
                              .of(context)
                              .scaffoldBackgroundColor,
                            size: SizeConfig.blockSizeVertical * 2.2,),
                          Icon(MdiIcons.star, color: Theme
                              .of(context)
                              .scaffoldBackgroundColor,
                            size: SizeConfig.blockSizeVertical * 2.5,),
                          Icon(MdiIcons.star, color: Theme
                              .of(context)
                              .scaffoldBackgroundColor,
                            size: SizeConfig.blockSizeVertical * 2.2,),
                          Icon(MdiIcons.star, color: Theme
                              .of(context)
                              .scaffoldBackgroundColor,
                            size: SizeConfig.blockSizeVertical * 2,),
                        ],
                      )
                    ],
                  )
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 2.5),
            Container(
              width: SizeConfig.blockSizeHorizontal * 100,
              padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 4.5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 44,
                        height: 210,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [Theme
                                  .of(context)
                                  .accentColor, Theme
                                  .of(context)
                                  .accentColor
                                  .withGreen(230)
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.greenAccent.withBlue(220)
                                      .withOpacity(0.2),
                                  spreadRadius: 0.01,
                                  blurRadius: 20,
                                  offset: Offset(0, 10)
                              )
                            ]
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              bottom: 22,
                              child: Text(
                                "Top\n Recommendations",
                                style: TextStyle(
                                    fontSize: SizeConfig.blockSizeVertical * 2,
                                    color: Theme
                                        .of(context)
                                        .scaffoldBackgroundColor,
                                    fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Positioned(
                                top: 22,
                                left: 23,
                                child: Icon(MdiIcons.starOutline,
                                  size: SizeConfig.blockSizeHorizontal * 8,
                                  color: Theme
                                      .of(context)
                                      .scaffoldBackgroundColor,)
                            )
                          ],
                        ),
                      ),

                      Container(
                        width: SizeConfig.blockSizeHorizontal * 44,
                        height: 210,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: isDark
                                ? Color.fromRGBO(61, 61, 61, 1)
                                : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 0.01,
                                  blurRadius: 20,
                                  offset: Offset(0, 10)
                              )
                            ]
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              bottom: 22,
                              child: Text(
                                "Favorite\n Movies",
                                style: TextStyle(
                                    fontSize: SizeConfig.blockSizeVertical * 2,
                                    fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Positioned(
                                top: 22,
                                left: 23,
                                child: Icon(MdiIcons.heartOutline,
                                  size: SizeConfig.blockSizeHorizontal * 8,)
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 2.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 44,
                        height: 210, //SizeConfig.blockSizeVertical*25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: isDark
                                ? Color.fromRGBO(61, 61, 61, 1)
                                : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 0.01,
                                  blurRadius: 20,
                                  offset: Offset(0, 10)
                              )
                            ]
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              bottom: 22,
                              child: Text(
                                "Close\n Friends",
                                style: TextStyle(
                                    fontSize: SizeConfig.blockSizeVertical * 2,
                                    fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Positioned(
                              top: 22,
                              left: 23,
                              child: Icon(MdiIcons.humanGreeting,
                                  size: SizeConfig.blockSizeHorizontal * 8),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 8),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget UserDetails(String number, String lable, bool isDark, IconData icon) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          child: Icon(
            icon,
            size: SizeConfig.blockSizeVertical * 12,
            color: isDark ? Colors.white.withOpacity(0.09) : Colors.grey
                .withOpacity(0.09),
          ),
        ),
        Positioned(
          top: SizeConfig.blockSizeVertical * 3,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  child: Text(
                    number,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.blockSizeVertical * 2.5
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 0.3),
                FittedBox(
                  child: Text(
                    lable,
                    style: TextStyle(
                      fontSize: SizeConfig.blockSizeVertical * 1.8,
                      color: isDark ? Colors.white : Colors.grey,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
