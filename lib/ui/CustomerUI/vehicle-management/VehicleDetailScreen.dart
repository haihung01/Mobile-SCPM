import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fe_capstone/models/car_model.dart';
import 'package:fe_capstone/service/data_service.dart';
import 'package:flutter/services.dart';

class VehicleDetailsScreen extends StatefulWidget {
  final int carId;

  const VehicleDetailsScreen({required this.carId, Key? key}) : super(key: key);

  @override
  _VehicleDetailsScreenState createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  late Future<Car> _futureCar;
  final DataService _dataService = DataService();
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  late Car _editableCar;

  @override
  void initState() {
    super.initState();
    _futureCar = _dataService.getCarById(widget.carId);
  }

  String _formatLicensePlate(String value) {
    String cleaned = value.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
    if (cleaned.length >= 3) {
      String prefix = cleaned.substring(0, 2);
      String letter = cleaned.length > 2 ? cleaned[2].toUpperCase() : '';
      String numbers = cleaned.length > 3 ? cleaned.substring(3) : '';
      if (letter.isNotEmpty && !RegExp(r'[A-Za-z]').hasMatch(letter)) {
        letter = '';
        numbers = cleaned.substring(2);
      }
      String firstPart = numbers.length >= 3 ? numbers.substring(0, numbers.length > 3 ? 3 : numbers.length) : numbers;
      String secondPart = numbers.length > 3 ? numbers.substring(3, numbers.length > 5 ? 5 : numbers.length) : '';
      String formatted = prefix;
      if (letter.isNotEmpty) {
        formatted += letter;
      }
      if (firstPart.isNotEmpty) {
        formatted += '-$firstPart';
      }
      if (secondPart.isNotEmpty) {
        formatted += '.$secondPart';
      }
      return formatted.toUpperCase();
    }
    return cleaned.toUpperCase();
  }

  // Hàm xử lý cập nhật xe
  Future<void> _updateCar() async {
    if (_formKey.currentState!.validate()) {
      // Định dạng lại biển số xe trước khi gửi
      _editableCar = _editableCar.copyWith(
        licensePlate: _formatLicensePlate(_editableCar.licensePlate),
      );

      try {
        // Thực hiện cập nhật bất đồng bộ
        final updatedCar = await _dataService.updateCar(_editableCar);

        // Sau khi cập nhật thành công, gọi setState đồng bộ
        setState(() {
          _isEditing = false;
          _futureCar = Future.value(updatedCar);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật thành công')),
        );
      } catch (e) {
        print('Lỗi khi cập nhật: ${e.toString()}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật thất bại')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Thông tin xe', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _updateCar();
              } else {
                setState(() => _isEditing = true);
              }
            },
          )
        ],
      ),
      body: FutureBuilder<Car>(
        future: _futureCar,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi khi tải dữ liệu'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Không tìm thấy xe'));
          }

          final car = snapshot.data!;
          if (_isEditing) {
            _editableCar = car.copyWith();
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 240, // Tăng chiều cao lên một chút
                  width: double.infinity, // Chiều rộng full màn hình
                  margin: EdgeInsets.symmetric(vertical: 16), // Thêm margin
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12), // Bo góc
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: car.thumbnail?.isNotEmpty == true
                        ? CachedNetworkImage(
                      imageUrl: car.thumbnail!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 180,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => _buildPlaceholderImage(),
                    )
                        : _buildPlaceholderImage(),
                  ),
                ),
                SizedBox(height: 20),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: _isEditing ? _buildEditForm() : _buildDetailView(car),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailView(Car car) {
    return Column(
      children: [
        _infoTile('Model', car.model),
        _infoTile('Biển số', car.licensePlate),
        _infoTile('Màu sắc', car.color),
        // _infoTile('Ngày đăng ký', car.registedDate),
        _infoTile('Trạng thái', car.status ? 'Hoạt động' : 'Không hoạt động'),
        if (car.entrance != null) ...[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Vị trí đỗ xe',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          _infoTile('Tầng', car.entrance!.floorName),
          _infoTile('Khu vực', car.entrance!.areaName),
          _infoTile('Bãi đỗ', car.entrance!.parkingLotName),
          _infoTile('Vị trí đỗ', car.entrance!.parkingSpaceName),
        ],
      ],
    );
  }

  Widget _infoTile(String label, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _textField('Model', _editableCar.model,
                  (value) => _editableCar = _editableCar.copyWith(model: value)),
          _textField(
            'Biển số',
            _editableCar.licensePlate,
                (value) => _editableCar = _editableCar.copyWith(licensePlate: value),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
              LengthLimitingTextInputFormatter(8),
              TextInputFormatter.withFunction((oldValue, newValue) {
                String formatted = _formatLicensePlate(newValue.text);
                return TextEditingValue(
                  text: formatted,
                  selection: TextSelection.collapsed(offset: formatted.length),
                );
              }),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập biển số xe';
              }
              final platePattern = RegExp(r'^\d{2}[A-Za-z]-\d{3}\.\d{2}$');
              if (!platePattern.hasMatch(value)) {
                return 'Biển số xe không đúng định dạng (VD: XXA-XXX.XX)';
              }
              return null;
            },
          ),
          _textField('Màu sắc', _editableCar.color,
                  (value) => _editableCar = _editableCar.copyWith(color: value)),
          SwitchListTile(
            title: Text('Trạng thái hoạt động'),
            value: _editableCar.status,
            onChanged: (value) => setState(
                    () => _editableCar = _editableCar.copyWith(status: value)),
          ),
        ],
      ),
    );
  }

  Widget _textField(
      String label,
      String initialValue,
      Function(String) onChanged, {
        List<TextInputFormatter>? inputFormatters,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        inputFormatters: inputFormatters,
        validator: validator ?? (value) => value == null || value.isEmpty ? 'Không được bỏ trống' : null,
        onChanged: onChanged,
      ),
    );
  }
}

Widget _buildPlaceholderImage() {
  return Container(
    color: Colors.grey[200],
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.car_repair, size: 50, color: Colors.grey[600]),
          SizedBox(height: 8),
          Text(
            'Không có hình ảnh',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    ),
  );
}

extension CarCopyWith on Car {
  Car copyWith({
    int? carId,
    int? customerId,
    String? model,
    String? color,
    String? licensePlate,
    String? registedDate,
    bool? status,
    List<dynamic>? contracts,
    dynamic customer,
  }) {
    return Car(
      carId: carId ?? this.carId,
      customerId: customerId ?? this.customerId,
      model: model ?? this.model,
      color: color ?? this.color,
      licensePlate: licensePlate ?? this.licensePlate,
      registedDate: registedDate ?? this.registedDate,
      status: status ?? this.status,
      contracts: contracts ?? this.contracts,
      customer: customer ?? this.customer,
    );
  }
}