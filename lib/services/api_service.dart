import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutterbloc/datamodels/post.dart';
import 'package:flutterbloc/datamodels/user.dart';

class ApiService {

  Future<String?> getToken(String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return 'some-fake-token';
    } catch (e) {
      return null;
    }
  }

  Future<User?> getUser() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      const json = '{"id":1,"name":"Leanne Graham","email":"Sincere@april.biz"}';
      return User.fromJson(jsonDecode(json));
    } catch (e) {
      return null;
    }
  }

  Future<List<Post>> getPosts() async {
    try {
      final res = await Dio().get('https://jsonplaceholder.typicode.com/posts');
      return (res.data as List).map((data) => Post.fromJson(data)).toList();
    } catch (e) {
      print(e);
      return <Post>[];
    }
  }
}