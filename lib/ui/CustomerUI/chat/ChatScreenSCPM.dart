import 'package:flutter/material.dart';

class ChatScreenSCPM extends StatefulWidget {
  const ChatScreenSCPM({Key? key}) : super(key: key);

  @override
  State<ChatScreenSCPM> createState() => _ChatScreenSCPMState();
}

class _ChatScreenSCPMState extends State<ChatScreenSCPM> {
  final TextEditingController _messageController = TextEditingController();

  final List<Map<String, dynamic>> _messages = [
    {'text': 'Xin chào, tôi có thể giúp gì cho bạn?', 'isSupport': true},
    {'text': 'Tôi cần hỗ trợ về hợp đồng.', 'isSupport': false},
    {
      'text': 'Vâng, anh/chị vui lòng cung cấp thêm thông tin.',
      'isSupport': true
    },
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() {
      _messages
          .add({'text': _messageController.text.trim(), 'isSupport': false});
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      appBar: AppBar(
        backgroundColor: Colors.green,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 1),
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/staff.jpg'),
            ),
            const SizedBox(width: 8),
            const Text(
              'Hỗ trợ khách hàng',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message['isSupport']
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                      color: message['isSupport']
                          ? Colors.white
                          : const Color(0xFFD2F8D2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      message['text'],
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                );
              },
            ),
          ),
          // Dòng icon
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.camera_alt_outlined, color: Colors.grey),
                Icon(Icons.image_outlined, color: Colors.grey),
                Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
                Icon(Icons.mic_none_outlined, color: Colors.grey),
                Icon(Icons.location_on_outlined, color: Colors.grey),
                Icon(Icons.more_horiz, color: Colors.grey),
              ],
            ),
          ),
          // Khung nhập tin nhắn
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.mic, color: Colors.grey),
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send, color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
