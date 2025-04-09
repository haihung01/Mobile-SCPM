import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fe_capstone/service/data_service.dart';
import 'package:fe_capstone/models/car_model.dart';

class NewVehicleScreen extends StatefulWidget {
  @override
  _NewVehicleScreenState createState() => _NewVehicleScreenState();
}

class _NewVehicleScreenState extends State<NewVehicleScreen> {
  final TextEditingController _brandController = TextEditingController(text: "");
  final DataService _dataService = DataService();
  File? _image;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Form values
  String _selectedBrand = "BMW";
  bool _status = true;
  final List<String> _brands = ["BMW", "Mercedes", "Toyota", "Honda", "Ford"];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Lấy customerId từ DataService (gọi phương thức public)
        final customerId = await _dataService.getCustomerId();

        // Create new car object với customerId đã lấy được
        final newCar = Car(
          carId: 0, // Will be assigned by server
          customerId: customerId, // Sử dụng customerId từ DataService
          model: '${_brandController.text} ${_modelController.text}',
          color: _colorController.text,
          licensePlate: _plateController.text,
          registedDate: _dateController.text,
          status: _status,
          contracts: [],
          customer: null,
        );

        // Call API to add new car
        await _dataService.addCar(newCar);

        // Show success message and return
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thêm xe thành công!')),
        );
        Navigator.pop(context, true); // Return success status
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm xe thất bại')),
        );
        print("Lỗi khi thêm xe: ${e.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Thêm Xe",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image Picker
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    width: 214,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _image == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 100, color: Colors.grey),
                        const SizedBox(height: 8),
                        const Text(
                          "Chọn hình ảnh",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_image!, fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Brand TextField
                _buildTextField(
                  "Hãng xe",
                  _brandController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập hãng xe';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Model TextField
                _buildTextField(
                  "Model xe",
                  _modelController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập model xe';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Plate Number
                _buildTextField(
                  "Biển số xe",
                  _plateController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập biển số xe';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Date and Color Row
                Row(
                  children: [
                    // Date
                    Expanded(
                      child: _buildTextField(
                        "Ngày đăng ký",
                        _dateController,
                        hintText: "dd/mm/YYYY",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập ngày đăng ký';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Color
                    Expanded(
                      child: _buildTextField(
                        "Màu sắc",
                        _colorController,
                        hintText: "Ví dụ: Đỏ, Xanh...",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập màu xe';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Status Switch
                SwitchListTile(
                  title: const Text("Trạng thái hoạt động"),
                  value: _status,
                  onChanged: (value) {
                    setState(() {
                      _status = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Description
                _buildTextField(
                  "Mô tả (nếu có)",
                  _descriptionController,
                  maxLines: 3,
                  hintText: "Xe có bị gì không...",
                ),
                const SizedBox(height: 20),

                // Submit Button
                SizedBox(
                  width: 234,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                    ),
                    child: const Text(
                      "Hoàn tất",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller, {
        int maxLines = 1,
        String? hintText,
        String? Function(String?)? validator,
      }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdownField(
      String label,
      String value,
      ValueChanged<String?> onChanged,
      List<String> items,
      ) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((brand) {
        return DropdownMenuItem(
          value: brand,
          child: Text(brand),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng chọn hãng xe';
        }
        return null;
      },
    );
  }
}