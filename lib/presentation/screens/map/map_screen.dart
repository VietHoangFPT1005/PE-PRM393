import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final String? address; // optional - nếu truyền vào thì tự search luôn
  final String? name;

  const MapScreen({super.key, this.address, this.name});

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
    // Nếu được truyền địa chỉ từ StudentDetail thì tự search
    if (widget.address != null && widget.address!.isNotEmpty) {
      _searchCtrl.text = widget.address!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchAddress(widget.address!, label: widget.name);
      });
    }
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
            _errorMsg = 'Address not found. Try a more specific address.';
            _isSearching = false;
          });
        }
      } else {
        setState(() {
          _errorMsg = 'Search failed. Check internet connection.';
          _isSearching = false;
        });
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
    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: Stack(
        children: [
          // Map layer
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
                      width: 160,
                      height: 70,
                      child: Column(
                        children: [
                          const Icon(Icons.location_pin,
                              color: Colors.red, size: 36),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black26, blurRadius: 4)
                              ],
                            ),
                            child: Text(
                              _markerLabel ?? '',
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Search bar nổi trên map
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(12),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Search address...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _isSearching
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
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
                    borderRadius: BorderRadius.circular(12),
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

          // Error message
          if (_errorMsg != null)
            Positioned(
              top: 80,
              left: 12,
              right: 12,
              child: Material(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    _errorMsg!,
                    style: TextStyle(color: Colors.red.shade800),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
