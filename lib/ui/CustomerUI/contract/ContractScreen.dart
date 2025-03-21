import 'package:fe_capstone/ui/components/bottomAppBar/CustomFooter.dart';
import 'package:flutter/material.dart';

class ContractScreen extends StatefulWidget {
  @override
  _ContractScreenState createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  int selectedTabIndex = 0; // 0 = "Chưa Hợp Đồng", 1 = "Đã thanh toán"

  final List<Map<String, String>> contractList = [
    {
      "title": "Hợp Đồng Xe A",
      "description": "Xe chạy tốt",
      "location": "Bà Rịa-Vũng Tàu",
      "image": "assets/images/car1.jpg",
    },
    {
      "title": "Hợp Đồng Xe B",
      "description": "Đang bảo trì",
      "location": "Hồ Chí Minh",
      "image": "assets/images/car2.webp",
    },
    {
      "title": "Hợp Đồng Xe C",
      "description": "Chạy khỏe",
      "location": "Bình Dương",
      "image": "assets/images/car1.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Hợp đồng",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTabButton("Chưa Hợp Đồng", 0),
                _buildTabButton("Đã thanh toán", 1),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: contractList.length,
                itemBuilder: (context, index) {
                  return _buildContractCard(
                    contractList[index]["title"]!,
                    contractList[index]["description"]!,
                    contractList[index]["location"]!,
                    contractList[index]["image"]!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomFooter(
        selectedIndex: 1,
        onItemTapped: (index) {},
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selectedTabIndex == index ? Colors.green : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: selectedTabIndex == index ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Card Widget
  Widget _buildContractCard(
      String title, String description, String location, String image) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:
                  Image.asset(image, width: 80, height: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.place, size: 14, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                "Chi tiết",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
