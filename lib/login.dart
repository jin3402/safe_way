import 'package:flutter/material.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ScaffoldBackgroundColor를 흰색으로 설정하여 원래 디자인에 맞춥니다.
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const Scaffold(
        body: SingleChildScrollView(
          child: Frame2110(),
        ),
      ),
    );
  }
}

class Frame2110 extends StatelessWidget {
  const Frame2110({super.key});

  @override
  Widget build(BuildContext context) {
    // 화면 크기를 가져와서 반응형으로 조정합니다.
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width; // 화면 너비 추가

    return SizedBox(
      width: screenWidth, // 화면 너비에 맞춤
      height: screenHeight > 885 ? screenHeight : 885, // 최소 높이 885를 유지하거나 화면 높이 사용
      child: Stack(
        children: [
          // 1. 파란색 배경 영역 (0xFF2567E8)
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: screenWidth, // 화면 너비에 맞춤
              height: 616,
              decoration: const BoxDecoration(color: Color(0xFF2567E8)),
            ),
          ),

          // 2. 상단 상태 표시줄 (빈 컨테이너)
          const Positioned(
            left: 0,
            top: 0,
            child: SizedBox(
              width: 412, // 고정된 너비 유지 (또는 screenWidth로 변경 가능)
              height: 32,
              // 실제 아이콘 대신 공간만 유지
            ),
          ),

          // 3. 로그인 버튼 카드 영역
          Positioned(
            // 화면 중앙에 오도록 조정
            left: (screenWidth - 327) / 2, // (화면 너비 - 위젯 너비) / 2
            top: 550, // 로고와 이미지 이동에 따라 조정
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
                  _buildLoginButton('휴대폰번호로 계속하기', Colors.white, const Color(0xFFEFF0F6), null),
                  const SizedBox(height: 24),
                  _buildLoginButton('구글로 시작하기', Colors.white, const Color(0xFFEFF0F6), Icons.search),
                  const SizedBox(height: 24),
                  _buildLoginButton('카카오로 시작하기', const Color(0xFFFEE500), const Color(0xFFFEE500), Icons.chat_bubble),
                ],
              ),
            ),
          ),

          // 4. 아이디 비밀번호로 시작하기 텍스트
          Positioned(
            // 로그인 버튼 카드 중앙에 오도록 조정
            left: (screenWidth - 230) / 2, // (화면 너비 - 위젯 너비) / 2
            top: 770, // 로그인 카드 아래로 조정
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

          // 5. SAFEWAY 로고 텍스트 (완벽한 중앙 정렬로 수정)
          Positioned(
            // 👈 [수정] left: (screenWidth - 200) / 2 대신...
            left: 0,    // 👈 ...left: 0,
            right: 0,   // 👈 ...right: 0 을 사용하여 위젯을 가로로 꽉 채웁니다.
            top: 290, // 이미지 아래, 파란색 배경 중앙에 가깝게 조정
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // 👈 Column이 자식들을 스스로 중앙 정렬
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
            left: (screenWidth - 180) / 2, // (화면 너비 - 이미지 너비) / 2
            top: 150, // 파란색 배경 상단에서 적절한 위치
            child: Container(
              width: 180,
              height: 151,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("https://via.placeholder.com/180x151?text=Logo"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 로그인 버튼 위젯 생성 함수 (내용 변경 없음)
  Widget _buildLoginButton(String text, Color bgColor, Color borderColor, IconData? iconData) {
    return Container(
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
          if (iconData != null)
            const SizedBox(width: 10),
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
    );
  }
}