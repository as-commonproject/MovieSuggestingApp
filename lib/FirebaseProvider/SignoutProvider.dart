import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moviesapp/login_signup/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignOutProvider{
  GoogleSignIn _googleSignIn = GoogleSignIn();
  SharedPreferences prefs;

  Future<Null> handleSignOut(BuildContext context) async{
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


}