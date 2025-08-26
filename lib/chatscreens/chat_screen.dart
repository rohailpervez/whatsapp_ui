import 'package:flutter/material.dart';

class Message {
  final String text;
  final bool isMe;
  final DateTime time;

  Message({required this.text, required this.isMe, required this.time});
}

class ChatScreen extends StatefulWidget {
  final String name;
  final String imageUrl;

  ChatScreen({required this.name, required this.imageUrl});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        messages.add(
          Message(
            text: _controller.text.trim(),
            isMe: true,
            time: DateTime.now(),
          ),
        );
      });
      _controller.clear();

      // auto scroll
      Future.delayed(Duration(milliseconds: 200), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });

      // dummy reply
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          messages.add(
            Message(
              text: getDummyReply(),
              isMe: false,
              time: DateTime.now(),
            ),
          );
        });

        // scroll again after reply
        Future.delayed(Duration(milliseconds: 200), () {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      });
    }
  }

  // dummy replies list
  final List<String> dummyReplies = [
    "Hi 👋",
    "Kya haal hai?",
    "Haha sahi 😂",
    "Thoda busy hoon abhi!",
    "Kal milte hain 👍",
    "Accha lag raha hai ye UI 🔥",
    "chalo gay meray sath",
    "ufff kitna maza aya tha os din",
    "tum milna chaho gay mujh sa",
    "q nhi",
    "hn lay lena"
  ];
  // random reply
  String getDummyReply() {
    dummyReplies.shuffle();
    return dummyReplies.first;
  }

  String formatTime(DateTime time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.imageUrl),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87)),
                Text(
                  "online",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment:
                  msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.isMe
                          ? Colors.teal.shade200
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft:
                        msg.isMe ? Radius.circular(12) : Radius.zero,
                        bottomRight:
                        msg.isMe ? Radius.zero : Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(msg.text),
                        SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              formatTime(msg.time),
                              style: TextStyle(
                                  fontSize: 10, color: Colors.black54),
                            ),
                            if (msg.isMe) ...[
                              SizedBox(width: 4),
                              Icon(Icons.done_all,
                                  size: 16, color: Colors.blueAccent),
                            ]
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.emoji_emotions_outlined,
                      color: Colors.grey[600]),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.attach_file, color: Colors.grey[600]),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
