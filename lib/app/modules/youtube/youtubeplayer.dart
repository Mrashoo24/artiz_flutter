import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/modules/youtube/youtubevideoplayer.dart';
import 'package:youtube_api/youtube_api.dart';

class YoutubeScreen extends StatefulWidget {
  @override
  _YoutubeScreenState createState() => _YoutubeScreenState();
}

class _YoutubeScreenState extends State<YoutubeScreen> {
  static String key = "AIzaSyDfem6OBe8mDWDt6aXo6jgyRIsvgns0nUo";

  YoutubeAPI youtube = YoutubeAPI(key);
  List<YouTubeVideo> videoResult = [];
  Timer _debounce;

  String query = "Photography";



  Future<List<YouTubeVideo>> callAPI(String query1) async {

    videoResult = await youtube.search(
      query1,
      order: 'relevance',
      videoDuration: 'any',
    );
    videoResult = await youtube.nextPage();


    print('responseyoutube = ${videoResult.length}');
    return videoResult;
  }
  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // callAPI(query);
    print('hello');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text('Youtube API'),
      ),
      body: FutureBuilder
        <List<YouTubeVideo>>(
        future: callAPI(query),
        builder: (context, snapshot) {

          if(!snapshot.hasData){
            return Center(
              child: Container(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(),
              ),
            );
          }
var videoResult = snapshot.requireData;
          return Column(
            children: [
            TextFormField(
            validator: (value) => value.isEmpty ? 'Field is mandatory' : null ,
            decoration: InputDecoration(hintText: 'Search',label: Text('Search'),filled: true,fillColor: Colors.white),
              onChanged: (value){
                if (_debounce?.isActive ?? false) _debounce.cancel();
                _debounce = Timer(const Duration(milliseconds: 300), () {

                  setState(() {
                    query= value;
                  });

                });
              },
          ),
              Expanded(
                child: ListView.builder(
                  itemCount: videoResult.length,
                  itemBuilder: (context,index){
                    return listItem(videoResult[index]);
                  },
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget listItem(YouTubeVideo video) {
    return Card(
      child: InkWell(
        onTap: (){
          Get.to(YoutubeVideoPlayer(ids: [video.id],video: video,));
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 7.0),
          padding: EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Image.network(
                  video.thumbnail.small.url ?? '',
                  width: 120.0,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      video.title,
                      softWrap: true,
                      style: TextStyle(fontSize: 10.0),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 3.0),
                      child: Text(
                        video.channelTitle,
                        softWrap: true,
                        style: TextStyle(fontWeight: FontWeight.bold),
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
}