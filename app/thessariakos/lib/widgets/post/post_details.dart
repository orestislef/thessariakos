import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:thessariakos/API/api.dart';
import 'package:thessariakos/helpers/language_helper.dart';
import 'package:thessariakos/models/responses/post_response.dart';
import 'package:thessariakos/widgets/map_view.dart';

class PostDetails extends StatefulWidget {
  final Post post;
  final String deviceId;

  const PostDetails({super.key, required this.post, required this.deviceId});

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  bool isDeleting = false;

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat.yMMMMd(LanguageHelper.getLanguageUsedInApp(context))
            .add_jm()
            .format(widget.post.dateCreated);

    bool hasLocationData = widget.post.location != null &&
        widget.post.location!.latitude != 0.0 &&
        widget.post.location!.longitude != 0.0;

    bool isMyPost = widget.post.fromUser == widget.deviceId;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.post.title,
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
                        widget.post.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 24.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                hasLocationData
                    ? MapView(latLng: widget.post.location!)
                    : const SizedBox(),
                const SizedBox(height: 16.0),
                isMyPost
                    ? Column(
                        children: [
                          Text('this_post_is_yours'.tr()),
                          const SizedBox(height: 16.0),
                          isDeleting
                              ? const LinearProgressIndicator()
                              : ElevatedButton(
                                  onPressed: () => _deletePost(context),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.delete),
                                      const SizedBox(width: 10.0),
                                      Text('delete'.tr()),
                                    ],
                                  ),
                                ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deletePost(BuildContext context) async {
    bool isOk = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('delete_post'.tr()),
        content: Text('are_you_sure'.tr()),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('delete'.tr()),
          ),
        ],
      ),
    );

    if (!isOk) {
      return;
    }

    setState(() {
      isDeleting = true;
    });

    bool isDeleted = await Api.deletePost(widget.post.id);

    setState(() {
      isDeleting = false;
    });

    if (isDeleted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('post_deleted'.tr()),
        duration: const Duration(seconds: 2),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('error_deleting_post'.tr()),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
      ));
    }
  }
}
