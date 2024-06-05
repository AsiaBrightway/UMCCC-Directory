

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier{
  String _token = '';
  int _role = 0;
  String _userId = '';

  String get userId => _userId;
  String get token => _token;
  int get role => _role;

  Future<void> loadTokenAndRoleAndId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
    _role = prefs.getInt('role') ?? 0;
    _userId = prefs.getString('userId') ?? '';
    notifyListeners();
  }

  Future<void> setTokenAndRoleAndUserId(String token,int role,String userId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setInt('role', role);
    await prefs.setString('userId', userId);
    _token = token;
    _role = role;
    _userId = userId;
    notifyListeners();
  }

  Future<void> clearTokenAndRoleAndId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
    await prefs.remove('userId');
    _token = '';
    _role = 0;
    _userId = '';
    notifyListeners();
  }
}