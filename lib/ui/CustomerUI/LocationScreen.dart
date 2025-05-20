import 'package:dio/dio.dart';
import 'package:fe_capstone/constant/base_constant.dart';
import 'package:fe_capstone/main.dart';
import 'package:fe_capstone/models/parking_lot_model.dart';
import 'package:fe_capstone/service/data_service.dart';
import 'package:fe_capstone/ui/CustomerUI/parking-management/ListParkingScreen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

class LocationScreen extends StatefulWidget {
  @override
  _ContractScreenState createState() => _ContractScreenState();
}

class _ContractScreenState extends State<LocationScreen> {
  FocusNode _searchFocusNode = FocusNode();
  bool showSearchResults = false;
  VietmapController? _mapController;
  List<Marker> temp = [];
  UserLocation? userLocation;
  List<dynamic> autoSearchResults = [];
  late double lat;
  late double long;
  late List<ParkingLot> parkingList = [];
  final DataService _dataService = DataService();

  late TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onFocusChange);
    _loadParkingLots();
  }

  Future<void> _loadParkingLots() async {
    final parkingLots = await _dataService.searchParkingLots();
    setState(() {
      parkingList = parkingLots;
    });
  }

  String _formatPrice(double price) {
    String priceStr = price.toStringAsFixed(0);
    String result = '';
    int count = 0;

    for (int i = priceStr.length - 1; i >= 0; i--) {
      count++;
      result = priceStr[i] + result;
      if (count % 3 == 0 && i > 0) {
        result = '.' + result;
      }
    }
    return result;
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onFocusChange);
    _searchController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_searchFocusNode.hasFocus) {
      setState(() {
        showSearchResults = false;
      });
    }
  }

  void _onMapCreated(VietmapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  void liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      lat = position.latitude;
      long = position.longitude;
    });
  }

  Future<Position> _getCurrentLocation() async {
    bool serverEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serverEnabled) {
      return Future.error('Location services are disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location services are disabled');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permission are permanently denied disabled, We cannot request permission');
    }
    return await Geolocator.getCurrentPosition();
  }

  bool canPerformSearch = true;

  void performAutoSearch(String searchText) async {
    String url =
        '${BaseConstants.VIETMAP_URL}/autocomplete/v3?apikey=${BaseConstants.VIET_MAP_APIKEY}&text=$searchText';
    try {
      var dio = Dio();
      var response = await dio.get(url);
      if (response.statusCode == 200) {
        var data = response.data;
        setState(() {
          autoSearchResults = data;
        });
      } else {
        print('AutoSearch Request Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('AutoSearch Request Failed with error: $e');
    }
  }

  Marker _buildParkingMarker(ParkingLot parking) {
    return Marker(
      alignment: Alignment.center,
      width: 60,
      height: 60,
      child: GestureDetector(
        onTap: () {
          _showParkingInfoDialog(parking);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 0,
              child: Icon(
                Icons.local_parking_outlined,
                color: Colors.green,
                size: 40,
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Text(
                  parking.address,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
      latLng: LatLng(
        parking.lat as double,
        parking.long as double,
      ),
    );
  }

  void _showParkingInfoDialog(ParkingLot parking) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5,
                width: 40,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.redAccent, size: 28),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      parking.address,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(color: Colors.grey.shade300),
              SizedBox(height: 10),
              _infoRow(Icons.attach_money, 'Giá theo giờ',
                  '${_formatPrice(parking.pricePerHour ?? 0)} VND'),
              _infoRow(Icons.calendar_today, 'Giá theo ngày',
                  '${_formatPrice(parking.pricePerDay ?? 0)} VND'),
              _infoRow(Icons.calendar_month, 'Giá theo tháng',
                  '${_formatPrice(parking.pricePerMonth ?? 0)} VND'),
              Spacer(),
              SizedBox(
                height: 38,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("Đóng", style: TextStyle(fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          SizedBox(width: 12),
          Text(
            "$label:",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  void getLatAndLong(String refId) async {
    String url =
        "${BaseConstants.VIETMAP_URL}/place/v3?apikey=${BaseConstants.VIET_MAP_APIKEY}&refid=$refId";
    try {
      var dio = Dio();
      var response = await dio.get(url);
      if (response.statusCode == 200) {
        var data = response.data;
        setState(() {
          lat = data['lat'];
          long = data['lng'];
          temp.clear();

          temp.add(Marker(
            alignment: Alignment.bottomCenter,
            width: 50,
            height: 50,
            child: Container(
              width: 50,
              height: 50,
              child: Icon(
                Icons.location_on_outlined,
                color: Colors.red,
                size: 40,
              ),
            ),
            latLng: LatLng(lat, long),
          ));

          if (parkingList.isNotEmpty) {
            for (var parking in parkingList) {
              temp.add(_buildParkingMarker(parking));
            }
          }

          _mapController?.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(lat, long), zoom: 17, tilt: 30)));
        });
      } else {
        print('AutoSearch Request Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('AutoSearch Request Failed with error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 120 * fem,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 400 * fem,
              child: VietmapGL(
                myLocationEnabled: true,
                styleString:
                    '${BaseConstants.VIETMAP_URL}/maps/light/styles.json?apikey=${BaseConstants.VIET_MAP_APIKEY}',
                trackCameraPosition: true,
                onMapCreated: _onMapCreated,
                compassEnabled: false,
                onMapRenderedCallback: () {
                  _mapController?.animateCamera(CameraUpdate.newCameraPosition(
                      const CameraPosition(
                          target: LatLng(10.739031, 106.680524),
                          zoom: 10,
                          tilt: 60)));
                },
                onUserLocationUpdated: (location) {
                  setState(() {
                    userLocation = location;
                  });
                },
                initialCameraPosition: CameraPosition(
                    target: LatLng(10.739031, 106.680524), zoom: 14),
                onMapClick: (point, coordinates) async {
                  var data =
                      await _mapController?.queryRenderedFeatures(point: point);
                },
              ),
            ),
          ),
          if (_mapController != null)
            Positioned(
              top: 200 * fem,
              left: 0,
              right: 0,
              bottom: 0,
              child: MarkerLayer(
                ignorePointer: false,
                mapController: _mapController!,
                markers: temp,
              ),
            ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding:
                  EdgeInsets.fromLTRB(14 * fem, 52 * fem, 14 * fem, 10 * fem),
              width: double.infinity,
              height: 120 * fem,
              decoration: BoxDecoration(
                color: Colors.green.shade600,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(24 * fem),
                  bottomLeft: Radius.circular(24 * fem),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 8 * fem),
                      Text(
                        'Quay lại',
                        style: TextStyle(
                          fontSize: 30 * ffem,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 2,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 110,
                    left: 16,
                    right: 16,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(12),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            performAutoSearch(value);
                            setState(() {
                              showSearchResults = true;
                            });
                          } else {
                            setState(() {
                              showSearchResults = false;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm địa chỉ (Vietmap)...',
                          prefixIcon: Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 182,
            left: 0,
            right: 0,
            child: showSearchResults
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16 * fem),
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: 50 * fem,
                        maxHeight: 220 * fem,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12 * fem),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: autoSearchResults.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(autoSearchResults[index]['name']),
                            subtitle: Text(autoSearchResults[index]['address']),
                            onTap: () {
                              var selectedResult =
                                  autoSearchResults[index]['ref_id'];
                              getLatAndLong(selectedResult);
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {
                                showSearchResults = false;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 35 * fem,
            width: 35 * fem,
            decoration: BoxDecoration(color: Colors.transparent),
            child: FloatingActionButton(
              tooltip: 'Vị trí hiện tại',
              backgroundColor: Colors.white,
              onPressed: () async {
                if (!canPerformSearch) {
                  return;
                }
                _getCurrentLocation().then((value) async {
                  lat = double.parse('${value.latitude}');
                  long = double.parse('${value.longitude}');
                  print("Vị trí của tôi là: $lat - $long");
                  liveLocation();
                  temp.clear();
                  _mapController?.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: LatLng(value.latitude, value.longitude),
                          zoom: 17,
                          tilt: 60)));
                  temp.add(Marker(
                      alignment: Alignment.bottomCenter,
                      width: 50,
                      height: 50,
                      child: Container(
                        width: 50,
                        height: 50,
                        child: Icon(
                          Icons.location_on_outlined,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                      latLng: LatLng(value.latitude, value.longitude)));

                  if (parkingList.isNotEmpty) {
                    for (var parking in parkingList) {
                      temp.add(_buildParkingMarker(parking));
                    }
                  }
                });
              },
              child: Icon(
                Icons.location_searching,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
