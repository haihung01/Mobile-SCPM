import 'package:flutter/material.dart';
import 'package:fe_capstone/service/data_service.dart';

class FeedbackDetailScreen extends StatefulWidget {
  final String title;
  final String content;
  final int feedbackId; // cần feedbackId để update

  const FeedbackDetailScreen({
    Key? key,
    required this.title,
    required this.content,
    required this.feedbackId,
  }) : super(key: key);

  @override
  _FeedbackDetailScreenState createState() => _FeedbackDetailScreenState();
}

class _FeedbackDetailScreenState extends State<FeedbackDetailScreen> {
  bool isEditing = false;
  late TextEditingController _controller;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.content);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> updateFeedback() async {
    setState(() {
      isSubmitting = true;
    });

    try {
      final dataService = DataService();
      await dataService.updateFeedback(widget.feedbackId, _controller.text);

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Thành công'),
          content: const Text('Cập nhật phản hồi thành công!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

      setState(() {
        isEditing = false;
      });
    } catch (e) {
      print('❌ Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi cập nhật: $e')),
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.4,
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
            children: [
              // Tiêu đề + nút đóng
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Nội dung cuộn
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "* Nội dung phản hồi:",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        isEditing
                            ? TextField(
                                controller: _controller,
                                maxLines: null,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Nhập nội dung phản hồi...',
                                ),
                              )
                            : Text(
                                _controller.text,
                                style: const TextStyle(fontSize: 16),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: isEditing
                    ? ElevatedButton(
                        onPressed: isSubmitting ? null : updateFeedback,
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                        ),
                        child: isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Gửi'),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isEditing = true;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                        ),
                        child: const Text('Chỉnh sửa'),
                      ),
              )
            ],
          ),
        );
      },
    );
  }
}
