import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class ProfileImageProvider extends ChangeNotifier {
  String _imagePath = 'assets/profile/profile1.png';
  final storage = FlutterSecureStorage();

  String get imagePath => _imagePath;

  // 서버에서 프로필 이미지 가져오기
  Future<void> fetchProfileImage() async {
    try {
      final token = await storage.read(key: 'jwt_token');
      if (token == null) return;

      final response = await http.get(
        Uri.parse('http://${dotenv.get('HOSTIP')}:3000/users/me'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final profileImage =
            data['profile_image'] ?? 'assets/profile/profile1.png';
        _imagePath = profileImage;
        notifyListeners();
      }
    } catch (e) {
      print('프로필 이미지 가져오기 오류: $e');
    }
  }

  // 서버에 프로필 이미지 업데이트
  Future<bool> updateProfileImage(String imagePath) async {
    try {
      final token = await storage.read(key: 'jwt_token');
      if (token == null) return false;

      final response = await http.put(
        Uri.parse('http://${dotenv.get('HOSTIP')}:3000/users/me/profile-image'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'profile_image': imagePath,
        }),
      );

      if (response.statusCode == 200) {
        _imagePath = imagePath;
        notifyListeners();
        return true;
      } else {
        print('프로필 이미지 업데이트 실패: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('프로필 이미지 업데이트 오류: $e');
      return false;
    }
  }

  void setImagePath(String path) {
    _imagePath = path;
    notifyListeners();
  }
}
