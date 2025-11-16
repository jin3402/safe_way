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
      home: const LocationPage(),   // ← 여기 수정됨
    );
  }
}

//////////////////////////////////////////////////////
//  내 위치 UI 페이지 (기본폰트 적용 완료된 버전)
//////////////////////////////////////////////////////
class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 412,
        height: 917,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 314,
              child: Container(
                width: 412,
                height: 514,
                decoration: const BoxDecoration(
                  color: Color(0xFF2567E8),
                ),
              ),
            ),

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
                        Container(width: 18, height: 18),
                        Container(width: 18, height: 18),
                        Container(width: 18.75, height: 18.75),
                      ],
                    ),
                  ],
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
              left: 114,
              top: 101,
              child: SizedBox(
                width: 183,
                height: 56,
                child: const Text(
                  '내 위치',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF2567E8),
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                    letterSpacing: -0.24,
                  ),
                ),
              ),
            ),

            Positioned(
              left: 54,
              top: 541,
              child: const Text(
                '경기 의정부시 호암로 95',
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
              left: 69,
              top: 609,
              child: Container(
                width: 273,
                height: 40,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
              ),
            ),

            Positioned(
              left: 127,
              top: 619,
              child: const SizedBox(
                width: 157,
                height: 21,
                child: Text(
                  '위치 설명 추가하기',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF797979),
                    fontSize: 20,
                    height: 1,
                    letterSpacing: -0.24,
                  ),
                ),
              ),
            ),

            Positioned(
              left: 155,
              top: 730,
              child: const SizedBox(
                width: 103,
                height: 21,
                child: Text(
                  '공유하기',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    height: 1,
                    letterSpacing: -0.24,
                  ),
                ),
              ),
            ),

            Positioned(
              left: 186,
              top: 764,
              child: Container(
                width: 40,
                height: 40,
                decoration: const ShapeDecoration(
                  color: Color(0xFFFEE500),
                  shape: OvalBorder(),
                ),
              ),
            ),

            Positioned(
              left: 0,
              top: 827,
              child: Container(
                width: 412,
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFF2567E8),
                ),
              ),
            ),

            Positioned(
              left: 133,
              top: 834,
              child: Container(
                width: 40,
                height: 40,
                decoration: const ShapeDecoration(
                  color: Color(0xFF2567E8),
                  shape: OvalBorder(),
                ),
              ),
            ),

            Positioned(
              left: 26,
              top: 834,
              child: Container(
                width: 40,
                height: 40,
                decoration: const ShapeDecoration(
                  color: Color(0xFF2567E8),
                  shape: OvalBorder(),
                ),
              ),
            ),

            Positioned(
              left: 141,
              top: 840,
              child: Container(width: 24, height: 24),
            ),

            Positioned(
              left: 248,
              top: 842,
              child: Container(width: 24, height: 24),
            ),

            Positioned(
              left: 355,
              top: 842,
              child: Container(width: 24, height: 24),
            ),

            Positioned(
              left: 34,
              top: 842,
              child: Container(width: 24, height: 24),
            ),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////
//  기존 MyHomePage는 남겨둠 (필요시 home: 바꾸면 됨)
//////////////////////////////////////////////////////
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
