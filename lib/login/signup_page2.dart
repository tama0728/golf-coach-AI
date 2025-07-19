import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'login_page.dart';

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
  final _userNameController = TextEditingController();

  String? _battingDirection; // '좌' or '우'
  String? user_nickname;
  int? batting_side;
  String? _userNameError;
  bool _userNameChecked = false;

  bool _isLoading = false;
  String? _errorMessage;
  bool _isEmailValid = false;
  bool _isCodeValid = false; // 이메일 형식 유효성 검사 상태
  bool _isPwValid = false;
  bool _codeSent = false; // 인증번호 발송 여부 상태 추가
  String? _verificationCode; // 실제 인증번호 저장
  String? _passwordError;
  String? _emailFormatError;

  String? user_email;
  String? user_pw;
  String? phone_num;
  String? _code;

  @override
  void initState() {
    super.initState();
    _codeController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

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
        // 이메일 사용가능 팝업
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이메일 사용 가능합니다. 인증번호를 발송해주세요.')),
        );
        return ;
        // 버튼을 인증번호 발송으로 변경
      } else if (response.statusCode == 400) {
        setState(() {
          _errorMessage = '이미 사용 중인 이메일입니다.';
          _isEmailValid = false;
        });
      } else {
        setState(() {
          _errorMessage = '이메일 확인 실패: ${jsonDecode(response.body)['error']}';
          _isEmailValid = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '네트워크 오류: $e';
        _isEmailValid = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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

  Future<String> _generateRandomCode([int length = 6]) async {
    final rand = Random();
    return List.generate(length, (_) => rand.nextInt(10)).join();
  }

  Future<void> _handleSendCode() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final url = Uri.parse('http://${dotenv.get('HOSTIP')}:3000/api/mail/test');
    final code = await _generateRandomCode();
    _verificationCode = code;
    try {
      final response = await http.post(
        url,
        headers: {'accept': 'application/json', 'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text.trim(),
          'subject': '인증번호 발송',
          'text': '인증번호: $code'
        }),
      );
      print('인증번호: $_verificationCode');
      print('이메일: ${_emailController.text.trim()}');
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
    final inputCode = _codeController.text.trim();
    if (inputCode.isEmpty) {
      setState(() {
        _errorMessage = '인증번호를 입력해주세요.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('인증번호를 입력해주세요.')),
      );
      setState(() {
        _isCodeValid = false;
      });
      return;
    } else if (inputCode != _verificationCode) {
      setState(() {
        _errorMessage = '인증번호가 일치하지 않습니다.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('인증번호가 일치하지 않습니다.')),
      );
      setState(() {
        _isCodeValid = false;
      });
      return;
    } else {
      setState(() {
        _errorMessage = '인증번호가 확인되었습니다.';
        _isCodeValid = true; // 인증 성공 시 이메일 유효성 검사 통과
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('인증번호가 확인되었습니다.')),
      );
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
    _isEmailValid = false; // 이메일 입력 시 초기화
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

  // 닉네임 중복확인 함수
  Future<void> _handleCheckUserName() async {
    final userNickname = _userNameController.text.trim();
    user_nickname = userNickname;
    if (userNickname.isEmpty) {
      setState(() {
        _userNameError = '닉네임을 입력하세요.';
        _userNameChecked = false;
      });
      return;
    }
    final url = Uri.parse('http://${dotenv.get('HOSTIP')}:3000/api/auth/check-username');
    setState(() {
      _isLoading = true;
      _userNameError = null;
    });
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_nickname': userNickname}),
      );
      if (response.statusCode == 200) {
        setState(() {
          _userNameError = null;
          _userNameChecked = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사용 가능한 닉네임입니다.')),
        );
      } else {
        setState(() {
          _userNameError = '이미 사용 중인 닉네임입니다.';
          _userNameChecked = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_userNameError!)),
        );
      }
    } catch (e) {
      setState(() {
        _userNameError = '네트워크 오류: $e';
        _userNameChecked = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_userNameError!)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 회원가입 처리 함수
  Future<void> _handleSignup() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    user_email = _emailController.text.trim();
    user_pw = _pwController.text.trim();
    phone_num = _phoneController.text.trim();
    user_nickname = _userNameController.text.trim();
    batting_side = _battingDirection == '좌' ? 1 : 0;
    final url = Uri.parse('http://${dotenv.get('HOSTIP')}:3000/api/auth/signup');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "user_email": user_email,
          "user_pw": user_pw,
          "user_nickname": user_nickname,
          "phone_num": phone_num,
          "batting_side": batting_side
        }),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입이 완료되었습니다. 로그인해 주세요.')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        return;
      } else {
        setState(() {
          _errorMessage = '회원가입 실패: \\${jsonDecode(response.body)['error']}';
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

  // 모든 유효성 검사 통과 여부 확인 함수
  bool _isFormValid() {
    return _isEmailValid &&
        _pwController.text.isNotEmpty &&
        _pwCheckController.text.isNotEmpty &&
        _passwordError == null &&
        _isCodeValid &&
        _codeController.text.length == 6 &&
        _phoneController.text.replaceAll('-', '').length == 11 &&
        _userNameController.text.isNotEmpty &&
        _userNameError == null &&
        _userNameChecked == true &&
        _battingDirection != null;
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
            // 1. 이메일
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

            (() {
              VoidCallback? codeButtonCallback;
              codeButtonCallback = _codeController.text.length == 6
                  ? () { _handleVerifyCode(); }
                  : () {
                _isCodeValid = false;
                return;
              }; // 인증번호 입력 버튼은 이메일이 유효할 때만 활성화
              return
              // 2. 인증번호 입력
              _buildTextFieldWithButton(
                _codeController,
                '인증번호 입력',
                '확인',
                codeButtonCallback,
              );
            })(),

            SizedBox(height: 16),
            // 3. 비밀번호
            TextField(
              controller: _pwController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
                errorText: _passwordError,
              ),
              onChanged: (value) {
                setState(() {
                  _validatePasswords();
                });
              },
            ),
            SizedBox(height: 16),
            // 4. 비밀번호 확인
            TextField(
              controller: _pwCheckController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호 확인',
                border: OutlineInputBorder(),
                errorText: _passwordError,
              ),
              onChanged: (value) {
                setState(() {
                  _validatePasswords();
                });
              },
            ),
            SizedBox(height: 16),
            // 5. 휴대폰번호
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
                setState(() {
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
                });
              },
            ),
            SizedBox(height: 24),
            // 6. 닉네임 + 중복확인
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _userNameController,
                    decoration: InputDecoration(
                      labelText: '닉네임',
                      border: OutlineInputBorder(),
                      errorText: _userNameError,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _userNameError = '닉네임 중복확인을 해주세요.';
                        _userNameChecked = false;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  height: 56, // TextField 높이와 맞춤
                  child: ElevatedButton(
                    onPressed: _handleCheckUserName,
                    child: Text('중복확인'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            // 7. 타석 방향
            Text('당신의 타석 방향은?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _battingDirection = '좌';
                    });
                  },
                  child: _buildToggleButton('좌'),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _battingDirection = '우';
                    });
                  },
                  child: _buildToggleButton('우'),
                ),
              ],
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
            onPressed: _isFormValid()
                ? () {
                    _handleSignup();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isFormValid() ? Color(0xFF6750A4) : null,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            child: const Text('회원가입'),
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

  Widget _buildToggleButton(String label) {
    final isSelected = _battingDirection == label;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Color(0xFF6750A4) : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        textStyle: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onPressed: () {
        setState(() {
          _battingDirection = label;
        });
      },
      child: Text(label),
    );
  }
}
