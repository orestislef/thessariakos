import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:thessariakos/helpers/language_helper.dart';
import 'package:thessariakos/models/responses/post_response.dart';
import 'package:thessariakos/widgets/map_view.dart';

class PostDetails extends StatelessWidget {
  final Post post;

  const PostDetails({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat.yMMMMd(LanguageHelper.getLanguageUsedInApp(context))
            .add_jm()
            .format(post.dateCreated);

    bool hasLocationData = post.location != null &&
        post.location!.latitude != 0.0 &&
        post.location!.longitude != 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          post.title,
          style: const TextStyle(fontSize: 24.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SelectableText(
                        post.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 24.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                hasLocationData
                    ? MapView(latLng: post.location!)
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
