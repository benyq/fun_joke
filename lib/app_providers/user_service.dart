import 'dart:convert';

import 'package:fun_joke/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {

  static const String _key = "login_model";

  LoginModel? _loginModel;

  static UserService? _instance;

  static UserService get instance => _instance ??= UserService._internal();

  UserService._internal();

  bool get hasToken => _loginModel != null;

  String? get token => _loginModel?.token;

  Future<void> init() async{
    // 获取本地存储的token
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? json = prefs.getString(_key);
    if (json != null) {
      _loginModel = LoginModel.fromJson(jsonDecode(json));
    }
  }

  void update(LoginModel? loginModel) {
    if (loginModel == null) return;
    _loginModel = loginModel;
    save();
  }

  void save() async{
    final loginModel = _loginModel;
    if (loginModel == null) return;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, jsonEncode(loginModel));
  }

}