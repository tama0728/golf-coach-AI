import 'package:flutter/material.dart';

class AppLicensePage extends StatelessWidget {
  const AppLicensePage({Key? key}) : super(key: key);

  static const _licenseText = '''
골프 코치 앱 라이선스

본 소프트웨어는 MIT License 하에 제공됩니다.

MIT License

Copyright (c) 2025 골프코치앱

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.


사용된 오픈소스 라이브러리 및 라이선스

• flutter_secure_storage  
  BSD 3-Clause License  
  https://pub.dev/packages/flutter_secure_storage

• provider  
  MIT License  
  https://pub.dev/packages/provider

• http  
  BSD 3-Clause License  
  https://pub.dev/packages/http

• ffmpeg_kit_flutter_new  
  Apache License 2.0  
  https://github.com/tanersener/ffmpeg-kit
  
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('라이선스', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          _licenseText,
          style: const TextStyle(fontSize: 14, height: 1.6),
        ),
      ),
    );
  }
}
