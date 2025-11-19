import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: LoginFrame(context: context),
      ),
    );
  }
}

class LoginFrame extends StatelessWidget {
  final BuildContext context;

  const LoginFrame({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth,
      height: screenHeight > 885 ? screenHeight : 885,
      child: Stack(
        children: [
          // 1. 파란색 배경 영역 (0xFF2567E8)
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: screenWidth,
              height: 616,
              decoration: const BoxDecoration(color: Color(0xFF2567E8)),
            ),
          ),

          // 2. 상단 상태 표시줄 (빈 컨테이너)
          const Positioned(
            left: 0,
            top: 0,
            child: SizedBox(
              width: 412,
              height: 32,
            ),
          ),

          // 3. 로그인 버튼 카드 영역
          Positioned(
            left: (screenWidth - 327) / 2,
            top: 550,
            child: Container(
              width: 327,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLoginButton(
                    context,
                    '휴대폰번호로 계속하기',
                    Colors.white,
                    const Color(0xFFEFF0F6),
                    null,
                  ),
                  const SizedBox(height: 24),
                  _buildLoginButton(
                    context,
                    '구글로 시작하기',
                    Colors.white,
                    const Color(0xFFEFF0F6),
                    Icons.search,
                  ),
                  const SizedBox(height: 24),
                  _buildLoginButton(
                    context,
                    '카카오로 시작하기',
                    const Color(0xFFFEE500),
                    const Color(0xFFFEE500),
                    Icons.chat_bubble,
                  ),
                ],
              ),
            ),
          ),

          // 4. 아이디 비밀번호로 시작하기 텍스트
          Positioned(
            left: (screenWidth - 230) / 2,
            top: 770,
            child: GestureDetector(
              onTap: () {
                // 아이디/비밀번호 로그인 클릭 시 홈 화면으로 이동
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
              child: SizedBox(
                width: 230,
                height: 54,
                child: Text(
                  '아이디 비밀번호로 시작하기',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFAEAEAE),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    height: 3.67,
                    letterSpacing: -0.24,
                  ),
                ),
              ),
            ),
          ),

          // 5. SAFEWAY 로고 텍스트
          Positioned(
            left: 0,
            right: 0,
            top: 290,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'SAFE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 100,
                    fontWeight: FontWeight.w700,
                    height: 0.94,
                    letterSpacing: -0.24,
                  ),
                ),
                Text(
                  'WAY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 100,
                    fontWeight: FontWeight.w700,
                    height: 0.94,
                    letterSpacing: -0.24,
                  ),
                ),
              ],
            ),
          ),

          // 6. 이미지 영역 (로고 위쪽 중앙)
          Positioned(
            left: (screenWidth - 180) / 2,
            top: 150,
            child: Container(
              width: 180,
              height: 151,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    "https://via.placeholder.com/180x151?text=Logo",
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 로그인 버튼 위젯 생성 함수 - 네비게이션 추가됨!
  Widget _buildLoginButton(
      BuildContext context,
      String text,
      Color bgColor,
      Color borderColor,
      IconData? iconData,
      ) {
    return GestureDetector(
      onTap: () {
        // 🔥 로그인 성공 시 홈 화면으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      },
      child: Container(
        width: 279,
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: bgColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: borderColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (iconData != null)
              Icon(iconData, size: 18, color: const Color(0xFF1A1C1E)),
            if (iconData != null) const SizedBox(width: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF1A1C1E),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.40,
                letterSpacing: -0.14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}