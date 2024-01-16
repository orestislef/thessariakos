import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:thessariakos/API/api.dart';
import 'package:thessariakos/models/responses/post_response.dart';
import 'package:thessariakos/widgets/post/post_item.dart';

class PostsList extends StatefulWidget {
  const PostsList({super.key});

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  late Timer _timer;
  late Future<PostResponse> _futureData;
  bool isFirstTimeLoading = true;

  @override
  void initState() {
    super.initState();

    // Initialize the future data
    _futureData = Api.getPosts();

    // Start a timer to fetch data every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      // Fetch data and update the UI
      _fetchData();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  // Function to fetch data and update the UI
  void _fetchData() {
    setState(() {
      _futureData = Api.getPosts();
      isFirstTimeLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PostResponse>(
      future: _futureData,
      builder: (context, postResponse) {
        if (postResponse.connectionState == ConnectionState.waiting &&
            isFirstTimeLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (postResponse.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Error: ${postResponse.error}'),
          );
        } else {
          final posts = postResponse.data!.posts;
          if (posts.isEmpty) {
            return Center(
              child: Text(
                'no_recent_posts'.tr(),
                style: TextStyle(fontSize: 20.0, color: Colors.grey[600]),
              ),
            );
          }

          return Scrollbar(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostItem(post: posts[index]);
              },
            ),
          );
        }
      },
    );
  }
}
