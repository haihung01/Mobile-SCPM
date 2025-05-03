import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fe_capstone/service/data_service.dart';
import 'package:fe_capstone/models/car_model.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewVehicleScreen extends StatefulWidget {
  @override
  _NewVehicleScreenState createState() => _NewVehicleScreenState();
}

class _NewVehicleScreenState extends State<NewVehicleScreen> {
  final TextEditingController _brandController =
      TextEditingController(text: "");
  final DataService _dataService = DataService();
  File? _image;
  String? _thumbnailUrl; // Lưu URL của hình ảnh sau khi upload
  final _formKey = GlobalKey<FormState>();
  bool _isUploading = false; // Trạng thái upload hình ảnh

  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _brandTextController = TextEditingController();

  String _selectedBrand = "BMW";
  bool _status = true;
  final List<String> _brands = ["BMW", "Mercedes", "Toyota", "Honda", "Ford"];

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isUploading = true; // Hiển thị trạng thái đang upload
      });

      try {
        // Gọi API upload hình ảnh
        final imageUrl = await _dataService.uploadImage(_image!);
        setState(() {
          _thumbnailUrl = imageUrl; // Lưu URL hình ảnh
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tải hình ảnh thành công!')),
        );
      } catch (e) {
        setState(() {
          _isUploading = false;
          _image = null; // Xóa hình ảnh nếu upload thất bại
          _thumbnailUrl = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tải hình ảnh thất bại: $e')),
        );
      }
    }
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
      String firstPart = numbers.length >= 3
          ? numbers.substring(0, numbers.length > 3 ? 3 : numbers.length)
          : numbers;
      String secondPart = numbers.length > 3
          ? numbers.substring(3, numbers.length > 5 ? 5 : numbers.length)
          : '';
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

  String _formatDate(String value) {
    String cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.length >= 2) {
      String day = cleaned.substring(0, 2);
      String month = cleaned.length > 2
          ? cleaned.substring(2, cleaned.length > 4 ? 4 : cleaned.length)
          : '';
      String year = cleaned.length > 4
          ? cleaned.substring(4, cleaned.length > 8 ? 8 : cleaned.length)
          : '';

      String formatted = day;
      if (month.isNotEmpty) {
        formatted += '/$month';
      }
      if (year.isNotEmpty) {
        formatted += '/$year';
      }
      return formatted;
    }
    return cleaned;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Kiểm tra nếu đang upload hình ảnh
      if (_isUploading) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đang tải hình ảnh, vui lòng chờ!')),
        );
        return;
      }

      try {
        String formattedPlate = _formatLicensePlate(_plateController.text);
        _plateController.text = formattedPlate;

        String formattedDate = _formatDate(_dateController.text);
        _dateController.text = formattedDate;

        final customerId = await _dataService.getCustomerId();

        // Tạo đối tượng Car với thumbnail
        final newCar = Car(
          carId: 0,
          customerId: customerId,
          model: '${_brandController.text} ${_modelController.text}',
          color: _colorController.text,
          licensePlate: formattedPlate,
          registedDate: formattedDate,
          status: _status,
          contracts: [],
          customer: null,
          entrance: null,
          thumbnail: _thumbnailUrl,
          brand: _brandTextController.text,
        );

        await _dataService.addCar(newCar);

        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Thêm xe thành công!'),
            content: const Text('Xe của bạn đã được thêm vào hệ thống.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
                child: const Text('Đóng'),
              ),
            ],
          ),
        );
      } catch (e) {
        String errorMessage = 'Vui lòng nhập lại... ';
        if (e is DioError && e.response != null) {
          if (e.response!.statusCode == 400) {
            final responseData = e.response!.data;
            if (responseData is Map && responseData.containsKey('message')) {
              errorMessage = responseData['message'];
            } else {
              errorMessage = 'Biển số xe đã tồn tại trong hệ thống';
            }
          }
        }

        // Show Popup thay vì SnackBar
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Biển số đã tồn tại !'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Đóng'),
                ),
              ],
            );
          },
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
                  onTap: _isUploading ? null : _pickImage,
                  child: Container(
                    height: 200,
                    width: 214,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _isUploading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : _image == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt,
                                      size: 100, color: Colors.grey),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Chọn hình ảnh",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            : _thumbnailUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl: _thumbnailUrl!,
                                      fit: BoxFit.cover,
                                      width: 214,
                                      height: 200,
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        color: Colors.grey[200],
                                        child: Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 50,
                                        ),
                                      ),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child:
                                        Image.file(_image!, fit: BoxFit.cover),
                                  ),
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField(
                  "Tên xe",
                  _brandController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên xe';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                _buildTextField(
                  "Thương hiệu",
                  _brandTextController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập thương hiệu';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),
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
                _buildTextField(
                  "Biển số xe",
                  _plateController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                    LengthLimitingTextInputFormatter(8),
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      String formatted = _formatLicensePlate(newValue.text);
                      return TextEditingValue(
                        text: formatted,
                        selection:
                            TextSelection.collapsed(offset: formatted.length),
                      );
                    }),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập biển số xe';
                    }
                    final platePattern =
                        RegExp(r'^\d{2}[A-Za-z]-\d{3}\.\d{2}$');
                    if (!platePattern.hasMatch(value)) {
                      return 'Biển số xe không đúng định dạng (VD: XXA-XXX.XX)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
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

                // ),
                const SizedBox(height: 20),
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
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
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
