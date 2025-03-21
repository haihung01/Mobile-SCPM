import 'package:fe_capstone/ui/CustomerUI/feedback/FeedbackDetail.dart';
import 'package:fe_capstone/ui/CustomerUI/feedback/NewFeedBack.dart';
import 'package:flutter/material.dart';
import 'package:fe_capstone/ui/components/bottomAppBar/CustomFooter.dart';

class FeedbackScreen extends StatelessWidget {
  final List<Map<String, String>> feedbackList = [
    {
      "title": "hợp đồng xe A",
      "content":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo cons"
    },
    {"title": "test1", "content": "Nội dung feedback2"},
    {"title": "test2", "content": "Nội dung feedback3"},
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
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/images/profile1.webp"),
            ),
          ),
        ],
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
