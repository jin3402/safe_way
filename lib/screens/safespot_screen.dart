import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'home_screen.dart';              // ✅ 같은 폴더
import 'spot_share_screen.dart';        // ✅ 같은 폴더
import 'settings_screen.dart';

class SafeSpotScreen extends StatefulWidget {
  const SafeSpotScreen({Key? key}) : super(key: key);

  @override
  State<SafeSpotScreen> createState() => _SafeSpotScreenState();
}

class _SafeSpotScreenState extends State<SafeSpotScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  // 초기 위치 - 서울 시청
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.5665, 126.9780),
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

  // 마커 추가 함수
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

  // 파출소 검색 함수
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

  // 경찰서 검색 함수
  Future<void> _findNearbyPoliceOffices() async {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('위치 정보를 가져올 수 없습니다. 권한을 확인해주세요.'),
        ),
      );
      return;
    }

    final lat = _currentPosition!.latitude;
    final lng = _currentPosition!.longitude;
    final query = Uri.encodeComponent("경찰서");
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$query&location=$lat,$lng',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('Could not launch $url');
    }
  }

  // 해바라기센터 검색 함수
  Future<void> _findHabaragiCenters() async {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('위치 정보를 가져올 수 없습니다. 권한을 확인해주세요.'),
        ),
      );
      return;
    }

    final lat = _currentPosition!.latitude;
    final lng = _currentPosition!.longitude;
    final query = Uri.encodeComponent("해바라기");
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$query&location=$lat,$lng',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('Could not launch $url');
    }
  }

  // 비상벨 검색 함수
  Future<void> _findEmergencyAlerts() async {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('위치 정보를 가져올 수 없습니다. 권한을 확인해주세요.'),
        ),
      );
      return;
    }

    final lat = _currentPosition!.latitude;
    final lng = _currentPosition!.longitude;
    final query = Uri.encodeComponent("비상벨");
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 지도 영역
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
                      '안전시설',
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
                          onPressed: _findNearbyPoliceStations,
                        ),
                        _QuickButton(
                          icon: Icons.security,
                          label: "경찰서",
                          onPressed: _findNearbyPoliceOffices,
                        ),
                        _QuickButton(
                          icon: Icons.child_care,
                          label: "해바라기",
                          onPressed: _findHabaragiCenters,
                        ),
                        _QuickButton(
                          icon: Icons.notifications_active,
                          label: "비상벨",
                          onPressed: _findEmergencyAlerts,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 하단 네비게이션 바
            Container(
              height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFF2567E8),
              ),
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

                  // 안전시설 아이콘 (현재 선택됨)
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_police,
                      color: Color(0xFF2567E8),
                      size: 28,
                    ),
                  ),

                  // 홈 아이콘
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.home_outlined,
                      color: Colors.white,
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
          ],
        ),
      ),
    );
  }
}

// QuickButton 위젯
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