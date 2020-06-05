import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:moviesapp/FirebaseProvider/SignoutProvider.dart';
import 'package:moviesapp/home.dart';
import 'package:moviesapp/pages/edit_profile_page.dart';
import 'package:moviesapp/pages/first_page.dart';
import 'package:moviesapp/pages/shared_movies.dart';
import 'package:moviesapp/size_config/size_config.dart';
import 'package:moviesapp/widgets/personalized_card_widget.dart';


class Profile extends StatefulWidget {
  final String profileId, username, displayName, photoUrl;
  Profile({this.profileId, this.username, this.photoUrl, this.displayName});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>{
  final signOutProvider = SignOutProvider();
  bool isFollowing = false;
  int followerCount = 0;
  int followingCount = 0;
  int sharedMoviesCount = 0;

  bool animate = false;

  void initState(){
    super.initState();
    getFollowers();
    getFollowing();
    getSharedMovies();
    checkIfFollowing();
  }

  getFollowing() async{
    QuerySnapshot snapshot = await followingRef.document(widget.profileId)
        .collection("userFollowing")
        .getDocuments();

    setState(() {
      followingCount = snapshot.documents.length;
    });
  }

  getFollowers() async{
    QuerySnapshot snapshot = await followersRef.document(widget.profileId)
        .collection("userFollowers")
        .getDocuments();

    setState(() {
      followerCount = snapshot.documents.length;
    });
  }

  getSharedMovies() async {
    QuerySnapshot snapshot = await sharedMoviesRef.document(widget.profileId)
        .collection("sharedMovies")
        .getDocuments();

    setState(() {
      sharedMoviesCount = snapshot.documents.length;
    });
  }

  checkIfFollowing() async{
    DocumentSnapshot doc = await followersRef
        .document(widget.profileId)
        .collection("userFollowers")
        .document(currentUID)
        .get();

    setState(() {
      isFollowing = doc.exists;
    });
  }

  Widget currentUserDetailsBuilder(){
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: 220
              ),
              width: SizeConfig.blockSizeHorizontal * 50,
              height: SizeConfig.blockSizeVertical *30,
              child:  widget.photoUrl != null ?
              ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15)),
                child: Hero(
                  tag: widget.username,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: widget.photoUrl,
                  ),
                ),
              )
                  : Container(
                        width: SizeConfig.blockSizeHorizontal*50, height: 220,
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
                      ),
            ),
            SizedBox(width: SizeConfig.blockSizeHorizontal*4,),
            Container(
              padding: EdgeInsets.only(right: 10),
              width: SizeConfig.blockSizeHorizontal*45,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(widget.username == null ? "username N/A":
                  widget.username,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical * 2.8,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  Text(widget.displayName == null ? "no name":
                  widget.displayName,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: SizeConfig.blockSizeVertical * 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
  }

  activityButtonBuilder(onPress, IconData icon){
    return Positioned(
      top: SizeConfig.blockSizeVertical * 5,
      right: 0,
      child: GestureDetector(
        onTap:(){
          if(currentUID == widget.profileId){
            setState(() {
              animate = ! animate;
            });
          }
          onPress();
          },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: SizeConfig.blockSizeHorizontal * 16,
          height: 45,
          margin: animate ?  EdgeInsets.only(right: 180 ) : EdgeInsets.zero,
          decoration: BoxDecoration(
              color: isDark ? Color.fromRGBO(61, 61, 61, 1) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(100),
                bottomLeft: Radius.circular(100),
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 15,
                    offset: Offset(-15, 0)
                )
              ]
          ),
          child:Center(
              child:
              Icon(icon, size: 25,)
          ) ,
        ),
      ),
    );
  }

  activityButtonAction(){
    if(currentUID == widget.profileId){
      return activityButtonBuilder(doNothing, Icons.arrow_back_ios);
    }
    else if(!isFollowing){
      return activityButtonBuilder(handleFollowUser, MdiIcons.accountPlus);
    }
    else if(isFollowing){
      return activityButtonBuilder(handleUnfollowUser, MdiIcons.accountCancel);
    }

  }
  doNothing(){}

  handleUnfollowUser(){
    setState(() {
      isFollowing = false;
    });
    //remove your name on that users followers collection
    followersRef.document(widget.profileId)
        .collection("userFollowers")
        .document(currentUID)
        .get().then((doc){
          if(doc.exists){
            doc.reference.delete()
            .then((value) => print("unfollowed"));
          }
        });


    //remove that user on your following collection
    followingRef.document(currentUID)
        .collection("userFollowing")
        .document(widget.profileId)
        .get().then((doc){
            if(doc.exists){
              doc.reference.delete();
            }
        });
  }

  handleFollowUser(){
    setState(() {
      isFollowing = true;
    });
    //put your name on that users followers collection
    followersRef.document(widget.profileId)
    .collection("userFollowers")
    .document(currentUID)
    .setData({})
    .whenComplete(() => print("following"));


    //put that user on your following collection
    followingRef.document(currentUID)
    .collection("userFollowing")
    .document(widget.profileId)
    .setData({});

    //add activity feed item to notify about the new follower

  }

  Widget drawerBuilder(){
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14),
          bottomLeft: Radius.circular(14),
        ),
          color: isDark ? Color.fromRGBO(61, 61, 61, 1) : Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(2, 0)
            )
          ]
      ),
      width: animate ? SizeConfig.blockSizeHorizontal*45 : 0,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            FittedBox(
              child: RaisedButton(
                onPressed: (){
                    Navigator.push(context,
                      CupertinoPageRoute(
                        builder: (_)=>EditProfile(),
                      ),
                    );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
                color:isDark ? Color.fromRGBO(30, 30, 30, 1): Color.fromRGBO(230, 230, 230, 1),
                elevation: 0,
                padding: EdgeInsets.all(10),
                child: Container(
                  alignment: Alignment.center,
                  width: SizeConfig.blockSizeHorizontal*30,
                  child: Text(
                      "Edit Profile",
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical*3,
                          fontWeight: FontWeight.bold
                      ),
                  ),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical*1,),
            FittedBox(
              child: RaisedButton(
                onPressed: (){signOutProvider.handleSignOut(context);},
                padding: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
                color:isDark ? Color.fromRGBO(30, 30, 30, 1): Color.fromRGBO(230, 230, 230, 1),
                elevation: 0,
                child: Container(
                  alignment: Alignment.center,
                  width: SizeConfig.blockSizeHorizontal*30,
                  child: Text(
                    "Logout",
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical*3,
                        color: Colors.red,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: SizeConfig.blockSizeHorizontal * 100,
                  child: currentUserDetailsBuilder()
                ),

                Container(
                  padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 4),
                  width: SizeConfig.blockSizeHorizontal * 100,
                  height: SizeConfig.blockSizeVertical * 22,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      userDetails(sharedMoviesCount.toString(), "shares", MdiIcons.shareVariant),
                      userDetails(followerCount.toString(), "followers", MdiIcons.starFace),
                      userDetails(followingCount.toString(), "following", MdiIcons.humanGreeting)
                    ],
                  ),
                ),
//                EnhancedVeritcalCard(
//                  context: context,
//                  enableGradient: true,
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: [
//                      Text(
//                        "Rate Us on Play Store",
//                        style: TextStyle(
//                            fontSize: SizeConfig.blockSizeVertical * 2.5,
//                            color: Theme
//                                .of(context)
//                                .scaffoldBackgroundColor,
//                            fontWeight: FontWeight.bold
//                        ),
//                      ),
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        crossAxisAlignment: CrossAxisAlignment.end,
//                        children: [
//                          Icon(MdiIcons.star, color: Theme
//                              .of(context)
//                              .scaffoldBackgroundColor,
//                            size: SizeConfig.blockSizeVertical * 2,),
//                          Icon(MdiIcons.star, color: Theme
//                              .of(context)
//                              .scaffoldBackgroundColor,
//                            size: SizeConfig.blockSizeVertical * 2.2,),
//                          Icon(MdiIcons.star, color: Theme
//                              .of(context)
//                              .scaffoldBackgroundColor,
//                            size: SizeConfig.blockSizeVertical * 2.5,),
//                          Icon(MdiIcons.star, color: Theme
//                              .of(context)
//                              .scaffoldBackgroundColor,
//                            size: SizeConfig.blockSizeVertical * 2.2,),
//                          Icon(MdiIcons.star, color: Theme
//                              .of(context)
//                              .scaffoldBackgroundColor,
//                            size: SizeConfig.blockSizeVertical * 2,),
//                        ],
//                      )
//                    ],
//                  )
//                ),
//              SizedBox(height: SizeConfig.blockSizeVertical * 2.5),
                Container(
                  width: SizeConfig.blockSizeHorizontal * 100,
                  padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 4.5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 42,
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
                                      color: Colors.black.withOpacity(0.12),
                                      spreadRadius: 0.01,
                                      blurRadius: 8,
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
                          EnhancedCard(text: "Favorite Movies", icon: MdiIcons.heartOutline),
                        ],
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 2.5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: (){
                                Navigator.push(context,
                                  CupertinoPageRoute(
                                    builder: (_)=> SharedMovies()
                                  )
                                );
                              },
                              child: EnhancedCard(text: "Shared Movies", icon: MdiIcons.shareVariant)
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
          Container(
            height: SizeConfig.blockSizeVertical*100,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Positioned(
                    top:SizeConfig.blockSizeVertical*5,
                    child: drawerBuilder()
                ),
              ],
            ),
          ),
          activityButtonAction(),
        ],
      ),
    );
  }

  Widget userDetails(String number, String label, IconData icon) {
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
                Text(
                  number,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.blockSizeVertical * 2.5
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 0.3),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: SizeConfig.blockSizeVertical * 1.8,
                    color: isDark ? Colors.white : Colors.grey,
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
