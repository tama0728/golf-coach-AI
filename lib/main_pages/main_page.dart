import 'package:flutter/material.dart';
import 'home/home.dart';
import 'tutorial/tutorial.dart';
import 'analysis/analysis.dart';
import 'mypage/mypage.dart';
import 'more/more.dart';

class MainPage extends StatefulWidget {
  static _MainPageState? currentState;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    TutorialPage(),
    AnalysisPage(),
    MyPage(),
    MorePage(),
  ];

  @override
  void initState() {
    super.initState();
    MainPage.currentState = this;
  }

  @override
  void dispose() {
    MainPage.currentState = null;
    super.dispose();
  }

  void updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: '가이드북'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '분석'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: '더보기'),
        ],
      ),
    );
  }
}
