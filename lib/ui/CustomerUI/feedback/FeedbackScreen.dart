import 'package:fe_capstone/ui/CustomerUI/feedback/FeedbackDetail.dart';
import 'package:fe_capstone/ui/CustomerUI/feedback/NewFeedBack.dart';
import 'package:fe_capstone/ui/CustomerUI/home/HomeScreen1.dart';
import 'package:flutter/material.dart';
import 'package:fe_capstone/ui/components/bottomAppBar/CustomFooter.dart';

class FeedbackScreen extends StatelessWidget {
  final List<Map<String, String>> feedbackList = [
    {
      "title": "Hợp đồng xe Ford Ranger",
      "content":
          "Hợp đồng rõ ràng, thời hạn thuê hợp lý. Tôi hài lòng với chiếc BMW 320i – xe chạy êm, ngoại hình sang trọng!Nhân viên hỗ trợ tận tình khi ký hợp đồng. Thời gian xử lý nhanh chóng, xe giao đúng thời điểm."
    },
    {
      "title": "Hợp đồng xe Honda",
      "content":
          "Mọi điều khoản được giải thích rõ ràng. Tuy nhiên, nên cập nhật ứng dụng để nhắc thanh toán hợp đồng sớm hơn."
    },
    {
      "title": "Hợp đồng xe VinFast VF8",
      "content":
          "Chiếc VinFast VF8 trong hợp đồng rất mới, nội thất sạch sẽ. Tôi đã thuê 2 lần và đều hài lòng."
    },
    {
      "title": "Hợp đồng xe Ford Ranger",
      "content":
          "Hợp đồng rõ ràng, thời hạn thuê hợp lý. Tôi hài lòng với chiếc BMW 320i – xe chạy êm, ngoại hình sang trọng!Nhân viên hỗ trợ tận tình khi ký hợp đồng. Thời gian xử lý nhanh chóng, xe giao đúng thời điểm."
    },
    {
      "title": "Hợp đồng xe Honda",
      "content":
          "Mọi điều khoản được giải thích rõ ràng. Tuy nhiên, nên cập nhật ứng dụng để nhắc thanh toán hợp đồng sớm hơn."
    },
    {
      "title": "Hợp đồng xe VinFast VF8",
      "content":
          "Chiếc VinFast VF8 trong hợp đồng rất mới, nội thất sạch sẽ. Tôi đã thuê 2 lần và đều hài lòng."
    },
    {
      "title": "Hợp đồng xe Ford Ranger",
      "content":
          "Hợp đồng rõ ràng, thời hạn thuê hợp lý. Tôi hài lòng với chiếc BMW 320i – xe chạy êm, ngoại hình sang trọng!Nhân viên hỗ trợ tận tình khi ký hợp đồng. Thời gian xử lý nhanh chóng, xe giao đúng thời điểm."
    },
  ];

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
        // actions: const [
        //   Padding(
        //     padding: EdgeInsets.only(right: 16),
        //     child: CircleAvatar(
        //       backgroundImage: AssetImage("assets/images/profile1.webp"),
        //     ),
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: feedbackList.length,
                itemBuilder: (context, index) {
                  return _buildFeedbackCard(
                    feedbackList[index]["title"]!,
                    feedbackList[index]["content"]!,
                    context,
                  );
                },
              ),
            ),
          ],
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
          );
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
      String title, String content, BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) =>
              FeedbackDetailScreen(title: title, content: content),
        );
      },
      child: SizedBox(
        height: 120,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        content,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
