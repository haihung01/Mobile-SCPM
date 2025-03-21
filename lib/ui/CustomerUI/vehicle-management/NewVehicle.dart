import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewVehicleScreen extends StatefulWidget {
  @override
  _NewVehicleScreenState createState() => _NewVehicleScreenState();
}

class _NewVehicleScreenState extends State<NewVehicleScreen> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  final TextEditingController plateController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String selectedBrand = "BMW";
  final List<String> brands = ["BMW", "Mercedes", "Toyota", "Honda", "Ford"];

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        ),
                ),
              ),
              const SizedBox(height: 30),
              _buildTextField("Biển Số", plateController),
              const SizedBox(height: 20),
              _buildTextField("Ngày", dateController, hintText: "dd/mm/YYYY"),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField("Hãng xe"),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField("Màu sắc", colorController,
                        hintText: "Ví dụ: Đỏ, Xanh..."),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildTextField("Mô tả", descriptionController,
                  maxLines: 3, hintText: "Xe có bị gì không..."),
              const SizedBox(height: 20),
              SizedBox(
                width: 234,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
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
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1, String hintText = ""}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildDropdownField(String label) {
    return DropdownButtonFormField(
      value: selectedBrand,
      items: brands.map((brand) {
        return DropdownMenuItem(
          value: brand,
          child: Text(brand),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedBrand = value.toString();
        });
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
