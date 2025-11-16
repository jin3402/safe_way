import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // 템플릿이랑 맞게 title 넘겨줌
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 앱바 필요 없으면 삭제해도 됨
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        width: 412,
        height: 917,
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 412,
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                        ),
                        Container(width: 18, height: 18),
                        Container(
                          width: 18.75,
                          height: 18.75,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 0,
              top: 313,
              child: Container(
                width: 412,
                height: 604,
                decoration: const BoxDecoration(
                  color: Color(0xFF2567E8),
                ),
              ),
            ),

            Positioned(
              left: 35,
              top: 187,
              child: Container(
                width: 342,
                height: 318,
                decoration: ShapeDecoration(
                  image: const DecorationImage(
                    image: NetworkImage("https://placehold.co/342x318"),
                    fit: BoxFit.fill,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),

            Positioned(
              left: 52,
              top: 56,
              child: const SizedBox(
                width: 308,
                height: 56,
                child: Text(
                  '000님의 위치',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                    height: 1.10,
                    letterSpacing: -0.24,
                  ),
                ),
              ),
            ),

            Positioned(
              left: 54,
              top: 541,
              child: const Text(
                '경기 의정부시 호암로 95\n기도관 2층 2000호',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  height: 1.83,
                  letterSpacing: -0.24,
                ),
              ),
            ),

            Positioned(
              left: 34,
              top: 101,
              child: const SizedBox(
                width: 345,
                height: 56,
                child: Text(
                  '000님의 위치',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF2567E8),
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                    height: 1.10,
                    letterSpacing: -0.24,
                  ),
                ),
              ),
            ),

            Positioned(
              left: 299,
              top: 802,
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFF2567E8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
