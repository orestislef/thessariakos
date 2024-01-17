import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:thessariakos/models/responses/info_response.dart';
import 'package:thessariakos/models/responses/post_response.dart';

class Api {
  static String baseUrl =
      'http://192.168.24.21:8080/thessaraikos/api.php';

  static Future<bool> deletePost(int postId) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'action': 'delete_post',
          'id': postId.toString(),
        },
      );

      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        if (kDebugMode) {
          print('Post deleted successfully');
        }
        return true;
      }

      if (kDebugMode) {
        print('Error deleting post: ${data['message']}');
      }

      return false;
    } catch (error) {
      if (kDebugMode) {
        print('Error deleting post: $error');
      }
    }

    return false;
  }

  static Future<InfoResponse> getInfo() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?action=get_info'));

      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        if (kDebugMode) {
          print('Info fetched successfully');
        }
        return InfoResponse.fromJson(data);
      }

      if (kDebugMode) {
        print('Error fetching info: ${data['message']}');
      }

      return InfoResponse.fromJson(data);
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching info: $error');
      }
    }

    return InfoResponse(status: 'error', infos: []);
  }

  static Future<bool> createUser({
    required String uniqueId,
    required String name,
    required double currentLocationLat,
    required double currentLocationLng,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'action': 'create_user',
          'unique_id': uniqueId,
          'name': name,
          'current_location_lat': currentLocationLat.toString(),
          'current_location_lng': currentLocationLng.toString(),
        },
      );

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        if (kDebugMode) {
          print('User created successfully');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('Error creating user: ${data['message']}');
        }
        return false;
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error creating user: $error');
      }
      return false;
    }
  }

  static Future<bool> createPost({
    required String title,
    required String description,
    required double locationLat,
    required double locationLng,
    required String fromUser,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'action': 'create_post',
          'title': title,
          'description': description,
          'location_lat': locationLat.toString(),
          'location_lng': locationLng.toString(),
          'from_user': fromUser,
        },
      );

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        if (kDebugMode) {
          print('Post created successfully');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('Error creating post: ${data['message']}');
        }
        return false;
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error creating post: $error');
      }
      return false;
    }
  }

  static Future<void> updateLocation({
    required String uniqueId,
    required double currentLocationLat,
    required double currentLocationLng,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'action': 'update_user_location',
          'unique_id': uniqueId,
          'current_location_lat': currentLocationLat.toString(),
          'current_location_lng': currentLocationLng.toString(),
        },
      );

      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        if (kDebugMode) {
          print('User location updated successfully');
        }
      } else {
        if (kDebugMode) {
          print('Error updating user location: ${data['message']}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error updating user location: $error');
      }
    }
  }

  //NOT IN USE
  static Future<PostResponse> getPostsByLastID(int postLastId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl?action=get_posts&last_id=$postLastId'));

      final data = json.decode(response.body);
      return PostResponse.fromJson(data);
    } catch (error) {
      if (kDebugMode) {
        print('Error retrieving posts: $error');
      }
      return PostResponse(status: 'error', posts: []);
    }
  }

  static Future<PostResponse> getPosts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?action=get_posts'));

      final data = json.decode(response.body);
      return PostResponse.fromJson(data);
    } catch (error) {
      if (kDebugMode) {
        print('Error retrieving posts: $error');
      }
      return PostResponse(status: 'error', posts: []);
    }
  }
}
