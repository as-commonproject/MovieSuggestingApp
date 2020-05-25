import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moviesapp/login_signup/index.dart';
import 'package:moviesapp/size_config/size_config.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String errorMessage = "";
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  File _image;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  createAccount() async{
    setState(() {
      errorMessage = "Creating account, hang on for a few seconds....";
    });
    try{
      AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: password.text);
      if(result != null){
        UserUpdateInfo updateInfo = UserUpdateInfo();
        updateInfo.displayName = firstName.text+" "+lastName.text;
        FirebaseUser firebaseUser = result.user;

        if(firebaseUser != null){
          await firebaseUser.updateProfile(updateInfo);
          await firebaseUser.reload();
          final QuerySnapshot result = await Firestore.instance.collection("users").where("id", isEqualTo: firebaseUser.uid).getDocuments();
          List<DocumentSnapshot> documents = result.documents;
          if(documents.length == 0){
            Firestore.instance.collection("users").document(firebaseUser.uid).setData({
              'id': firebaseUser.uid,
              'username': firstName.text+" "+lastName.text,
              'email': firebaseUser.email,
            });
          }
        }
        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
                builder: (_)=>Index(title: "Successfully Created Account")
            )
        );
      }
    }
    catch(error){
      switch (error.code) {
        case "ERROR_OPERATION_NOT_ALLOWED":
          setState(() {
            errorMessage = "Anonymous accounts are not enabled";
          });
          break;
        case "ERROR_WEAK_PASSWORD":
          setState(() {
            errorMessage = "Your password is too weak";
          });
          break;
        case "ERROR_INVALID_EMAIL":
          setState(() {
            errorMessage = "Your email is invalid";
          });
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          setState(() {
            errorMessage = "Email is already in use on different account";
          });
          break;
        case "ERROR_INVALID_CREDENTIAL":
          setState(() {
            errorMessage = "Your email is invalid";
          });
          break;

        default:
          errorMessage = "An undefined Error happened.";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: SizeConfig.blockSizeVertical*100,
          child: Stack(
              children: [
                _image == null
                ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                        width: SizeConfig.blockSizeHorizontal*100,
                        height: SizeConfig.blockSizeVertical*38,
                        child:Image(
                          image: AssetImage("images/Citynight.png"),
                          fit: BoxFit.fill,
                        )
                    ),
                    Positioned(
                      top: SizeConfig.blockSizeVertical*10,
                      child: Container(
                        child: Text(
                          "Hey there!",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.blockSizeVertical*2.4
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: SizeConfig.blockSizeVertical*13,
                      child: Container(
                        child: Text(
                          "Create your account".toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: SizeConfig.blockSizeVertical*3
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: SizeConfig.blockSizeVertical*4,
                      child: Container(
                          alignment: Alignment.topLeft,
                          width: SizeConfig.blockSizeHorizontal*100,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                      ),
                    ),
                  ],
                )
                : Image.file(_image),
//          FloatingActionButton(
//            elevation: 1,
//            onPressed: getImage,
//            tooltip: 'Pick Image',
//            child: Icon(Icons.add_a_photo),
//          ),

               Positioned(
                 top: SizeConfig.blockSizeVertical*35,
                 child: Container(
                   height: SizeConfig.blockSizeVertical*70,
                     decoration: BoxDecoration(
                         color: Theme.of(context).scaffoldBackgroundColor,
                         borderRadius: BorderRadius.only(
                             topLeft: Radius.circular(12), topRight: Radius.circular(12)
                         )
                     ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*8),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Fill in the details below to Sign up",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: SizeConfig.blockSizeVertical*2
                            ),
                          ),
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical*2,),
                         Container(
                           width: SizeConfig.blockSizeHorizontal*100,
                           child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                commonTF('First Name : ', false, TextInputType.text, firstName, firstName.text.length == 0, "Name Cannot be Empty"),
                                commonTF('Last Name : ', false, TextInputType.text, lastName, lastName.text.length == 0, "Last Name Cannot be Empty"),
                                commonTF('Email ID : ', false, TextInputType.emailAddress, email, !email.text.contains("@"), "Invalid Email, missing @"),
                                commonTF('Password : ', true, TextInputType.visiblePassword, password, password.text.length < 8, "Password must be at least 8 characters long"),
                              ],
                            ),
                        ),
                         ) ,

                        Container(
                          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*6),
                          width: SizeConfig.blockSizeHorizontal * 100,
                          child: RaisedButton(
                            elevation: 0,
                            padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical*1.5,
                              bottom: SizeConfig.blockSizeVertical*1.5,
                              left: SizeConfig.blockSizeHorizontal*10,
                              right: SizeConfig.blockSizeHorizontal*10,
                            ),
                            color: Color.fromRGBO(253, 1, 86, 1),
                            onPressed: (){
                                if(_formKey.currentState.validate()){
                                      createAccount();
                                }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            ),
                            child: Text("Signup", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: SizeConfig.blockSizeVertical*2),),
                          ),
                        ),
                        Text(errorMessage==""? "" : errorMessage),
                      ],
                    )
                  ),
               ),
          ]),
        )
      ),
    );
  }


  Padding commonTF(String lblTxt, bool txtObscure, TextInputType typeOfKeyboard, TextEditingController controller, bool condition, String error) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal*6,
          right: SizeConfig.blockSizeHorizontal*6,
          top: SizeConfig.blockSizeVertical*1
      ),
      child: Theme(
        data: ThemeData(
          primaryColor: Color.fromRGBO(240, 242, 255, 1),
          hintColor: Color.fromRGBO(240, 242, 255, 1),
        ),
        child: Container(
          constraints: BoxConstraints(maxHeight: SizeConfig.blockSizeVertical * 7),
          child: TextFormField(
            validator: (value) => !condition ? null : error,
            controller: controller,
            obscureText: txtObscure,
            enableSuggestions: true,
            cursorColor: Color.fromRGBO(43, 53, 125, 1),
            keyboardType: typeOfKeyboard,
            textAlign: TextAlign.end,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
              ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*4),
                  child: Text(
                    lblTxt,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.blockSizeVertical*1.8,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                filled: true,
                fillColor: Color.fromRGBO(240, 242, 255, 1),
            ),
            style: TextStyle(
                color: Colors.black,
                height: 1,
                fontWeight: FontWeight.w600,
                fontSize: SizeConfig.blockSizeVertical * 1.9),
          ),
        ),
      ),
    );
  }

}
