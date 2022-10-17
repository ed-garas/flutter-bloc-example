import 'dart:async';

import 'package:flutterbloc/datamodels/user.dart';
import 'package:flutterbloc/services/api_service.dart';
import 'package:flutterbloc/services/locator.dart';
import 'package:get_storage/get_storage.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final ApiService _api = locator<ApiService>();

  final _controller = StreamController<AuthenticationStatus>();

  static const String tokenKey = 'token';
  static const String userKey = 'user';

  Future<void> setToken(String token) async {
    return GetStorage().write(tokenKey, token);
  }

  String? getToken(){
    try {
      return GetStorage().read(tokenKey);
    } catch (e) {
      return null;
    }
  }

  Future<void> setUser(User user) async {
    return GetStorage().write(userKey, user.toJson());
  }

  User? getUser(){
    try {
      return User.fromJson(GetStorage().read(userKey));
    } catch (e) {
      return null;
    }
  }

  bool isAuthenticated() {
    return getToken() != null && getUser() != null;
  }

  Stream<AuthenticationStatus> get status async* {
    print('HERE ${DateTime.now()}');
    // await Future<void>.delayed(const Duration(seconds: 1));
    if (isAuthenticated()) {
      yield AuthenticationStatus.authenticated;
    } else {
      yield AuthenticationStatus.unauthenticated;
    }
    yield* _controller.stream;
  }


  Future<User?> loginWithEmail(String email, String password) async {
    final token = await _api.getToken(email, password);
    if (token == null) {
      _controller.add(AuthenticationStatus.unauthenticated);
      return null;
    }
    // Save to local storage
    // that api service could use it
    await setToken(token);

    final user = await _api.getUser();
    if (user == null) {
      _controller.add(AuthenticationStatus.unauthenticated);
      return null;
    }
    await setUser(user);
    _controller.add(AuthenticationStatus.authenticated);
    return user;
  }

  Future<User?> fetchUser() async {
    try {
      return await _api.getUser();
    } catch (e) {
      return null;
    }
  }

  Future<bool> logout() async {
    await GetStorage().remove(tokenKey);
    await GetStorage().remove(userKey);
    _controller.add(AuthenticationStatus.unauthenticated);
    return !isAuthenticated();
  }


  void dispose() => _controller.close();
}


class UnauthenticatedException implements Exception {
  final String? message;
  UnauthenticatedException(this.message);
}