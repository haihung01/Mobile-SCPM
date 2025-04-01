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
      appBar: AppBar(
        title: Text('Chi tiết xe'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () async {
              if (_isEditing) {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _isEditing = false;
                  });
                  try {
                    final updatedCar = await _dataService.updateCar(_editableCar);
                    setState(() {
                      _futureCar = Future.value(updatedCar);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Cập nhật thành công')),
                    );
                  } catch (e) {
                      print('Lỗi khi cập nhật: ${e.toString()}');
                  }
                }
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<Car>(
        future: _futureCar,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi tải chi tiết xe'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Không tìm thấy thông tin xe'));
          }

          final car = snapshot.data!;
          if (_isEditing) {
            _editableCar = Car(
              carId: car.carId,
              customerId: car.customerId,
              model: car.model,
              color: car.color,
              licensePlate: car.licensePlate,
              registedDate: car.registedDate,
              status: car.status,
              contracts: car.contracts,
              customer: car.customer,
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: _isEditing
                ? _buildEditForm(car)
                : _buildDetailView(car),
          );
        },
      ),
    );
  }

  Widget _buildDetailView(Car car) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.network(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQraYGSzS_s1fqgQG7xYf1DfmTWfEzHMB44aw&s',
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Icon(Icons.car_repair, size: 100),
          ),
        ),
        SizedBox(height: 20),
        _buildDetailItem('Model', car.model),
        _buildDetailItem('Biển số', car.licensePlate),
        _buildDetailItem('Màu sắc', car.color),
        _buildDetailItem('Ngày đăng ký', car.registedDate),
        _buildDetailItem('Trạng thái', car.status ? 'Hoạt động' : 'Không hoạt động'),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18),
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget _buildEditForm(Car car) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: car.model,
            decoration: InputDecoration(labelText: 'Model'),
            validator: (value) => value!.isEmpty ? 'Vui lòng nhập model' : null,
            onChanged: (value) => _editableCar = _editableCar.copyWith(model: value),
          ),
          TextFormField(
            initialValue: car.licensePlate,
            decoration: InputDecoration(labelText: 'Biển số'),
            validator: (value) => value!.isEmpty ? 'Vui lòng nhập biển số' : null,
            onChanged: (value) => _editableCar = _editableCar.copyWith(licensePlate: value),
          ),
          TextFormField(
            initialValue: car.color,
            decoration: InputDecoration(labelText: 'Màu sắc'),
            validator: (value) => value!.isEmpty ? 'Vui lòng nhập màu sắc' : null,
            onChanged: (value) => _editableCar = _editableCar.copyWith(color: value),
          ),
          SwitchListTile(
            title: Text('Trạng thái hoạt động'),
            value: _editableCar.status,
            onChanged: (value) => setState(() {
              _editableCar = _editableCar.copyWith(status: value);
            }),
          ),
        ],
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