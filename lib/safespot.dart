import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart'; // 👈 [추가] geolocator import

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

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  GoogleMapController? _mapController; // 👈 [추가] 지도를 움직이기 위한 컨트롤러
  final Set<Marker> _markers = {};

  // 👈 [수정] 서울 시청은 '초기' 위치일 뿐, 실제 위치로 변경될 것임
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.5665, 126.9780), // '서울 시청' (권한 없거나 로딩 중일 때)
    zoom: 15.0,
  );

  // 👈 [추가] 실제 GPS 위치를 저장할 변수
  LatLng? _currentPosition;
  bool _isLocationLoading = true; // 👈 [추가] 위치 정보를 가져오는 중인지 확인

  @override
  void initState() {
    super.initState();
    // 👈 [수정] 앱이 시작되면 고정된 마커가 아닌, 실제 위치를 가져오도록 함
    _determinePosition();
  }

  // -------------------------------------------------------------------
  // 👈 [신규] 실제 GPS 위치와 권한을 처리하는 함수
  // -------------------------------------------------------------------
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. 위치 서비스가 켜져 있는지 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 서비스가 꺼져있으면, 서울 시청 기준으로 지도를 둠
      setState(() {
        _currentPosition = _initialCameraPosition.target; // 서울 시청
        _addMarker(); // 서울 시청에 마커 추가
        _isLocationLoading = false;
      });
      print('Location services are disabled.');
      return;
    }

    // 2. 위치 권한을 확인
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission(); // 권한 요청
      if (permission == LocationPermission.denied) {
        // 권한이 거부되면, 서울 시청 기준으로 지도를 둠
        setState(() {
          _currentPosition = _initialCameraPosition.target; // 서울 시청
          _addMarker(); // 서울 시청에 마커 추가
          _isLocationLoading = false;
        });
        print('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // 권한이 영구적으로 거부되면, 서울 시청 기준으로 지도를 둠
      setState(() {
        _currentPosition = _initialCameraPosition.target; // 서울 시청
        _addMarker(); // 서울 시청에 마커 추가
        _isLocationLoading = false;
      });
      print('Location permissions are permanently denied.');
      return;
    }

    // 3. 권한이 허용되면, 실제 GPS 위치를 가져옴
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high, // 높은 정확도
      );

      // 4. '내 위치'로 상태 업데이트
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _addMarker(); // '내 위치'에 마커 추가
        _isLocationLoading = false;
      });

      // 5. 지도 카메라를 '내 위치'로 이동시킴
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 15.0),
      );
    } catch (e) {
      print("Error getting location: $e");
      // 에러 발생 시 서울 시청 기준으로 둠
      setState(() {
        _currentPosition = _initialCameraPosition.target; // 서울 시청
        _addMarker(); // 서울 시청에 마커 추가
        _isLocationLoading = false;
      });
    }
  }
  // -------------------------------------------------------------------

  // 👈 [수정] 마커(파란 점)를 생성하는 함수
  void _addMarker() {
    // 1. 기존 마커 삭제
    _markers.clear();

    // 2. _currentPosition이 있어야만 마커 추가
    if (_currentPosition != null) {
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('blueDot'),
            position: _currentPosition!, // 👈 '내 위치' 또는 '서울 시청'
            infoWindow: const InfoWindow(title: '현재 위치'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        );
      });
    }
  }

  // 👈 [수정] '파출소' 버튼 클릭 시 실행될 함수
  void _findNearbyPoliceStations() async {
    // 1. 위치 정보가 없으면 (권한 거부 or 로딩 중) 실행 안 함
    if (_currentPosition == null) {
      print("Current position is not available.");
      // (선택사항) 사용자에게 알림 띄우기
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('위치 정보를 가져올 수 없습니다. 권한을 확인해주세요.')),
      );
      return;
    }

    // 2. '내 위치'를 기준으로 검색
    final lat = _currentPosition!.latitude;
    final lng = _currentPosition!.longitude;

    final query = Uri.encodeComponent("파출소"); // 한글 검색어

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 👈 [수정] 지도 + 로딩 인디케이터
            Expanded(
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Stack(
                  children: [
                    GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: _initialCameraPosition,
                      onMapCreated: (GoogleMapController controller) {
                        if (!_controller.isCompleted) {
                          _controller.complete(controller);
                        }
                        _mapController = controller; // 👈 [추가] 컨트롤러 저장
                      },
                      markers: _markers, // 👈 '내 위치'에 찍힌 마커
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: true,
                    ),
                    // 👈 [추가] 위치 정보를 가져오는 동안 로딩 아이콘 표시
                    if (_isLocationLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ),

            // --- 바로가기 섹션 (동일, 버튼 연결만 수정) ---
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
                          onPressed: _findNearbyPoliceStations, // 👈 [수정] '내 위치' 기준 검색
                        ),
                        _QuickButton(
                          icon: Icons.security,
                          label: "경찰서",
                          onPressed: () {
                            // TODO: 나중에 경찰서 검색 기능 구현
                            print("경찰서 버튼 클릭됨");
                          },
                        ),
                        _QuickButton(
                          icon: Icons.child_care,
                          label: "해바라기",
                          onPressed: () {
                            // TODO: 나중에 해바라기 검색 기능 구현
                          },
                        ),
                        _QuickButton(
                          icon: Icons.notifications_active,
                          label: "비상벨",
                          onPressed: () {
                            // TODO: 나중에 비상벨 검색 기능 구현
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- 하단 네비게이션 (동일) ---
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

// --- _QuickButton 위젯 (동일) ---
class _QuickButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _QuickButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
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
        ),
      ),
    );
  }
}