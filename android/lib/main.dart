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

    return SizedBox(
      width: 412, // 원본 코드의 너비를 유지
      height: screenHeight > 885 ? screenHeight : 885, // 최소 높이 885를 유지하거나 화면 높이 사용
      child: Stack(
        children: [
          // 1. 파란색 배경 영역 (0xFF2567E8)
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 412,
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
              // 실제 아이콘 대신 공간만 유지
              // 아이콘이 포함된 Row 위젯은 복잡성 때문에 단순화했습니다.
            ),
          ),

          // 3. 로그인 버튼 카드 영역
          Positioned(
            left: 42,
            top: 489,
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
                spacing: 24,
                children: [
                  _buildLoginButton('휴대폰번호로 계속하기', Colors.white, const Color(0xFFEFF0F6), null),
                  _buildLoginButton('구글로 시작하기', Colors.white, const Color(0xFFEFF0F6), Icons.search),
                  _buildLoginButton('카카오로 시작하기', const Color(0xFFFEE500), const Color(0xFFFEE500), Icons.chat_bubble),
                ],
              ),
            ),
          ),

          // 4. 아이디 비밀번호로 시작하기 텍스트
          Positioned(
            left: 91,
            top: 717,
            child: SizedBox(
              width: 230,
              height: 54,
              child: Text(
                '아이디 비밀번호로 시작하기',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFFAEAEAE),
                  fontSize: 15,
                  // 폰트 패밀리 제거 (기본 Roboto 사용)
                  fontWeight: FontWeight.w400,
                  height: 3.67,
                  letterSpacing: -0.24,
                ),
              ),
            ),
          ),

          // 5. SAFEWAY 로고 텍스트 (커스텀 폰트 제외)
          Positioned(
            left: 60, // -31에서 중앙 정렬을 고려하여 대략 60으로 조정
            top: 250, // 기존 267에서 시각적으로 중앙에 가깝게 조정
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SAFE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 100,
                    // 폰트 패밀리 제거 (기본 Roboto 사용)
                    fontWeight: FontWeight.w700,
                    height: 0.94,
                    letterSpacing: -0.24,
                  ),
                ),
                const Text(
                  'WAY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 100,
                    // 폰트 패밀리 제거 (기본 Roboto 사용)
                    fontWeight: FontWeight.w700,
                    height: 0.94,
                    letterSpacing: -0.24,
                  ),
                ),
              ],
            ),
          ),

          // 6. 이미지 영역
          Positioned(
            left: 116,
            top: 113,
            child: Container(
              width: 180,
              height: 151,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  // 실제 이미지 URL로 대체하거나, 기본 이미지 사용
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

  // 로그인 버튼 위젯 생성 함수
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
        spacing: 10,
        children: [
          if (iconData != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(iconData, size: 18, color: const Color(0xFF1A1C1E)),
            ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1A1C1E),
              fontSize: 14,
              // 폰트 패밀리 제거 (기본 Roboto 사용)
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