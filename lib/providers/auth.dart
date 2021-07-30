import 'dart:async';
import 'dart:convert';
// import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopapp/providers/http_exception.dart';

class Auth with ChangeNotifier {
  var _token;
  var _expiryDate;
  var _userId;
  final tokenKey = "token";
  var userIdKey = "userId";
  var expiryDateKey = "expiryDate";
  // Timer _authTimer = Timer(Duration(seconds: 0), () {});
  bool get isAuth {
    print("A" + token.toString().isNotEmpty.toString());
    // print("B" + _token);
    return _token != null;
  }

  String get userId {
    return _userId.toString();
  }

  String get token {
    try {
      if (_expiryDate != "") {
        DateTime expdate = DateTime.parse(_expiryDate);
        if (expdate.isAfter(DateTime.now()) && _token != null) {
          // if (token != "") {
          return _token;
        }
      }
    } catch (e) {}
    return "";
  }
  // Auth(this._token, this._expiryDate, this._userId);

  Future<void> signUp(String email, String password) async {
    return await authentication(email, password, "accounts:signUp");
  }

  Future<void> login(String email, String password) async {
    return await authentication(email, password, "accounts:signInWithPassword");
  }

  Future<void> authentication(
      String email, String password, String token) async {
    final uri =
        "https://identitytoolkit.googleapis.com/v1/$token?key=AIzaSyCZNZITArU8osB37tzfuqnJV4MMdU9WBXo";
    try {
      final response = await http.post(Uri.parse(uri),
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])))
          .toIso8601String();

      _autoLogout();
      // print(json.decode(response.body));
      // final userData = json.encode({
      //   'token': _token,
      //   'userId': _userId,
      //   'expiryDate': _expiryDate,
      // });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(tokenKey, _token.toString());
      await prefs.setString(userIdKey, _userId.toString());
      await prefs.setString(expiryDateKey, _expiryDate.toString());
      // print("hua" + prefs.getString("USER_DATA").toString());
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    print("khatam");
    if (!prefs.containsKey("token")) {
      return false;
    }
    // final extractedData = json.decode(prefs.getString("USER_DATA") as String)
    //     as Map<String, Object>;
    // print(extractedData);
    // _expiryDate = extractedData['expiryDate'] as String;

    _expiryDate = prefs.getString(expiryDateKey) as String;
    if (DateTime.parse(_expiryDate).isBefore(DateTime.now())) {
      return false;
    }
    _token = prefs.getString(tokenKey) as String;
    _userId = prefs.getString(userIdKey) as String;
    print(_token + "     " + _expiryDate + "   " + _userId);
    // _userId = extractedData['userId'] as String;
    notifyListeners();
    _autoLogout();
    return true;
  }

  void _autoLogout() {
    // if (_authTimer != null) {
    //   _authTimer.cancel();
    // }
    final timeToExpiry =
        DateTime.parse(_expiryDate).difference(DateTime.now()).inSeconds;
    print(timeToExpiry);
    // _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, _token.toString());
    await prefs.setString(userIdKey, _userId.toString());
    await prefs.setString(expiryDateKey, _expiryDate.toString());
    // if(_authTimer!=null)
    // _authTimer.cancel();
    // _authTimer = null;
    notifyListeners();
  }
}
