import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moviesapp/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInProvider{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool isLoggedIn = false;
  SharedPreferences prefs;
  FirebaseUser currentUser;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  String errorMessage = "";

  Future<FirebaseUser> handelSignIn(BuildContext context) async{
    prefs = await SharedPreferences.getInstance();
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(accessToken: googleAuth.accessToken, idToken: null);
    final FirebaseUser firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;
    if(firebaseUser != null){
      final QuerySnapshot result = await Firestore.instance.collection("users").where("id", isEqualTo: firebaseUser.uid).getDocuments();
      List<DocumentSnapshot> documents = result.documents;
      if(documents.length == 0){
        Firestore.instance.collection("users").document(firebaseUser.uid).setData({
          'id': firebaseUser.uid,
          'username': firebaseUser.displayName,
          'photo': firebaseUser.photoUrl,
          'email': firebaseUser.email,
        });

        //Data to local storage
        currentUser = firebaseUser;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('username', currentUser.displayName);
        await prefs.setString('photo', currentUser.photoUrl);
        await prefs.setString('email', currentUser.email);
        await prefs.setBool('isSignedIn', true);
        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (_)=> Home(),
            )
        );
      }
      else{
        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('username', documents[0]['username']);
        await prefs.setString('photo', documents[0]['photo']);
        await prefs.setString('email', documents[0]['email']);
        await prefs.setBool('isSignedIn', true);

        Navigator.pushReplacement(context,
            CupertinoPageRoute(
                builder: (_)=> Home()
            )
        );
      }
    }
    return firebaseUser;
  }


  Future<String> emailSignIn(BuildContext context, String userEmail, String userPassword) async{
    try{
      AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: userEmail, password: userPassword);
      FirebaseUser firebaseUser = result.user;
      if(firebaseUser != null){
        await prefs.setString('id', firebaseUser.uid);
        await prefs.setString('username', firebaseUser.displayName);
        await prefs.setString('email', firebaseUser.email);
        await prefs.setBool('isSignedIn', true);

        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (_)=> Home(),
            )
        );
      }
    }
    catch(error){
      switch (error.code) {
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Anonymous accounts are not enabled";
          return errorMessage;

        case "ERROR_WEAK_PASSWORD":
          errorMessage = "Your password is too weak";
          return errorMessage;

        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email is invalid";
          return errorMessage;

        case "ERROR_EMAIL_ALREADY_IN_USE":
          errorMessage = "Email is already in use on different account";
          return errorMessage;

        case "ERROR_INVALID_CREDENTIAL":
          errorMessage = "Your email is invalid";
          return errorMessage;

        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Wrong Password";
          return errorMessage;

        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User Not Found";
          return errorMessage;

        default:
          errorMessage = "An undefined Error happened.";
          return errorMessage;
      }
    }
    return "All Done";
  }


  alreadySignedIn(BuildContext context)async{
    prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool('isSignedIn');
    if(loggedIn){
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (_)=> Home(),
          )
      );
    }
  }

  Future<String> getCurrentUserId()async{
    prefs = await SharedPreferences.getInstance();
    return prefs.getString('id');
  }

}