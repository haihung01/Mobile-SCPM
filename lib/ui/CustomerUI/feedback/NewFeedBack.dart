import 'package:flutter/material.dart';
import 'package:fe_capstone/service/data_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewFeedbackScreen extends StatefulWidget {
  @override
  _NewFeedbackScreenState createState() => _NewFeedbackScreenState();
}

class _NewFeedbackScreenState extends State<NewFeedbackScreen> {
  final TextEditingController feedbackController = TextEditingController();

  @override
  void dispose() {
    feedbackController.dispose(); // Đừng quên dispose khi widget bị hủy
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "Bài viết mới",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.insert_drive_file, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(
                          "Nội Dung",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: feedbackController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Vui lòng nhập nội dung...",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 180),
              Center(
                child: SizedBox(
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      final message = feedbackController.text.trim();
                      if (message.isEmpty) {
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Không thể gửi!'),
                            content: const Text('Vui lòng nhập nội dung...'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );

                        return;
                      }

                      try {
                        final prefs = await SharedPreferences.getInstance();
                        final customerId = prefs.getInt('ownerId');

                        if (customerId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Không tìm thấy thông tin người dùng')),
                          );
                          return;
                        }

                        final dataService = DataService();
                        await dataService.sendFeedback(customerId, message);

                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Lỗi gửi phản hồi: ${e.toString()}')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      "Gửi",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
