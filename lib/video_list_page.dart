// video_list_page.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models/video_property.dart';

class VideoListPage extends StatefulWidget {
  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class VideoPlayerPage extends StatelessWidget {
  final String videoUrl;

  VideoPlayerPage({required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    // You can use the `video_player` package to play videos
    // https://pub.dev/packages/video_player
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: Text('Video Player will be here'),
      ),
    );
  }
}

class _VideoListPageState extends State<VideoListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Properties for Sale'),
      ),
      body: ListView.builder(
        itemCount: mockVideoProperties.length,
        itemBuilder: (context, index) {
          VideoProperty property = mockVideoProperties[index];
          return Card(
            child: Column(
              children: [
                Image.network(
                  property.thumbnailUrl,
                  height: 300, // Set the height to 300
                  width: MediaQuery.of(context).size.width, // Width as per the device size
                  fit: BoxFit.cover,
                ),
                ListTile(
                  title: Text(property.title),
                  subtitle: Text('${property.propertyType}, ${property.areaName}'), // Display additional details
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerPage(videoUrl: property.videoUrl),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
