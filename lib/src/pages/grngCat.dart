import 'package:flutter/material.dart';
import '../widgets/eachPost.dart';
import 'package:http/http.dart' as http; // http requ
import 'dart:async';
import 'dart:convert'; //COnvett Json
import '../widgets/catWidgets.dart';
import '../config.dart';
import 'dart:core';
import 'dart:collection';

List cachedPosts ; 

class GrngCat extends StatefulWidget {
  _GrngCatState createState() => _GrngCatState();
}

class _GrngCatState extends State<GrngCat> {
  final String apiUrl = mainApiUrl ;
  List posts;
  String categoryId = kurdistanId ;
 String hawalPerPage = perPage;

  //List kurdistanCatPosts;

  // Function to fetch list of posts
  Future<String> getPosts() async {
    if (!cachedPosts.contains(posts)){

        var res = await http.get(
                Uri.encodeFull(apiUrl +
                 "posts?_embed&categories=$categoryId&per_page=$hawalPerPage"), 
                headers: {"Accept": "application/json"});
 setState(() {
              var resBody = json.decode(res.body);
              posts = resBody;
              cachedPosts = posts ;
              //posts = database resbody if listens and found new then reloads
             },); //setstate
            
            
    
    }
    return "Success!";
  }
    
    void initState() {
          super.initState();
          this.getPosts();
          //this.getKurdistanCatPosts(); //have to go to its own page
        }

  

  @override
  Widget build(BuildContext context) {
    return new Directionality(
      //where i add Dictio for rtl  entire home page , i wraped every thing into this
      textDirection: TextDirection.rtl, // RTL
      child: new Scaffold(
        // Scaffold az a Child, it takes only one child
        appBar: AppBar(
            title: Text("هه‌واڵی كوردستان"),
            backgroundColor: Colors.blueAccent),

        body: 
          RefreshIndicator(
            onRefresh: getPosts,
            //there was an error when i used getPosts(); so i removed prantisice
            
          child: ListView.builder(
            itemCount: posts == null ? 0 : posts.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  Card(
                    child: Column(
                      children: <Widget>[

                           Container( 
                             
                             child: hawalImage(posts, index),
                             
                           ), 

                      
                        new Padding(
                          padding: EdgeInsets.all(5.0),
                          child: new ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (context) =>
                                      HawalnirPost(post: posts[index]),
                                ),
                              );
                            },
                            title: hawalTitle(posts, index),

                            subtitle: new Row(
                              children: <Widget>[
                                Expanded(
                                  child: hawalAuthor(posts, index),
                                ),
                                Expanded(
                                  child: hawalDate(posts, index),
                                ),
                              ],
                            ),

                          ),
                        ),
                        new ButtonTheme.bar(
                          child: hawalBtnBar(),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}