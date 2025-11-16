import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'settings.dart'; // 👈 [추가] settings.dart 파일을 import

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Scaffold(
        body: ListView(children: [
          const GeneratedMapScreen(),
        ]),
      ),
    );
  }
}

class GeneratedMapScreen extends StatefulWidget {
  const GeneratedMapScreen({super.key});

  @override
  State<GeneratedMapScreen> createState() => _GeneratedMapScreenState();
}

class _GeneratedMapScreenState extends State<GeneratedMapScreen> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  // 초기 카메라는 신한대학교
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.739, 127.081), // '신한대학교' 좌표
    zoom: 15.0,
  );

  LatLng? _currentPosition;
  bool _isLocationLoading = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  // [기능] 실제 GPS 위치와 권한을 처리하는 함수
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentPosition = _initialCameraPosition.target; // 신한대
        _addMarker();
        _isLocationLoading = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _currentPosition = _initialCameraPosition.target; // 신한대
          _addMarker();
          _isLocationLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentPosition = _initialCameraPosition.target; // 신한대
        _addMarker();
        _isLocationLoading = false;
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _addMarker(); // '내 위치'에 마커 추가
        _isLocationLoading = false;
      });
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 15.0),
      );
    } catch (e) {
      print("Error getting location: $e");
      setState(() {
        _currentPosition = _initialCameraPosition.target; // 신한대
        _addMarker();
        _isLocationLoading = false;
      });
    }
  }

  // [기능] 마커(파란 점)를 생성하는 함수
  void _addMarker() {
    _markers.clear();
    if (_currentPosition != null) {
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('blueDot'),
            position: _currentPosition!, // '내 위치' 또는 '신한대'
            infoWindow: const InfoWindow(title: '현재 위치'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        );
      });
    }
  }

  // [기능] '파출소' 검색 함수 (나중에 '집' 버튼 등에 연결 가능)
  void _findNearbyPoliceStations() async {
    if (_currentPosition == null) {
      print("Current position is not available.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('위치 정보를 가져올 수 없습니다. 권한을 확인해주세요.')),
      );
      return;
    }
    final lat = _currentPosition!.latitude;
    final lng = _currentPosition!.longitude;
    final query = Uri.encodeComponent("파출소");
    final url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$query&location=$lat,$lng');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 412,
      height: 917, // Figma 원본 높이 유지
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          // 1. GoogleMap 위젯
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            height: 616,
            child: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _initialCameraPosition,
                  onMapCreated: (GoogleMapController controller) {
                    if (!_controller.isCompleted) {
                      _controller.complete(controller);
                    }
                    _mapController = controller;
                  },
                  markers: _markers,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: true,
                ),
                if (_isLocationLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),

          // [유지] '길찾기' 버튼
          Positioned(
            left: 343,
            top: 46,
            child: Container(
              width: 53,
              height: 41,
              decoration: ShapeDecoration(
                color: const Color(0xFF2567E8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Positioned(
            left: 349,
            top: 65,
            child: SizedBox(
              width: 41,
              height: 14,
              child: Text(
                '길찾기',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  height: 2,
                  letterSpacing: -0.24,
                ),
              ),
            ),
          ),

          // [유지] 하단 흰색 패널
          Positioned(
            left: 0,
            top: 599,
            child: Container(
              width: 412,
              height: 228,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(34),
                ),
              ),
            ),
          ),

          // [유지] '바로가기' 텍스트
          Positioned(
            left: 20,
            top: 638,
            child: Text(
              '바로가기',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w500,
                height: 0.80,
                letterSpacing: -0.24,
              ),
            ),
          ),

          // [유지] '집' 버튼
          Positioned(
            left: 20,
            top: 682,
            child: InkWell(
              onTap: () {
                print("집 버튼 클릭됨");
                // _findNearbyPoliceStations(); // 테스트용
              },
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: 70,
                height: 70,
                decoration: ShapeDecoration(
                  color: const Color(0xFF2567E8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.home_outlined, color: Colors.white, size: 24),
                    SizedBox(height: 5),
                    Text(
                      '집',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // [유지] '직장' 버튼
          Positioned(
            left: 121,
            top: 682,
            child: InkWell(
              onTap: () {
                print("직장 버튼 클릭됨");
              },
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: 70,
                height: 70,
                decoration: ShapeDecoration(
                  color: const Color(0xFF2567E8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.work_outline, color: Colors.white, size: 24),
                    SizedBox(height: 5),
                    Text(
                      '직장',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // [유지] '+' 버튼
          Positioned(
            left: 222,
            top: 682,
            child: InkWell(
              onTap: () {
                print("+ 버튼 클릭됨");
              },
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: 70,
                height: 70,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 3,
                      color: Color(0xFF2567E8),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Center(
                  child: Text(
                    '+',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF2567E8),
                      fontSize: 35,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // [유지] 하단 네비게이션 바 (파란 배경)
          Positioned(
            left: 0,
            top: 827,
            child: Container(
              width: 412,
              height: 90,
              decoration: const BoxDecoration(color: Color(0xFF2567E8)),
            ),
          ),

          // --- 👈 [수정] 하단 네비게이션 '설정' 아이콘 ---
          Positioned(
            left: 34, // Figma 원본 위치
            top: 842, // Figma 원본 위치
            child: InkWell( // 👈 1. InkWell로 감싸서 클릭 가능하게
              onTap: () {
                // 👈 2. 클릭 시 settings.dart의 SettingsScreen으로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
              borderRadius: BorderRadius.circular(12), // 👈 물결 효과 범위
              child: Container(
                width: 24,
                height: 24,
                child: const Icon(Icons.settings_outlined, color: Colors.white, size: 24),
              ),
            ),
          ),
          // --- 👈 수정 완료 ---

          // '홈' (Home) 아이콘 - 선택됨
          Positioned(
            left: 133,
            top: 832,
            child: Container(
              width: 40,
              height: 40,
              decoration: const ShapeDecoration(
                color: Colors.white, // 선택된 배경
                shape: OvalBorder(),
              ),
            ),
          ),
          Positioned(
            left: 141,
            top: 840,
            child: Container(
              width: 24,
              height: 24,
              child: const Icon(Icons.home, color: Color(0xFF2567E8), size: 24),
            ),
          ),

          // '링크' (Link) 아이콘
          Positioned(
            left: 248,
            top: 842,
            child: Container(
              width: 24,
              height: 24,
              child: const Icon(Icons.link_outlined, color: Colors.white, size: 24),
            ),
          ),

          // '공유' (Share) 아이콘
          Positioned(
            left: 355,
            top: 842,
            child: Container(
              width: 24,
              height: 24,
              child: const Icon(Icons.share_outlined, color: Colors.white, size: 24),
            ),
          ),

          // [유지] 상단 검색창
          Positioned(
            left: 17,
            top: 46,
            child: Container(
              width: 314,
              height: 41,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 3,
                    color: Color(0xFF2567E8),
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                children: const [
                  SizedBox(width: 12),
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    '검색...',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}