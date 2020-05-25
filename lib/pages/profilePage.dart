import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moviesapp/login_signup/index.dart';
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
    return Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            backgroundImage: widget.photo != null ? NetworkImage(widget.photo) : AssetImage("images/profile.png"),
            radius: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("welcome ",style: TextStyle(fontSize: 20),),
              Text(widget.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
            ],
          ),
          RaisedButton(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            ),
            color: Colors.red,
            child: Text("Logout", style: TextStyle(color: Colors.white),),
            onPressed: handleSignout,
          )
        ],
      ),
    );
  }
}
