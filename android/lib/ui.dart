import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safety Facilities',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 지도 이미지 위에 파란 점 고정
    final double dx = 0.37; // x축 위치 (55%)
    final double dy = 0.48; // y축 위치 (32%)

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 지도 + 파란 점
            Expanded(
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double dotSize = 24.0;
                    return Stack(
                      children: [
                        // 지도 이미지
                        Positioned.fill(
                          child: Image.asset(
                            "assets/ShihanMap.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        // 파란 점 (고정된 위치)
                        Positioned(
                          left: constraints.maxWidth * dx - dotSize / 2,
                          top: constraints.maxHeight * dy - dotSize / 2,
                          child: Container(
                            width: dotSize,
                            height: dotSize,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // 바로가기 섹션
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16, top: 12, bottom: 6),
                    child: Text(
                      '바로가기',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _QuickButton(
                          icon: Icons.local_police,
                          label: "파출소",
                        ),
                        _QuickButton(
                          icon: Icons.security,
                          label: "경찰서",
                        ),
                        _QuickButton(
                          icon: Icons.child_care,
                          label: "해바라기",
                        ),
                        _QuickButton(
                          icon: Icons.notifications_active,
                          label: "비상벨",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 하단 네비게이션
            Container(
              height: 62,
              color: const Color(0xFF2567E8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(Icons.settings, color: Colors.white, size: 28),
                  Icon(Icons.home, color: Colors.white, size: 28),
                  Icon(Icons.circle, color: Colors.white, size: 28),
                  Icon(Icons.share, color: Colors.white, size: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF2567E8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF2567E8),
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
