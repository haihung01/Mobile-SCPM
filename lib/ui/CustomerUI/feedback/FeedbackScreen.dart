import 'package:fe_capstone/service/data_service.dart';
import 'package:fe_capstone/ui/CustomerUI/feedback/FeedbackDetail.dart';
import 'package:fe_capstone/ui/CustomerUI/feedback/NewFeedBack.dart';
import 'package:fe_capstone/ui/CustomerUI/home/HomeScreen1.dart';
import 'package:fe_capstone/ui/components/bottomAppBar/CustomFooter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  List<Map<String, dynamic>> feedbackList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFeedbacks();
  }

  Future<void> loadFeedbacks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customerId = prefs.getInt('ownerId');
      if (customerId == null) {
        throw Exception('Không tìm thấy thông tin người dùng');
      }

      final dataService = DataService();
      final feedbacks = await dataService.getFeedbacksOfCustomer(customerId);

      setState(() {
        feedbackList = feedbacks;
        isLoading = false;
      });
    } catch (e) {
      print('❌ Error: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải feedback: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Các phản hồi",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen1()),
            );
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : feedbackList.isEmpty
              ? const Center(child: Text('Chưa có phản hồi nào'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: feedbackList.length,
                    itemBuilder: (context, index) {
                      final feedback = feedbackList[index];
                      return _buildFeedbackCard(
                        feedback['customerName'] ?? 'Không tên',
                        feedback['content'] ?? '',
                        context,
                        email: feedback['customerEmail'] ?? '',
                        createdAt: feedback['createdAt'] ?? '',
                        feedbackId: feedback['feedbackId'],
                        responsedContent: feedback['responsedContent'],
                        responsedAt: feedback['responsedAt'] ?? '',
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => NewFeedbackScreen(),
          ).then((_) => loadFeedbacks());
        },
        backgroundColor: Colors.green,
        shape: const CircleBorder(),
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          child: const Text(
            "Thêm",
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomFooter(
        selectedIndex: 3,
        onItemTapped: (index) {},
      ),
    );
  }

  Widget _buildFeedbackCard(
    String title,
    String content,
    BuildContext context, {
    String? email,
    String? createdAt,
    String? responsedAt,
    required int feedbackId,
    String? responsedContent,
  }) {
    bool isResponseVisible = false; // biến trạng thái toggle

    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTap: responsedContent != null && responsedContent.isNotEmpty
              ? null
              : () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => FeedbackDetailScreen(
                      title: title,
                      content: content,
                      feedbackId: feedbackId,
                    ),
                  );
                },
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên + email
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        // Tên + Avatar
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Image.asset(
                              'assets/images/profile1.webp',
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            title,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      if (responsedContent == null || responsedContent.isEmpty)
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Xóa phản hồi'),
                                content: const Text(
                                    'Bạn có chắc muốn xóa phản hồi này không?'),
                                actions: [
                                  TextButton(
                                    child: const Text('Hủy'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                  ),
                                  TextButton(
                                    child: const Text('Có'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              try {
                                await DataService().deleteFeedback(feedbackId);
                                if (mounted) {
                                  this.setState(() {
                                    feedbackList.removeWhere(
                                        (f) => f['feedbackId'] == feedbackId);
                                  });
                                }
                              } catch (e) {
                                print('❌ Error deleting: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Lỗi xóa phản hồi: $e')),
                                );
                              }
                            }
                          },
                        ),
                    ],
                  ),

                  const SizedBox(height: 4),
                  // Thời gian
                  if (createdAt != null && createdAt.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Text(
                        createdAt,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  const SizedBox(height: 8),
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
                  const SizedBox(height: 5),
                  Text(
                    content,
                    style: const TextStyle(color: Colors.black87, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),

                  // ✨ nút Xem phản hồi nằm bên phải
                  if (responsedContent != null &&
                      responsedContent.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isResponseVisible = !isResponseVisible;
                          });
                        },
                        child: Text(
                          isResponseVisible ? "Ẩn phản hồi" : "Xem phản hồi",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                            // decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    if (isResponseVisible) ...[
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: Image.asset(
                                  'assets/images/staff.jpg',
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Hệ thống",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          if (responsedAt != null && responsedAt.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 40),
                              child: Text(
                                responsedAt,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ),
                          const SizedBox(height: 8),
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
                          const SizedBox(height: 4),
                          Text(
                            responsedContent,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
