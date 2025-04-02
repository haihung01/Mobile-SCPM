import 'package:flutter/material.dart';
import 'package:fe_capstone/models/car_model.dart';
import 'package:fe_capstone/service/data_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title:
            Text('Thông tin xe', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () async {
              if (_isEditing) {
                if (_formKey.currentState!.validate()) {
                  setState(() => _isEditing = false);
                  try {
                    final updatedCar =
                        await _dataService.updateCar(_editableCar);
                    setState(() => _futureCar = Future.value(updatedCar));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Cập nhật thành công')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi cập nhật: ${e.toString()}')),
                    );
                  }
                }
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
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQraYGSzS_s1fqgQG7xYf1DfmTWfEzHMB44aw&s',
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Icon(Icons.directions_car, size: 100),
                    ),
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
        _infoTile('Ngày đăng ký', car.registedDate),
        _infoTile('Trạng thái', car.status ? 'Hoạt động' : 'Không hoạt động'),
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
              (value) =>
                  _editableCar = _editableCar.copyWith(licensePlate: value)),
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
      String label, String initialValue, Function(String) onChanged) {
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
        validator: (value) =>
            value == null || value.isEmpty ? 'Không được bỏ trống' : null,
        onChanged: onChanged,
      ),
    );
  }
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
