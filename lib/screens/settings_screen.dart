import 'package:flutter/material.dart';
import 'home_screen.dart';              // ✅ 같은 폴더
import 'safespot_screen.dart';          // ✅ 같은 폴더
import 'spot_share_screen.dart';        // ✅ 같은 폴더
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // 하단 탭 인덱스 관리
  int _selectedIndex = 0;

  // 탭 클릭 시 화면 전환 로직
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
      // 설정 - 현재 화면 유지
        setState(() {
          _selectedIndex = 0;
        });
        break;

      case 1:
      // 안전시설
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SafeSpotScreen(),
          ),
        );
        break;

      case 2:
      // 홈
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
        break;

      case 3:
      // 프로필 (현재는 설정 화면 유지)
        setState(() {
          _selectedIndex = 3;
        });
        break;
    }
  }

  // 로그아웃 함수
  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그아웃'),
          content: const Text('정말로 로그아웃하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
                // 로그인 화면으로 이동
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text(
                '로그아웃',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. 상단 AppBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(), // 뒤로가기 버튼 제거
        title: const Text(
          'SafeWay',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),

      // 2. 설정 메뉴 리스트
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        children: [
          // 즐겨찾기 설정
          _buildSettingsMenuItem(
            icon: Icons.favorite_outline,
            title: '즐겨찾기 설정',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('즐겨찾기 설정 화면')),
              );
            },
          ),

          const SizedBox(height: 16),

          // 긴급연락처
          _buildSettingsMenuItem(
            icon: Icons.phone,
            title: '긴급연락처',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('긴급연락처 화면')),
              );
            },
          ),

          const SizedBox(height: 16),

          // 위치 공유 유효시간
          _buildSettingsMenuItem(
            icon: Icons.timer,
            title: '위치 공유 유효시간',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('위치 공유 유효시간 설정')),
              );
            },
          ),

          const SizedBox(height: 16),

          // 알림 설정
          _buildSettingsMenuItem(
            icon: Icons.notifications_none,
            title: '알림 설정',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('알림 설정 화면')),
              );
            },
          ),

          const SizedBox(height: 16),

          // 개인정보 보호
          _buildSettingsMenuItem(
            icon: Icons.privacy_tip_outlined,
            title: '개인정보 보호',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('개인정보 보호 정책')),
              );
            },
          ),

          const SizedBox(height: 24),

          // 로그아웃 버튼
          GestureDetector(
            onTap: _logout,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 24,
                  ),
                  SizedBox(width: 16),
                  Text(
                    '로그아웃',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // 3. 하단 네비게이션 바
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2567E8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: '설정',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_police_outlined),
              activeIcon: Icon(Icons.local_police),
              label: '안전시설',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: '프로필',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF2567E8),
          showUnselectedLabels: true,
          elevation: 0,
        ),
      ),
    );
  }

  // 설정 메뉴 항목 위젯
  Widget _buildSettingsMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: const Color(0xFF2567E8),
                  size: 24,
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}