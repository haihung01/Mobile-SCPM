import 'package:fe_capstone/service/data_service.dart';
import 'package:fe_capstone/ui/CustomerUI/contract/ContractScreen.dart';
import 'package:flutter/material.dart';
import 'package:fe_capstone/models/parking_lot_model.dart';
import 'package:fe_capstone/models/car_model.dart';

class ListParkingScreen extends StatefulWidget {
  @override
  _ListParkingScreenState createState() => _ListParkingScreenState();
}

class _ListParkingScreenState extends State<ListParkingScreen> {
  Car? selectedCar;
  ParkingLot? selectedParking;
  int selectedMonthDuration = 1;
  String totalCost = '0đ';
  List<ParkingLot> parkingLots = [];
  List<Car> cars = [];
  bool isLoading = true;
  bool isLoadingCars = true;
  String? errorMessage;
  final DataService _dataService = DataService();
  DateTime selectedStartDate = DateTime.now(); // Thêm biến để lưu ngày chọn

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      isLoadingCars = true;
      errorMessage = null;
    });

    try {
      await Future.wait([
        _fetchCars(),
        _fetchAvailableParkingLots(),
      ]);
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Không thể tải dữ liệu: ${e.toString()}';
      });
    }
  }

  Future<void> _fetchCars() async {
    try {
      final carList = await _dataService.getCarsOfCustomer();
      setState(() {
        cars = carList;
        if (carList.isNotEmpty) {
          selectedCar = carList.first;
        }
        isLoadingCars = false;
      });
    } catch (e) {
      setState(() {
        isLoadingCars = false;
        errorMessage = 'Không thể tải danh sách xe: ${e.toString()}';
      });
    }
  }

  Future<void> _fetchAvailableParkingLots() async {
    try {
      final endDate = DateTime(
        selectedStartDate.year,
        selectedStartDate.month + selectedMonthDuration,
        selectedStartDate.day,
      );

      final lots = await _dataService.searchAvailableParkingForContract(
        startDate: selectedStartDate,
        endDate: endDate,
      );

      setState(() {
        parkingLots = lots;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Không thể tải danh sách bãi xe: ${e.toString()}';
      });
    }
  }

  void _calculateTotalCost() {
    if (selectedParking != null && selectedParking!.pricePerMonth != null) {
      final cost = selectedParking!.pricePerMonth! * selectedMonthDuration;
      setState(() {
        totalCost = '${cost.toStringAsFixed(0)}đ';
      });
    } else {
      setState(() {
        totalCost = '0đ';
      });
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime.now(), // Giới hạn ngày nhỏ nhất là hôm nay
      lastDate: DateTime.now().add(Duration(days: 365)), // Giới hạn 1 năm
    );
    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;
      });
      await _fetchAvailableParkingLots();
      _calculateTotalCost();
    }
  }

  @override
  Widget build(BuildContext context) {
    final endDate = DateTime(
      selectedStartDate.year,
      selectedStartDate.month + selectedMonthDuration,
      selectedStartDate.day,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Soạn hợp đồng',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: _boxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.grey[700], size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Thời gian để xe",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => _selectStartDate(context),
                              child: Row(
                                children: [
                                  Text(
                                    'Bắt đầu: ${_formatDate(selectedStartDate)}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.calendar_today, size: 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Kết thúc: ${_formatDate(endDate)}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            DropdownButton<int>(
                              value: selectedMonthDuration,
                              items: List.generate(12, (index) {
                                int months = index + 1;
                                return DropdownMenuItem(
                                  value: months,
                                  child: Text("$months tháng"),
                                );
                              }),
                              onChanged: (value) async {
                                if (value != null) {
                                  setState(() {
                                    selectedMonthDuration = value;
                                  });
                                  await _fetchAvailableParkingLots();
                                  _calculateTotalCost();
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: _boxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.grey[700]),
                      SizedBox(width: 8),
                      Text("Chọn Xe",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800])),
                    ],
                  ),
                  SizedBox(height: 12),
                  if (isLoadingCars)
                    CircularProgressIndicator()
                  else if (cars.isEmpty)
                    Text("Không có xe nào", style: TextStyle(fontSize: 16))
                  else
                    DropdownButton<Car>(
                      value: selectedCar,
                      isExpanded: true,
                      items: cars.map((car) {
                        return DropdownMenuItem<Car>(
                          value: car,
                          child: Text(
                            car.licensePlate.isNotEmpty
                                ? car.licensePlate
                                : 'Xe không biển số',
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),
                      onChanged: (Car? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedCar = newValue;
                          });
                        }
                      },
                    ),
                  Divider(height: 24, thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Tổng cộng",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(totalCost,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black)),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 16),
            if (isLoading)
              Center(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator()))
            else if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              )
            else if (parkingLots.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Không có bãi xe nào khả dụng trong khoảng thời gian này',
                    textAlign: TextAlign.center,
                  ),
                )
              else
                ...parkingLots.map((parking) => _buildParkingCard(parking)),
            SizedBox(height: 24),
            SizedBox(
              width: 190,
              height: 40,
              child: ElevatedButton(
                onPressed: (selectedParking != null && selectedCar != null)
                    ? () => _onSubmit(selectedStartDate, endDate)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: (selectedParking != null && selectedCar != null)
                      ? Colors.green
                      : Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                ),
                child: Text(
                  "Gửi",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParkingCard(ParkingLot parking) {
    final isSelected = selectedParking?.parkingLotId == parking.parkingLotId;
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: Colors.green, width: 2)
            : null,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              "assets/images/parking.jpg",
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  parking.address ?? 'Không có tên',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.green, size: 16),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        parking.address ?? 'Không có địa chỉ',
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.attach_money, color: Colors.green, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '${parking.pricePerMonth?.toStringAsFixed(0) ?? 'N/A'}đ/tháng',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                )
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                selectedParking = parking;
                _calculateTotalCost();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? Colors.green[800] : Colors.green,
              minimumSize: Size(60, 36),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(isSelected ? "Đã chọn" : "Chọn"),
          )
        ],
      ),
    );
  }

  Future<void> _onSubmit(DateTime startDate, DateTime endDate) async {
    if (selectedParking != null && selectedCar != null) {
      try {
        setState(() {
          isLoading = true;
        });

        final contract = await _dataService.addContract(
          carId: selectedCar!.carId,
          parkingLotId: selectedParking!.parkingLotId,
          startDate: startDate,
          endDate: endDate,
          note: "Đăng ký hợp đồng",
        );

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Hợp đồng đã được gửi thành công!")),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContractScreen(),
          ),
        );
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gửi hợp đồng thất bại"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng chọn xe và bãi xe")),
      );
    }
  }

  String _formatDate(DateTime date) {
    return "${_padZero(date.day)}/${_padZero(date.month)}/${date.year}";
  }

  String _padZero(int number) => number.toString().padLeft(2, '0');

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
      ],
    );
  }
}