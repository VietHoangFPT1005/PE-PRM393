import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchCtrl = TextEditingController();

  LatLng _center = const LatLng(10.7769, 106.7009); // Mặc định: HCM
  LatLng? _markerLocation;
  String? _markerLabel;
  bool _isSearching = false;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Load students trước
      await context.read<StudentProvider>().fetchAll();

      if (!mounted) return;

      // Lấy email của user đang đăng nhập
      final authProvider = context.read<AuthProvider>();
      final currentEmail = authProvider.currentUser?.email;

      if (currentEmail == null) return; // Chưa đăng nhập → bỏ qua

      // Tìm student có email trùng với tài khoản đăng nhập
      final students = context.read<StudentProvider>().students;
      final matchedStudent = students.where(
        (s) => s.email?.toLowerCase() == currentEmail.toLowerCase(),
      ).firstOrNull;

      if (matchedStudent == null) return; // Không tìm thấy student

      if (matchedStudent.address == null || matchedStudent.address!.isEmpty) {
        return; // Student không có địa chỉ
      }

      // Có địa chỉ → điền vào ô search và tự search
      _searchCtrl.text = matchedStudent.address!;
      _searchAddress(matchedStudent.address!, label: matchedStudent.name);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _searchAddress(String address, {String? label}) async {
    setState(() {
      _isSearching = true;
      _errorMsg = null;
    });

    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search'
        '?q=${Uri.encodeFull(address)}&format=json&limit=1',
      );
      final response = await http.get(
        url,
        headers: {'User-Agent': 'pe_prm393_flutter_app'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          final location = LatLng(lat, lon);

          setState(() {
            _markerLocation = location;
            _markerLabel = label ?? address;
            _center = location;
            _isSearching = false;
          });

          _mapController.move(location, 14);
        } else {
          setState(() {
            _errorMsg = 'Address not found.';
            _isSearching = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMsg = 'Error: $e';
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthProvider>().isLoggedIn;

    return Scaffold(
      appBar: AppBar(title: const Text('Student Map')),
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 12,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.pe_prm393',
              ),
              if (_markerLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _markerLocation!,
                      width: 140,
                      height: 60,
                      child: Column(
                        children: [
                          const Icon(Icons.location_pin,
                              color: Colors.red, size: 32),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            color: Colors.white,
                            child: Text(
                              _markerLabel ?? '',
                              style: const TextStyle(fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Search bar
          Positioned(
            top: 12, left: 12, right: 12,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: isLoggedIn
                      ? 'Your address...'
                      : 'Sign in to see your location',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _isSearching
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() {
                              _markerLocation = null;
                              _errorMsg = null;
                            });
                          },
                        ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    _searchAddress(value.trim());
                  }
                },
              ),
            ),
          ),

          // Thông báo chưa đăng nhập
          if (!isLoggedIn)
            Positioned(
              bottom: 16, left: 16, right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                color: Colors.black54,
                child: const Text(
                  'Sign in with Google to see your location on the map',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // Error message
          if (_errorMsg != null)
            Positioned(
              top: 72, left: 12, right: 12,
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.red.shade100,
                child: Text(_errorMsg!, textAlign: TextAlign.center),
              ),
            ),
        ],
      ),
    );
  }
}
