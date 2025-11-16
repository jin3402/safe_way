// map1.dart 파일

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// 앱 실행을 위한 메인 함수 (map1.dart를 직접 실행할 때 사용)
// 실제 프로젝트에서는 main.dart에서 이 파일을 호출합니다.
void main() {
  runApp(const MapApp());
}

class MapApp extends StatelessWidget {
  const MapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // 지도의 초기 위치를 설정합니다. (예: 서울 시청)
  static const LatLng initialLocation = LatLng(37.5665, 126.9780);

  // 카메라 컨트롤러 변수 선언
  GoogleMapController? mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map Example'),
        backgroundColor: Colors.blueAccent,
      ),
      body: GoogleMap(
        // 지도 생성 시 호출되는 콜백 함수
        onMapCreated: _onMapCreated,

        // 지도가 처음 로드될 때의 카메라 위치
        initialCameraPosition: const CameraPosition(
          target: initialLocation,
          zoom: 14.0, // 줌 레벨 (14.0은 일반적인 도시 뷰)
        ),

        // 기타 옵션
        mapType: MapType.normal, // 일반 지도 타입
        myLocationEnabled: true, // 내 위치 버튼 표시
        zoomControlsEnabled: true, // 줌 컨트롤 표시
      ),
    );
  }
}