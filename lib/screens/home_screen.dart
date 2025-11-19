import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'safespot_screen.dart';          // ✅ 같은 폴더라서 경로 수정
import 'spot_share_screen.dart';        // ✅ 같은 폴더라서 경로 수정
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  // 초기 카메라는 신한대학교
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.739, 127.081),
    zoom: 15.0,
  );

  LatLng? _currentPosition;
  bool _isLocationLoading = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  // GPS 위치와 권한을 처리하는 함수
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentPosition = _initialCameraPosition.target;
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
          _currentPosition = _initialCameraPosition.target;
          _addMarker();
          _isLocationLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentPosition = _initialCameraPosition.target;
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
        _addMarker();
        _isLocationLoading = false;
      });
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 15.0),
      );
    } catch (e) {
      print("Error getting location: $e");
      setState(() {
        _currentPosition = _initialCameraPosition.target;
        _addMarker();
        _isLocationLoading = false;
      });
    }
  }

  // 마커를 생성하는 함수
  void _addMarker() {
    _markers.clear();
    if (_currentPosition != null) {
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('blueDot'),
            position: _currentPosition!,
            infoWindow: const InfoWindow(title: '현재 위치'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
          ),
        );
      });
    }
  }

  // '파출소' 검색 함수
  Future<void> _findNearbyPoliceStations() async {
    if (_currentPosition == null) {
      print("Current position is not available.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('위치 정보를 가져올 수 없습니다. 권한을 확인해주세요.'),
        ),
      );
      return;
    }

    final lat = _currentPosition!.latitude;
    final lng = _currentPosition!.longitude;
    final query = Uri.encodeComponent("파출소");
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$query&location=$lat,$lng',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            // 1. GoogleMap 위젯
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.67,
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

            // 2. 상단 검색창
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

            // 3. '길찾기' 버튼
            Positioned(
              left: 343,
              top: 46,
              child: InkWell(
                onTap: () {
                  print("길찾기 버튼 클릭됨");
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 53,
                  height: 41,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF2567E8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '길찾기',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 4. 하단 흰색 패널
            Positioned(
              left: 0,
              top: MediaQuery.of(context).size.height * 0.65,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(34),
                  ),
                ),
              ),
            ),

            // 5. '바로가기' 텍스트
            Positioned(
              left: 20,
              top: MediaQuery.of(context).size.height * 0.69,
              child: const Text(
                '바로가기',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // 6. '집' 버튼
            Positioned(
              left: 20,
              top: MediaQuery.of(context).size.height * 0.745,
              child: InkWell(
                onTap: () {
                  print("집 버튼 클릭됨");
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

            // 7. '직장' 버튼
            Positioned(
              left: 121,
              top: MediaQuery.of(context).size.height * 0.745,
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

            // 8. '+' 버튼
            Positioned(
              left: 222,
              top: MediaQuery.of(context).size.height * 0.745,
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
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 9. 하단 네비게이션 바
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 90,
                decoration: const BoxDecoration(color: Color(0xFF2567E8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // 설정 아이콘
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.settings_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),

                    // 안전시설 아이콘
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SafeSpotScreen(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.local_police_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),

                    // 홈 아이콘 (현재 선택됨)
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.home,
                        color: Color(0xFF2567E8),
                        size: 28,
                      ),
                    ),

                    // 위치 공유 아이콘
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SpotShareScreen(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.share_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}