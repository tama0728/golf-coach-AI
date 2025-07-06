import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../main_pages/main_page.dart';
import 'signup_page1.dart';
import 'findID.dart';
import 'findPW.dart';
import 'bloc.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  final storage = FlutterSecureStorage();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final id = _idController.text.trim();
    final pw = _pwController.text;

    print('아이디: $id');
    print('비밀번호: $pw');

    final url = Uri.parse('http://${dotenv.get('HOSTIP')}:3000/api/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_email': id,
          'user_pw': pw
        }),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        
        // 토큰 안전하게 저장
        await storage.write(key: 'jwt_token', value: token);
        final check = await storage.read(key: 'jwt_token');
        print('저장된 JWT 토큰: $check');

        // 홈 화면 등으로 이동
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainPage()),
        );
        return ;
      } else {
        setState(() {
          _errorMessage = '로그인 실패: ${jsonDecode(response.body)['error']}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '네트워크 오류: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    // error popup
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(_errorMessage ?? 'Unknown error'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Bloc();
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/image1.png'), // 배경 이미지
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true, // 키보드 올라올 때 화면 밀리게 함
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView( // 키보드 때문에 overflow 방지
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child:
                  Container(
                    width: 400,
                    height: 580,
                    margin: EdgeInsets.fromLTRB(35, 240, 35, 100),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA0C3A0),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child:
                    Container(
                      margin: EdgeInsets.all(12),
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F5E6),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'LOGIN',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          StreamBuilder<String>(
                            stream: bloc.email,
                            builder: (context, snapshot) => TextField(
                              controller: _idController,
                              onChanged: bloc.emailChanged,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Enter user email",
                                  labelText: "User email",
                                  errorText: snapshot.hasError ? snapshot.error.toString() : null,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          StreamBuilder<String>(
                            stream: bloc.password,
                            builder: (context, snapshot) => TextField(
                              controller: _pwController,
                              onChanged: bloc.passwordChanged,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Enter password",
                                  labelText: "Password",
                                  errorText: snapshot.hasError ? snapshot.error.toString() : null,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _handleLogin,
                              child: Text('로그인'),
                            ),
                          ),
                          SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => SignupPage1()),
                                );
                                // 회원가입 처리
                              },
                              child: Text('회원가입'),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => FindIDPage()),
                                  );
                                  // 아이디 찾기 처리
                                },
                                child: Text('아이디 찾기'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => FindPWPage()),
                                  );
                                  // 비밀번호 찾기 처리
                                },
                                child: Text('비밀번호 찾기'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              // ),
            ),
          ),
        ),
      ),
    );
  }
}
