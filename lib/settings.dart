import 'package:flutter/material.dart';
// google_fonts가 필요하다면 pubspec.yaml에 추가하고 이 줄의 주석을 푸세요.
// import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 숨기기
      theme: ThemeData(
        primaryColor: const Color(0xFF2567E8), // 기본 파란색
        scaffoldBackgroundColor: Colors.white, // 기본 배경 흰색
        // fontFamily: 'Inter', // 👈 Inter 폰트를 사용하려면 pubspec.yaml에 google_fonts 추가 필요
      ),
      home: SettingsScreen(), // SettingsScreen을 홈으로 설정
    );
  }
}

// Positioned 대신 Scaffold, ListView, BottomNavigationBar를 사용하도록 수정한 스크린
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // 하단 탭 인덱스 관리 (0 = 설정, 1 = 지도, 2 = 홈, 3 = hyesung)
  int _selectedIndex = 0; // 👈 현재 '설정' 탭(index 0)이 선택된 상태

  // 👈 [수정] 탭 클릭 시 화면 전환 로직 추가
  void _onItemTapped(int index) {
    // 1. '지도'(index 1) 또는 '홈'(index 2) 탭을 눌렀을 때
    if (index == 1 || index == 2) {
      // 2. 'main.dart' (이전 화면)으로 돌아감
      Navigator.pop(context);
    }
    // 3. '설정'(index 0) 또는 'hyesung'(index 3) 탭을 눌렀을 때
    else {
      // 4. 현재 화면(설정)에 머무르면서 탭 인덱스만 변경
      setState(() {
        _selectedIndex = index;
      });

      // (나중에 'hyesung' 화면으로 이동하는 로직을 여기에 추가할 수 있습니다)
      if (index == 3) {
        print("hyesung 탭 클릭됨");
        // 예: Navigator.push(context, MaterialPageRoute(builder: (context) => HyesungScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. 상단 AppBar 구현
      appBar: AppBar(
        backgroundColor: Colors.white, // 배경 흰색
        elevation: 0, // 그림자 제거
        title: Text(
          '000', // Figma 원본의 '000' 텍스트
          style: TextStyle(
            color: Colors.black,
            fontSize: 35,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),

      // 2. Positioned 대신 ListView로 설정 메뉴 구현
      //    (스크롤이 가능하고 반응형으로 작동)
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 31, vertical: 20),
        children: [
          _buildSettingsItem('즐겨찾기 설정'),
          _buildSettingsItem('긴급연락처'),
          _buildSettingsItem('위치 공유 유효시간'),
          SizedBox(height: 10), // 약간의 간격
          Text(
            '로그아웃',
            style: TextStyle(
              color: const Color(0xFFFF3535), // 빨간색
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),

      // 3. 하단 네비게이션 바 구현 (가장 중요한 수정)
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: '지도',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'hyesung',
          ),
        ],
        currentIndex: _selectedIndex, // 현재 선택된 탭
        selectedItemColor: const Color(0xFF2567E8), // 선택된 아이템 색상
        unselectedItemColor: Colors.grey, // 선택되지 않은 아이템 색상
        onTap: _onItemTapped, // 👈 [수정] 수정된 탭 클릭 함수 연결
        type: BottomNavigationBarType.fixed, // 탭 고정
        showUnselectedLabels: true, // 선택되지 않은 탭 라벨도 표시
      ),
    );
  }

  // 반복되는 설정 메뉴 항목을 만드는 함수
  Widget _buildSettingsItem(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}