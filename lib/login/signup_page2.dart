import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'signup_page3.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class SignupPage2 extends StatefulWidget {
  @override
  _SignupPage2State createState() => _SignupPage2State();
}

class _SignupPage2State extends State<SignupPage2> {
  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  final _pwCheckController = TextEditingController();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _phoneController = TextEditingController(text: '010');

  bool _isLoading = false;
  String? _errorMessage;
  bool _isEmailValid = false;
  bool _isPwValid = false;
  bool _codeSent = false; // 인증번호 발송 여부 상태 추가
  String? _verificationCode; // 실제 인증번호 저장
  String? _passwordError;
  String? _emailFormatError;

  String? user_email;
  String? user_pw;
  String? phone_num;
  String? _code;
  String? user_nickname;

  // handel id  // 아이디 중복확인
  Future<void> _handleCheckEmail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    user_email = _emailController.text.trim();

    print('이메일: $user_email');

    final url = Uri.parse('http://${dotenv.get('HOSTIP')}:3000/api/auth/check-user_email');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_email': user_email,
        }),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        setState(() {
          _errorMessage = '이메일 사용 가능';
          _isEmailValid = true;
        });
        // 버튼을 인증번호 발송으로 변경
      } else if (response.statusCode == 400) {
        setState(() {
          _errorMessage = '이미 사용 중인 이메일입니다.';
          _isEmailValid = false;
        });
        // 기존과 동일하게 에러 메시지 출력
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
      } else {
        setState(() {
          _errorMessage = '이메일 확인 실패: ${jsonDecode(response.body)['error']}';
          _isEmailValid = false;
        });
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
    } catch (e) {
      setState(() {
        _errorMessage = '네트워크 오류: $e';
        _isEmailValid = false;
      });
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _generateRandomCode([int length = 6]) async {
    final rand = Random();
    return List.generate(length, (_) => rand.nextInt(10)).join();
  }

  Future<void> _handleSendCode() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final url = Uri.parse('http://${dotenv.get('HOSTIP')}:3000/mail/test');
    final code = await _generateRandomCode();
    _verificationCode = code;
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_email': _emailController.text.trim(),
          'subject': '인증번호 발송',
          'text': '인증번호: $code'
        }),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          _codeSent = true;
          _errorMessage = '인증번호가 이메일로 발송되었습니다.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('인증번호가 이메일로 발송되었습니다.')),
        );
      } else {
        setState(() {
          _errorMessage = '메일 발송 실패: ${response.body}';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage ?? 'Unknown error')),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = '네트워크 오류: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage ?? 'Unknown error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleVerifyCode() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final url = Uri.parse('http://${dotenv.get('HOSTIP')}:3000/api/auth/verify-code');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_email': _emailController.text.trim(),
          'code': _codeController.text.trim(),
        }),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200 && jsonDecode(response.body)['success'] == true) {
        setState(() {
          _errorMessage = '인증 성공!';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이메일 인증이 완료되었습니다.')),
        );
        // 인증 성공 시 추가 처리(예: 다음 단계로 이동) 가능
      } else {
        setState(() {
          _errorMessage = jsonDecode(response.body)['error'] ?? '인증 실패';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage ?? 'Unknown error')),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = '네트워크 오류: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage ?? 'Unknown error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _validatePasswords() {
    final pw = _pwController.text;
    final pwCheck = _pwCheckController.text;
    if (pw.isEmpty || pwCheck.isEmpty) {
      setState(() {
        _passwordError = null;
      });
      return;
    }
    if (pw != pwCheck) {
      setState(() {
        _passwordError = '비밀번호가 일치하지 않습니다.';
      });
    } else {
      setState(() {
        _passwordError = null;
      });
    }
  }

  void _onEmailChanged(String value) {
    setState(() {
      if (!EmailValidator.validate(value.trim())) {
        _emailFormatError = '이메일 형식이 올바르지 않습니다.';
        _isEmailValid = false;
      } else {
        _emailFormatError = null;
      }
    });
  }

  // 휴대폰 번호 하이픈 자동 포맷 함수
  String formatPhoneNumber(String input) {
    // input: 01012345678 → 010-1234-5678
    if (input.length != 11) return input;
    return '${input.substring(0,3)}-${input.substring(3,7)}-${input.substring(7,11)}';
  }


    @override
  Widget build(BuildContext context) {
    final bloc = Bloc();
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            // 이메일 버튼 콜백 변수 선언
            (() {
              VoidCallback? emailButtonCallback;
              if (_emailFormatError == null && _emailController.text.isNotEmpty) {
                emailButtonCallback = _isEmailValid
                  ? () { _handleSendCode(); }
                  : () { _handleCheckEmail(); };
              }
              return _buildTextFieldWithButton(
                _emailController,
                '이메일',
                _isEmailValid ? (_codeSent ? '인증번호 재발송' : '인증번호 발송') : '중복확인',
                emailButtonCallback,
              );
            })(),
            if (_emailFormatError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  _emailFormatError!,
                  style: TextStyle(color: Colors.red, fontSize: 13),
                ),
              ),
            TextField(
              controller: _pwController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
                errorText: _passwordError,
              ),
              onChanged: (value) {
                _validatePasswords();
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _pwCheckController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호 확인',
                border: OutlineInputBorder(),
                errorText: _passwordError,
              ),
              onChanged: (value) {
                _validatePasswords();
              },
            ),
            SizedBox(height: 16),
            _buildTextFieldWithButton(
              _codeController,
              '인증번호 입력',
              '확인',
              _handleVerifyCode,
            ),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: '휴대폰번호',
                hintText: '010-XXXX-YYYY',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // 010은 고정, 나머지 8자리만 입력 가능
                String numbers = value.replaceAll(RegExp(r'[^0-9]'), '');
                if (!numbers.startsWith('010')) {
                  numbers = '010' + numbers.replaceFirst(RegExp(r'^0*'), '');
                }
                if (numbers.length < 3) {
                  numbers = '010';
                }
                if (numbers.length > 11) {
                  numbers = numbers.substring(0, 11);
                }
                String formatted = numbers;
                if (numbers.length > 3 && numbers.length <= 7) {
                  formatted = numbers.substring(0, 3) + '-' + numbers.substring(3);
                } else if (numbers.length > 7) {
                  formatted = numbers.substring(0, 3) + '-' + numbers.substring(3, 7) + '-' + numbers.substring(7, numbers.length > 11 ? 11 : numbers.length);
                }
                // 010만 입력된 경우 하이픈이 붙지 않도록 처리
                if (numbers == '010') {
                  formatted = '010';
                }
                if (formatted != value) {
                  _phoneController.value = TextEditingValue(
                    text: formatted,
                    selection: TextSelection.collapsed(offset: formatted.length),
                  );
                }
              },
            ),
            SizedBox(height: 24),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              user_pw = _pwController.text.trim();
              user_email = _emailController.text.trim();
              // 휴대폰 번호 포맷 적용
              String rawPhone = _phoneController.text.trim();
              String phoneNumFormatted = rawPhone;
              if (rawPhone.length == 11 && rawPhone.startsWith('010')) {
                phoneNumFormatted = formatPhoneNumber(rawPhone);
              }
              phone_num = phoneNumFormatted;
              // 최종 유효성 검사
              _validatePasswords();
              if (_passwordError != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(_passwordError!)),
                );
                return;
              }
              // 다음 단계 or 가입 처리
              print('가입 정보 입력 완료');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignupPage3(user_email!, user_pw!, phone_num!)),
              );
            },
            child: Text('다음으로'),
          ),
        ),
      ),

    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithButton(
      TextEditingController controller, String label, String buttonText, VoidCallback? onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(),
              ),
              onChanged: label == '이메일' ? _onEmailChanged : null,
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: onPressed,
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormFieldWithButton(
      TextEditingController controller, String label, String buttonText, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,

              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: onPressed,
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
