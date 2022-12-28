import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'newsmodel.dart';
import 'package:http/http.dart' as http;

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(title: Text('News')),
      body: FutureBuilder<NewsModel>(
        future: getNews(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(child: Center(child: CircularProgressIndicator(),),);
          }
          return ListView.builder(
            itemCount: snapshot.requireData.results.length,
            itemBuilder: (context,index){



            Results articles =   snapshot.requireData.results[index];
              return listItem(articles);
            },
          );
        }
      ),
    );
  }



  Widget listItem(Results articles) {
    // print( articles.imageUrl);

    return Card(
      child: InkWell(
        onTap: (){
          // Get.to(YoutubeVideoPlayer(ids: [video.id],video: video,));
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 7.0),
          padding: EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              articles.imageUrl == null ? SizedBox() : Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Image.network(
                  articles.imageUrl ?? '',
                  width: 120.0,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      articles.title,
                      softWrap: true,
                      style: TextStyle(fontSize: 14.0),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 3.0),
                      child: Text(
                        articles.pubDate,
                        softWrap: true,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 3.0),
                      child: InkWell(
                        onTap: (){
                          launchUrlString(articles.link);

                        },
                        child: Text(
                          articles.link,
                          softWrap: true,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  
  Future<NewsModel> getNews() async {
  http.Response response =  await  http.get(Uri.parse('https://newsdata.io/api/1/news?apikey=pub_10291503bbf13466366c6737988e8308a2600&country=in&q=photos&language=en')
    // ,headers: {
    //   'x-api-key' : 'nnJuGojVy3fdYMkW8TtqdvIATdkFDNrz8TSp1ma4MDM'
    //     }
    );

  if(response.statusCode == 200){

   return NewsModel.fromJson(jsonDecode(response.body));
  }else{
    return null;
  }

  }

}
