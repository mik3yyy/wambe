import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:wambe/repository/user_repo/user_data_provider.dart';
import 'package:wambe/repository/user_repo/user_repo.dart';

class userRepoImp implements UserRepo {
  @override
  Future<Map<String, dynamic>> signIn({required String event}) async {
    try {
      final res = await UserDataProvider.signIn(event);
      final data = jsonDecode(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return {'success': true, 'status': res.statusCode, 'data': data};
      } else {
        return {'success': false, 'status': res.statusCode, 'data': data};
      }
    } catch (e) {
      print(e.toString());
      return {'success': false, 'message': 'Check your network'};
    }
  }

  @override
  Future<Map<String, dynamic>> welcomeUser(
      {required String eventID,
      required String name,
      required String email}) async {
    try {
      final res = await UserDataProvider.welcomeUser(
          eventID: eventID, name: name, email: email);
      final data = jsonDecode(res.body);
      print(data);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return {'success': true, 'status': res.statusCode, 'data': data};
      } else {
        return {'success': false, 'status': res.statusCode, 'data': data};
      }
    } catch (e) {
      print(e.toString());
      return {'success': false, 'message': 'Check your network'};
    }
  }

  @override
  Future<Map<String, dynamic>> chnageName({required String name}) async {
    try {
      final res = await UserDataProvider.chnageName(name: name);
      final data = res.data as Map; // jsonDecode(res.body);
      if (res.statusCode! >= 200 && res.statusCode! < 300) {
        return {'success': true, 'status': res.statusCode, 'data': data};
      } else {
        return {'success': false, 'status': res.statusCode, 'data': data};
      }
    } catch (e) {
      print(e.toString());
      return {'success': false, 'message': 'Check your network'};
    }
  }
}
