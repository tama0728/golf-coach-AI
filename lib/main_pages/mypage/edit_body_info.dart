// lib/main_pages/profile/edit_body_info_page.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditBodyInfoPage extends StatefulWidget {
  const EditBodyInfoPage({Key? key}) : super(key: key);

  @override
  State<EditBodyInfoPage> createState() => _EditBodyInfoPageState();
}

class _EditBodyInfoPageState extends State<EditBodyInfoPage> {
  final _nicknameController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  bool _saving = false;
  File? _pickedImage;

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final x = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (x != null) {
      setState(() => _pickedImage = File(x.path));
    }
  }

  Future<void> _resetRecords() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('기록 초기화'),
        content: const Text('정말 모든 기록을 초기화할까요? 이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('취소')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('초기화')),
        ],
      ),
    );

    if (ok != true) return;

    try {
      final token = await _storage.read(key: 'jwt_token');
      final base = dotenv.get('HOSTIP', fallback: '127.0.0.1');
      final uri = Uri.parse('http://$base:3000/api/user/records/reset');

      final res = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('기록을 초기화했습니다.')),
        );
      } else {
        throw Exception('reset failed: ${res.statusCode} ${res.body}');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('초기화 실패: $e')),
      );
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final token = await _storage.read(key: 'jwt_token');
      final base = dotenv.get('HOSTIP', fallback: '127.0.0.1');

      // 1) 닉네임 업데이트
      final patchRes = await http.patch(
        Uri.parse('http://$base:3000/api/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: '{"nickname":"${_nicknameController.text.trim()}"}',
      );
      if (patchRes.statusCode != 200) {
        throw Exception('profile update failed: ${patchRes.statusCode} ${patchRes.body}');
      }

      // // 2) 프로필 사진 업로드 (선택된 경우)
      // if (_pickedImage != null) {
      //   final req = http.MultipartRequest(
      //     'POST',
      //     Uri.parse('http://$base:3000/api/user/profile/photo'),
      //   );
      //   req.headers['Authorization'] = 'Bearer $token';
      //   req.files.add(await http.MultipartFile.fromPath('photo', _pickedImage!.path));
      //   final res = await req.send();
      //   if (res.statusCode != 200) {
      //     throw Exception('photo upload failed: ${res.statusCode}');
      //   }
      // }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('저장되었습니다.')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 실패: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatar = _pickedImage != null
        ? CircleAvatar(radius: 36, backgroundImage: FileImage(_pickedImage!))
        : const CircleAvatar(radius: 36, child: Icon(Icons.person, size: 36));

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text(
          '프로필 정보 수정',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  const SizedBox(height: 6),

                  // 닉네임
                  const Text('닉네임 변경',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nicknameController,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      hintText: '변경할 닉네임',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 사진 변경
                  const Text('사진 변경',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      avatar,
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.photo_library),
                        label: const Text('앨범에서 선택'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 기록 초기화
                  const Text('기록 초기화',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _resetRecords,
                    icon: const Icon(Icons.restore),
                    label: const Text('모든 기록 초기화'),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                  width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('저장하기', style: TextStyle(fontSize: 18)),
            ),
          ),
        ),
      ),
    );
  }
}
