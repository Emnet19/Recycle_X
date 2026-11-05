

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/constants/app_colors.dart';

class NearbyCollectorsPage extends StatefulWidget {
  const NearbyCollectorsPage({super.key});

  @override
  State<NearbyCollectorsPage> createState() => _NearbyCollectorsPageState();
}

class _NearbyCollectorsPageState extends State<NearbyCollectorsPage> {
  late GoogleMapController _mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  List<Collector> _collectors = [];
  bool _isLoading = true;
  String _selectedFilter = 'all';

  // Sample collector data
  final List<Collector> _allCollectors = [
    Collector(
      id: '1',
      name: 'Green Waste Solutions',
      location: LatLng(9.0054, 38.7636), // Addis Ababa coordinates
      address: 'Bole, Addis Ababa',
      rating: 4.8,
      reviews: 128,
      type: 'Company',
      status: 'Available',
      distance: 1.2,
      phone: '+251 911 234 567',
      workingHours: '8 AM - 6 PM',
      services: ['Plastic', 'Paper', 'Glass'],
      imageUrl: 'https://example.com/collector1.jpg',
    ),
    Collector(
      id: '2',
      name: 'Green Community Team',
      location: LatLng(9.0100, 38.7700),
      address: 'Megenagna, Addis Ababa',
      rating: 4.9,
      reviews: 142,
      type: 'Community Collector',
      status: 'Available',
      distance: 1.8,
      phone: '+251 912 345 678',
      workingHours: '8 AM - 6 PM',
      services: ['Plastic', 'Metal', 'Glass', 'Paper'],
      imageUrl: 'https://example.com/collector2.jpg',
    ),
    Collector(
      id: '3',
      name: 'Kebele 08 Municipal Team',
      location: LatLng(9.0150, 38.7550),
      address: 'Kazanchis Kebele 08, Addis Ababa',
      rating: 4.9,
      reviews: 256,
      type: 'Kebele Collector',
      status: 'Available',
      distance: 2.1,
      phone: '+251 913 456 789',
      workingHours: '7 AM - 6 PM',
      services: ['Plastic', 'Organic', 'Paper', 'Glass'],
      imageUrl: 'https://example.com/collector3.jpg',
    ),
    Collector(
      id: '4',
      name: 'Kebele 03 Municipal Sanitation',
      location: LatLng(8.9950, 38.7500),
      address: 'Piassa Kebele 03, Addis Ababa',
      rating: 4.7,
      reviews: 89,
      type: 'Kebele Collector',
      status: 'Available',
      distance: 3.4,
      phone: '+251 914 567 890',
      workingHours: '7 AM - 5 PM',
      services: ['Plastic', 'Paper', 'Hazardous'],
      imageUrl: 'https://example.com/collector4.jpg',
    ),
    Collector(
      id: '5',
      name: 'Youth Eco Action Cooperative',
      location: LatLng(9.0200, 38.7800),
      address: 'CMC Zone 2, Addis Ababa',
      rating: 4.8,
      reviews: 115,
      type: 'Community Collector',
      status: 'Available',
      distance: 4.2,
      phone: '+251 915 678 901',
      workingHours: '8 AM - 6 PM',
      services: ['Plastic', 'Electronics', 'Metal'],
      imageUrl: 'https://example.com/collector5.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadCollectors();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enable location services')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permissions are permanently denied')),
      );
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      
      setState(() {
        _currentPosition = position;
      });

      // Move camera to current location
      _mapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude),
        ),
      );

      // Add current location marker
      _addCurrentLocationMarker();
    } catch (e) {
      // Use default location (Addis Ababa)
      setState(() {
        _currentPosition = Position(
          latitude: 9.0054,
          longitude: 38.7636,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          heading: 0.0,
          headingAccuracy: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        );
      });
    }
  }

  void _addCurrentLocationMarker() {
    if (_currentPosition != null) {
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('current_location'),
            position: LatLng(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
            infoWindow: InfoWindow(title: 'Your Location'),
          ),
        );
      });
    }
  }

  void _loadCollectors() {
    // Simulate API call delay
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _collectors = _allCollectors;
        _addCollectorMarkers();
        _isLoading = false;
      });
    });
  }

  void _addCollectorMarkers() {
    Set<Marker> newMarkers = {};
    
    for (var collector in _collectors) {
      newMarkers.add(
        Marker(
          markerId: MarkerId(collector.id),
          position: collector.location,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            collector.status == 'Available' 
              ? BitmapDescriptor.hueGreen 
              : BitmapDescriptor.hueOrange,
          ),
          infoWindow: InfoWindow(
            title: collector.name,
            snippet: '${collector.distance}km away',
          ),
          onTap: () => _showCollectorDetails(collector),
        ),
      );
    }
    
    setState(() {
      _markers = newMarkers;
    });
  }

  void _showCollectorDetails(Collector collector) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => CollectorDetailsSheet(collector: collector),
    );
  }

  void _filterCollectors(String filter) {
    setState(() {
      _selectedFilter = filter;
      if (filter == 'available') {
        _collectors = _allCollectors.where((c) => c.status == 'Available').toList();
      } else if (filter == 'kebele') {
        _collectors = _allCollectors.where((c) => c.type == 'Kebele Collector').toList();
      } else if (filter == 'community') {
        _collectors = _allCollectors.where((c) => c.type == 'Community Collector').toList();
      } else if (filter == 'company') {
        _collectors = _allCollectors.where((c) => c.type == 'Company').toList();
      } else {
        _collectors = _allCollectors;
      }
      _addCollectorMarkers();
    });
  }

  void _sortCollectors(String sortBy) {
    setState(() {
      if (sortBy == 'distance') {
        _collectors.sort((a, b) => a.distance.compareTo(b.distance));
      } else if (sortBy == 'rating') {
        _collectors.sort((a, b) => b.rating.compareTo(a.rating));
      } else if (sortBy == 'name') {
        _collectors.sort((a, b) => a.name.compareTo(b.name));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Map Section
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(9.0054, 38.7636), // Addis Ababa
                    zoom: 12,
                  ),
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: true,
                ),
                
                // Location Button
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.white,
                    onPressed: _getCurrentLocation,
                    child: const Icon(Icons.my_location, color: AppColors.greenText),
                  ),
                ),
              ],
            ),
          ),
          
          // Collectors List Section
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Nearby Collectors',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.greenText,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            setState(() => _isLoading = true);
                            _loadCollectors();
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  // Filter Chips
                  SizedBox(
                    height: 48,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildFilterChip('All', 'all'),
                        _buildFilterChip('Kebele Collectors', 'kebele'),
                        _buildFilterChip('Community Collectors', 'community'),
                        _buildFilterChip('Companies', 'company'),
                        _buildFilterChip('Available', 'available'),
                      ],
                    ),
                  ),
                  
                  // Sort Dropdown
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.sort, size: 20, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text('Sort by:', style: TextStyle(color: Colors.grey[600])),
                        const SizedBox(width: 8),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: 'distance',
                            items: const [
                              DropdownMenuItem(value: 'distance', child: Text('Distance')),
                              DropdownMenuItem(value: 'rating', child: Text('Rating')),
                              DropdownMenuItem(value: 'name', child: Text('Name')),
                            ],
                            onChanged: (value) => _sortCollectors(value!),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Collectors List
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _collectors.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No collectors found in your area',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(8),
                                itemCount: _collectors.length,
                                itemBuilder: (context, index) {
                                  return CollectorCard(
                                    collector: _collectors[index],
                                    onTap: () => _showCollectorDetails(_collectors[index]),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Request Pickup Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/schedule-pickup');
        },
        backgroundColor: AppColors.buttonGreen,
        foregroundColor: AppColors.greenText,
        icon: const Icon(Icons.local_shipping_rounded, color: AppColors.greenText),
        label: const Text(
          'Request Pickup',
          style: TextStyle(
            color: AppColors.greenText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => _filterCollectors(value),
        selectedColor: AppColors.buttonGreen.withValues(alpha: 0.35),
        backgroundColor: Colors.grey.shade100,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.greenText : Colors.grey.shade800,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

// Collector Model
class Collector {
  final String id;
  final String name;
  final LatLng location;
  final String address;
  final double rating;
  final int reviews;
  final String type;
  final String status;
  final double distance;
  final String phone;
  final String workingHours;
  final List<String> services;
  final String imageUrl;

  Collector({
    required this.id,
    required this.name,
    required this.location,
    required this.address,
    required this.rating,
    required this.reviews,
    required this.type,
    required this.status,
    required this.distance,
    required this.phone,
    required this.workingHours,
    required this.services,
    required this.imageUrl,
  });
}

// Collector Card Widget
class CollectorCard extends StatelessWidget {
  final Collector collector;
  final VoidCallback onTap;

  const CollectorCard({
    super.key,
    required this.collector,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(collector.imageUrl),
              fit: BoxFit.cover,
              onError: (error, stackTrace) => Icon(
                Icons.person,
                color: Colors.green[700],
              ),
            ),
          ),
        ),
        title: Text(
          collector.name,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${collector.distance.toStringAsFixed(1)} km • ${collector.address}',
                    style: TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, size: 14, color: Colors.amber),
                SizedBox(width: 2),
                Text(
                  '${collector.rating} (${collector.reviews})',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: collector.status == 'Available' 
                      ? Colors.green[100] 
                      : Colors.orange[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    collector.status,
                    style: TextStyle(
                      fontSize: 10,
                      color: collector.status == 'Available' 
                        ? Colors.green[800] 
                        : Colors.orange[800],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

// Collector Details Sheet
class CollectorDetailsSheet extends StatelessWidget {
  final Collector collector;

  const CollectorDetailsSheet({
    super.key,
    required this.collector,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          SizedBox(height: 20),
          
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(collector.imageUrl),
                    fit: BoxFit.cover,
                    onError: (error, stackTrace) => Icon(
                      Icons.person,
                      color: Colors.green[700],
                      size: 40,
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      collector.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.business, size: 16, color: Colors.grey[600]),
                        SizedBox(width: 4),
                        Text(collector.type, style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
              ),
              
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: collector.status == 'Available' 
                    ? Colors.green[100] 
                    : Colors.orange[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  collector.status,
                  style: TextStyle(
                    color: collector.status == 'Available' 
                      ? Colors.green[800] 
                      : Colors.orange[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 20),
          
          Divider(),
          
          // Details Grid
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              _buildDetailItem(Icons.location_on, 'Distance', '${collector.distance} km'),
              _buildDetailItem(Icons.phone, 'Phone', collector.phone),
              _buildDetailItem(Icons.access_time, 'Hours', collector.workingHours),
              _buildDetailItem(Icons.star, 'Rating', '${collector.rating} (${collector.reviews})'),
            ],
          ),
          
          SizedBox(height: 20),
          
          Text(
            'Services Provided:',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          
          SizedBox(height: 8),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: collector.services.map((service) {
              return Chip(
                label: Text(service),
                backgroundColor: Colors.green[50],
                labelStyle: TextStyle(color: Colors.green[800]),
              );
            }).toList(),
          ),
          
          SizedBox(height: 30),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Call collector
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.green[700]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone, color: Colors.green[700]),
                      SizedBox(width: 8),
                      Text('Call', style: TextStyle(color: Colors.green[700])),
                    ],
                  ),
                ),
              ),
              
              SizedBox(width: 16),
              
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Request pickup from this collector
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Pickup request sent to ${collector.name}'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.local_shipping),
                      SizedBox(width: 8),
                      Text('Request Pickup'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green[700]),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              SizedBox(height: 2),
              Text(value, style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}




