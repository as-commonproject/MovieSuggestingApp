import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:moviesapp/FirebaseProvider/signInProvider.dart';
import 'package:moviesapp/login_signup/signup.dart';
import 'package:moviesapp/size_config/size_config.dart';

class Index extends StatefulWidget {
  final String title;

  Index({
   this.title
  });
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  String errorMessage = "";
  final firebaseProvider = SignInProvider();


  void initState(){
    super.initState();
    firebaseProvider.alreadySignedIn(context);
  }


  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return  Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: SizeConfig.blockSizeVertical*100,
          child: Stack(
            children: [
              Stack(
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
                        widget.title == null ?
                        "Welcome to" : widget.title,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.blockSizeVertical*2.4
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: SizeConfig.blockSizeVertical*12.5,
                    child: Container(
                      child: Text(
                        widget.title == null ?
                        "Movies Hub".toUpperCase() : "",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: SizeConfig.blockSizeVertical*6
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Positioned(
                top: SizeConfig.blockSizeVertical*35,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12), topRight: Radius.circular(12)
                    )
                  ),
                  child: Column(
                    children: [
                      //Hey Text Start
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                              topLeft: Radius.circular(8),
                            )
                        ),
                        padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*6),
                        width: SizeConfig.blockSizeHorizontal*100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                "Hey!",
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: SizeConfig.blockSizeVertical*4.5
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "Fill in the details below to login",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: SizeConfig.blockSizeVertical*2
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Hey Text End


                      //TextField start
                      Theme(
                        data: ThemeData(
                          primaryColor: Color.fromRGBO(240, 242, 255, 1),
                          hintColor: Color.fromRGBO(240, 242, 255, 1),
                        ),
                        child: Container(
                          padding: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal*6,
                              right: SizeConfig.blockSizeHorizontal*6,
                              top: SizeConfig.blockSizeVertical*1
                          ),
                          width: SizeConfig.blockSizeHorizontal*100,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    maxHeight: SizeConfig.blockSizeVertical*7,
                                  ),
                                  child: TextFormField(
                                    validator: (value) => (EmailValidator.validate(email.text)) ? "" : "Invalid email",
                                    controller: email,
                                    enableSuggestions: true,
                                    cursorColor: Color.fromRGBO(43, 53, 125, 1),
                                    keyboardType: TextInputType.emailAddress,
                                    textAlign: TextAlign.end,
                                    decoration: InputDecoration(
                                        alignLabelWithHint: true,
                                        prefixIcon: Padding(
                                          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*3.5),
                                          child: Text(
                                            "Email :",
                                            style:
                                            TextStyle(
                                                color: Colors.black,
                                                fontSize: SizeConfig.blockSizeVertical*1.8,
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Color.fromRGBO(240, 242, 255, 1),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(13),
                                        )
                                    ),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: SizeConfig.blockSizeVertical*1.9
                                    ),
                                  ),
                                ),
                                SizedBox(height: SizeConfig.blockSizeVertical*2,),
                                Container(
                                  constraints: BoxConstraints(
                                      maxHeight: SizeConfig.blockSizeVertical*7
                                  ),
                                  child: TextFormField(
                                    validator: (value) => password.text.length < 8 ? "Password must contain atleast 8 characters" : "",
                                    controller: password,
                                    obscureText: true,
                                    enableSuggestions: true,
                                    cursorColor: Color.fromRGBO(43, 53, 125, 1),
                                    keyboardType: TextInputType.visiblePassword,
                                    textAlign: TextAlign.end,
                                    decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*3.5),
                                          child: Text(
                                            "Password :",
                                            style:
                                            TextStyle(
                                                color: Colors.black,
                                                fontSize: SizeConfig.blockSizeVertical*1.8,
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Color.fromRGBO(240, 242, 255, 1),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(13),
                                        )
                                    ),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: SizeConfig.blockSizeVertical*1.9,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //TextField End



                      //login button start
                      Container(
                        padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*6),
                        width: SizeConfig.blockSizeHorizontal*100,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Center(
                                  child: Container(
                                    child: Text(
                                      "forgot password?",
                                      style: TextStyle(
                                          fontSize: SizeConfig.blockSizeVertical*2
                                      ),
                                    ),
                                  ),
                                ),

                                RaisedButton(
                                  color: Theme.of(context).accentColor,
                                  elevation: 0,
                                  padding: EdgeInsets.only(
                                    top: SizeConfig.blockSizeVertical*1.5,
                                    bottom: SizeConfig.blockSizeVertical*1.5,
                                    left: SizeConfig.blockSizeHorizontal*10,
                                    right: SizeConfig.blockSizeHorizontal*10,
                                  ),
                                  onPressed: ()async{
                                    if(!_formKey.currentState.validate()) {
                                        setState(() {
                                          errorMessage = "Signing you in....";
                                        });
                                        errorMessage = await firebaseProvider.emailSignIn(context, email.text, password.text);
                                        setState(() {});
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)
                                  ),
                                  child: Text("Login", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: SizeConfig.blockSizeVertical*2),),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: SizeConfig.blockSizeVertical*2,
                            ),
                            Divider(
                              color: Colors.grey,
                              height: 1,
                              indent: 50,
                              endIndent: 50,
                            ),
                            SizedBox(
                              height: SizeConfig.blockSizeVertical*2,
                            ),
                            Container(
                                constraints: BoxConstraints(
                                    maxHeight: SizeConfig.blockSizeVertical*5
                                ),
                                child: GoogleSignInButton(
                                  onPressed: (){
                                    firebaseProvider.handelSignIn(context);
                                  },
                                  darkMode: Theme.of(context).scaffoldBackgroundColor == Color.fromRGBO(1, 1, 1, 1),
                                  textStyle: TextStyle(
                                      fontSize: SizeConfig.blockSizeVertical*1.8
                                  ),
                                  borderRadius: 5,
                                )
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical*1.5,),
                            Text(errorMessage)
                          ],
                        ),
                      ),
                      //Login button end
                    ],
                  ),
                ),
              ),

              Positioned(
                bottom: 0,
                child: Container(
                  width: SizeConfig.blockSizeHorizontal*100,
                  padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.blockSizeVertical*1.8
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (_)=> SignUpPage()
                                  )
                              );
                            },
                            child: Text(
                              "Signup Now",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).accentColor,
                                  fontSize: SizeConfig.blockSizeVertical*1.8
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),


              //person profile image start
              Positioned(
                top: SizeConfig.blockSizeVertical*29,
                right: SizeConfig.blockSizeHorizontal*5,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(500),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(500),
                    child: Container(
                      color: Colors.grey.withOpacity(0.3),
                      child: Image(
                        image: AssetImage("images/profile.png"),
                        width: SizeConfig.blockSizeHorizontal*22,
                      ),
                    ),
                  ),
                ),
              ),
              //person profile image end
            ],
          ),
        ),
      ),
    );
  }
}
