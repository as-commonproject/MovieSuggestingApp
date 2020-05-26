import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moviesapp/pages/profilePage.dart';
import 'package:moviesapp/size_config/size_config.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  List UserList = [];

  getAllUsers() async{
    print("hello");
    CollectionReference col = Firestore.instance.collection("users");
    QuerySnapshot snaps = await col.getDocuments();
    for(int i=0; i<snaps.documents.length; i++){
      UserList.add(snaps.documents[i].data["username"]);
      print(snaps.documents[i].data["username"]);
    }
  }

  void initState(){
    super.initState();
    getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance.collection("users").snapshots(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Container(
              width: SizeConfig.blockSizeHorizontal*100,
              height: SizeConfig.blockSizeVertical*87,
              child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: EdgeInsets.all(15.0),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context,
                          CupertinoPageRoute(
                            builder: (_)=>Profile(name: snapshot.data.documents[index]["username"], photo: snapshot.data.documents[index]["photo"],)
                          )
                          );
                        },
                        child: Container(
                            alignment: Alignment.center,
                            width: SizeConfig.blockSizeHorizontal * 80,
                            height: SizeConfig.blockSizeVertical * 11,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(14)),
                                gradient: LinearGradient(
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                  colors: [Theme.of(context).accentColor, Theme.of(context).accentColor.withGreen(230)
                                  ],
                                ),
                            ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              snapshot.data.documents[index]["photo"]==null ? Container(width: 100,):
                              Image(
                                image: NetworkImage(snapshot.data.documents[index]["photo"]),
                              ),
                              Text( snapshot.data.documents[index]["username"]== null ? "username not found": snapshot.data.documents[index]["username"]),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
