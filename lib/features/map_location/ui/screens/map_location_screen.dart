import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui';

class MapLocationScreen extends StatefulWidget {
  const MapLocationScreen({super.key});

  @override
  State<MapLocationScreen> createState() => _MapLocationScreenState();
}

class _MapLocationScreenState extends State<MapLocationScreen> {
  MapLibreMapController? _mapController;
  LatLng _selectedLocation = const LatLng(30.0444, 31.2357); // Default to Cairo
  bool _isLoading = true;
  bool _isPermissionDenied = false;
  String? _mapStyleJson;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _loadMapStyle() async {
    try {
      final style = await rootBundle.loadString('assets/data/map_style.json');
      if (mounted) {
        setState(() {
          _mapStyleJson = style;
        });
      }
    } catch (e) {
      debugPrint('Error loading map style: $e');
    }
  }

  Future<void> _checkPermissions() async {
    await _loadMapStyle();
    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isPermissionDenied = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isPermissionDenied = true;
        });
      }
    }
  }

  void _onMapCreated(MapLibreMapController controller) {
    _mapController = controller;
  }

  void _onCameraIdle() async {
    if (_mapController == null) return;

    final center = _mapController!.cameraPosition?.target;
    if (center != null) {
      if (mounted) {
        setState(() {
          _selectedLocation = center;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isPermissionDenied) {
      return _buildPermissionDeniedView();
    }

    return Scaffold(
      body: Stack(
        children: [
          // Map Background
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : MapLibreMap(
                  onMapCreated: _onMapCreated,
                  onCameraIdle: _onCameraIdle,
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation,
                    zoom: 14.0,
                  ),
                  zoomGesturesEnabled: true,
                  // Using positron style as it matches the reference image and is more reliable
                  styleString:
                      _mapStyleJson ??
                      'https://tiles.openfreemap.org/styles/positron',
                ),

          // Center Marker (Static - Matching Reference Image)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 45), // Offset for pin tip
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Shadow
                  Icon(
                    Icons.location_on_rounded,
                    size: 54,
                    color: Colors.black.withOpacity(0.1),
                  ),
                  // Outer Pin
                  const Icon(
                    Icons.location_on_rounded,
                    size: 48,
                    color: Color(0xFF2563EB),
                  ),
                  // White Circle with Icon
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.business_rounded,
                      size: 14,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Top Header (Glassmorphic)
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: Color(0xFF6366F1),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          'Pick a location',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Color(0xFF64748B),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom Selection Card (Premium Design)
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SliverButton(
                    onPressed: () {
                      Navigator.pop(context, _selectedLocation);
                    },
                    label: 'Confirm Location',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionDeniedView() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/Rejected.json',
                width: 200,
                height: 200,
                repeat: false,
              ),
              const SizedBox(height: 32),
              Text(
                'Location Access Denied',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'We need your location to show you nearby workouts and allow you to pick locations on the map.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: const Color(0xFF64748B),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SliverButton(
                onPressed: () async {
                  await openAppSettings();
                },
                label: 'Open Settings',
              ),
              TextButton(
                onPressed: () {
                  _checkPermissions();
                },
                child: Text(
                  'Try Again',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF6366F1),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SliverButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const SliverButton({super.key, required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
