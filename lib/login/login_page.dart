import 'package:flutter/material.dart';
import '../main_pages/main_page.dart';
import 'signup_page1.dart';
import 'findID.dart';
import 'findPW.dart';
import 'bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final id = _idController.text.trim();
    final pw = _pwController.text;

    print('아이디: $id');
    print('비밀번호: $pw');

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MainPage()),
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
                                  hintText: "Enter username",
                                  labelText: "Username",
                                  errorText: snapshot.error.toString()
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
                                  errorText: snapshot.error.toString()),
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
