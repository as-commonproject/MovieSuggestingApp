import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:moviesapp/pages/users.dart';
import 'package:moviesapp/size_config/size_config.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final search = TextEditingController();
  var listLength = 0;
  var baseUrl = "https://image.tmdb.org/t/p/w500";

  Future<dynamic> getSearchedMovies() async {
    String link =
        "https://api.themoviedb.org/3/search/movie?api_key=3926dff0d2826b265d5396981f90bd1c&query=" + search.text;
    final response = await http.get(Uri.encodeFull(link), headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var movies = data["results"] as List;
      listLength = movies.length - 1;
      return movies;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).scaffoldBackgroundColor == Color.fromRGBO(1, 1, 1, 1);
    SizeConfig().init(context);
    return Container(
      height: SizeConfig.blockSizeVertical*100,
      child: Stack(
        children: [
          Positioned(
            top: 100,
            child: FutureBuilder(
                future: getSearchedMovies(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      width: SizeConfig.blockSizeHorizontal*100,
                      height: SizeConfig.blockSizeVertical*87,
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 6/10,//(SizeConfig.blockSizeHorizontal / SizeConfig.blockSizeVertical),
                        children: List.generate(listLength, (i) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              ),
                            child: Padding(
                              padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*3),
                              child: Column(
                                children: <Widget>[
                                  if (snapshot.data[i]["poster_path"] == null)
                                      Container(
                                        padding: EdgeInsets.all(2),
                                        alignment: Alignment.center,
                                        width: SizeConfig.blockSizeHorizontal*50,
                                        height: 280,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: isDark ? Color.fromRGBO(41, 41, 41, 1).withBlue(100) :Colors.white ,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black.withOpacity(0.3),
                                                  spreadRadius: 3,
                                                  blurRadius: 13,
                                                  offset: Offset(0, 8)
                                              )
                                            ]
                                        ),
                                        child: Text(
                                            snapshot.data[i]['title'],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: SizeConfig.blockSizeHorizontal*6,
                                            ),
                                        ),
                                      )
                                  else
                                    Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black.withOpacity(0.3),
                                                spreadRadius: 3,
                                                blurRadius: 13,
                                                offset: Offset(0, 8)
                                            )
                                          ]
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image(
                                          image: NetworkImage(baseUrl + snapshot.data[i]["poster_path"]),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  }
                  return Users();
                }),
          ),

          Container(
            decoration: BoxDecoration(
              color: isDark ? Color.fromRGBO(41, 41, 41, 1) : Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 0.01,
                    blurRadius: 20,
                    offset: Offset(0, -2))
              ],
            ),
            width: SizeConfig.blockSizeHorizontal * 100,
            height: 120,
            padding: EdgeInsets.only(
              top: SizeConfig.blockSizeVertical * 5,
              left: SizeConfig.blockSizeHorizontal * 6,
              right: SizeConfig.blockSizeHorizontal * 6,
            ),
            child: Theme(
              data: ThemeData(
                primaryColor: Colors.grey.withOpacity(0.1),
                hintColor: Colors.transparent,
              ),
              child: TextField(
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black.withAlpha(500)
                ),
                controller: search,
                onSubmitted: (value) => getSearchedMovies(),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                  hintText: "Search",
                  hintStyle: TextStyle(
                      color:
                      isDark ? Colors.white : Colors.black.withAlpha(500)),
                  filled: true,
                  fillColor: isDark ? Colors.black : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  suffixIcon: Container(
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey : Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(35)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 0.01,
                              blurRadius: 20,
                              offset: Offset(0, -2))
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(MdiIcons.searchWeb,
                          color: Colors.black.withAlpha(500),),
                        onPressed: getSearchedMovies,
                      )),
                ),
              ),
            ),
          ),
          //Search Bar end
        ],
      ),
    );
  }
}
