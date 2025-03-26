import 'package:dio/dio.dart';
import 'package:fe_capstone/constant/base_constant.dart';
import 'package:fe_capstone/main.dart';
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
  late List<dynamic> parkingList = [
    {
      "ploID": "PLO000000002",
      "parkingName": "Bãi xe Vincom Biên Hòa",
      "address": "789 Park Street, City",
      "distance": 0.012026901688146576,
      "price": 10000,
      "currentTime": "2025-03-24T20:15:19",
      "slot": 30,
      "longitude": 106.842994,
      "latitude": 10.957718,
      "price": 50000
    },
    {
      "ploID": "PLO000000001",
      "parkingName": "Bãi gửi xe Tiến Nghĩa",
      "address": "456 Park Street, City",
      "distance": 0.10433771397587333,
      "price": 10000,
      "currentTime": "2025-03-24T20:15:19",
      "slot": 40,
      "longitude": 106.843573,
      "latitude": 10.958361,
      "price": 1000000
    }
  ];

  late TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onFocusChange);
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

  Marker _buildParkingMarker(dynamic parking) {
    return Marker(
      alignment: Alignment.bottomCenter,
      width: 80,
      height: 80,
      child: GestureDetector(
        onTap: () {
          _showParkingInfoDialog(parking);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              child: Icon(
                Icons.local_parking_outlined,
                color: Colors.green,
                size: 40,
              ),
            ),
            Container(
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
                parking['parkingName'],
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      latLng: LatLng(
        parking['latitude'] as double,
        parking['longitude'] as double,
      ),
    );
  }

  void _showParkingInfoDialog(dynamic parking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(parking['parkingName']),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(Icons.location_on, parking['address']),
              _buildInfoRow(Icons.attach_money, '${parking['price']} VND'),
              _buildInfoRow(Icons.local_parking, '${parking['slot']} chỗ trống'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blue),
          SizedBox(width: 8),
          Expanded(child: Text(text)),
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
              CameraPosition(
                  target: LatLng(lat, long),
                  zoom: 17,
                  tilt: 30
              )
          ));
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
            top: 180 * fem,
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
              EdgeInsets.fromLTRB(14 * fem, 62 * fem, 14 * fem, 26 * fem),
              width: double.infinity,
              height: 200 * fem,
              decoration: BoxDecoration(
                color: Color(0xff6ec2f7),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(23 * fem),
                  bottomLeft: Radius.circular(23 * fem),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 0 * fem, 30 * fem),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 248.88 * fem, 0 * fem),
                          child: Text(
                            'SCPM',
                            style: TextStyle(
                              fontSize: 30 * ffem,
                              fontWeight: FontWeight.w600,
                              height: 1.2175 * ffem / fem,
                              fontStyle: FontStyle.italic,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                    EdgeInsets.fromLTRB(2 * fem, 0 * fem, 0 * fem, 0 * fem),
                    padding: EdgeInsets.fromLTRB(
                        19 * fem, 0 * fem, 14 * fem, 0 * fem),
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.circular(9 * fem),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 46 * fem,
                          width: 280 * fem,
                          child: TextFormField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: 'Bạn muốn đi đến đâu?',
                              border: InputBorder.none,
                            ),
                            onChanged: (value) async {
                              if (!canPerformSearch) {
                                return;
                              }
                              performAutoSearch(value);
                              setState(() {
                                showSearchResults = true;
                              });
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 9 * fem, 0 * fem),
                          width: 1 * fem,
                          height: 46 * fem,
                          decoration: BoxDecoration(
                            color: Color(0x7f000000),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            performAutoSearch(_searchController.text);
                            setState(() {
                              showSearchResults = true;
                            });
                          },
                          child: Container(
                            width: 16 * fem,
                            height: 16 * fem,
                            child: Icon(
                              Icons.search,
                            ),
                          ),
                        ),
                      ],
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