import 'package:latlong2/latlong.dart';

class PostResponse {
  String status;
  List<Post> posts;

  PostResponse({required this.status, required this.posts});

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    List<Post> posts = <Post>[];
    posts = json['posts'].map<Post>((json) => Post.fromJson(json)).toList();
    //reverse posts
    //here delete posts that are isDeleted
    posts.removeWhere((element) => element.isDeleted);
    posts = posts.reversed.toList();
    return PostResponse(
      status: json['status'],
      posts: posts,
    );
  }
}

class Post {
  final int id;
  final String title;
  final String description;
  final LatLng? location;
  final String fromUser;
  final DateTime dateCreated;
  final bool isDeleted;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.fromUser,
    required this.dateCreated,
    required this.isDeleted,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location_lat'] != null && json['location_lng'] != null
          ? LatLng(
              _parseDouble(json['location_lat'])!,
              _parseDouble(json['location_lng'])!,
            )
          : null,
      fromUser: json['from_user'],
      dateCreated: DateTime.parse(json['date_created']),
      isDeleted: json['isDeleted'] == 1,
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else if (value is String) {
      // Replace ',' with '.' and parse as double
      return double.tryParse(value.replaceAll(',', '.'));
    }
    return null;
  }
}
