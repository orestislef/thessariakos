import 'package:flutter/material.dart';
import 'package:thessariakos/helpers/device_id_helper.dart';
import 'package:thessariakos/models/responses/post_response.dart';
import 'package:thessariakos/widgets/post/post_details.dart';

class PostItem extends StatelessWidget {
  final Post post;

  const PostItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4.0,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(post.title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            )),
        subtitle: Text(post.description),
        trailing: Icon(Icons.adaptive.arrow_forward),
        enableFeedback: true,
        onTap: () {
          _navigateToPostDetails(context, post);
        },
      ),
    );
  }

  void _navigateToPostDetails(BuildContext context, Post post) async {
    String deviceId = await DeviceIdHelper.getDeviceId();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetails(
          post: post,
          deviceId: deviceId,
        ),
      ),
    );
  }
}
