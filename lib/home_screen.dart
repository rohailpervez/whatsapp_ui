

import 'package:flutter/material.dart';
import 'package:whatsapp_ui/chatscreens/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'HomeScreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ✅ Dummy Chat Data with unread & seen ticks
  final List<Map<String, dynamic>> chats = [
    {
      "name": "Raja Rohail",
      "message": "Bro kal milte hain!",
      "time": "7:48 PM",
      "image": "https://images.pexels.com/photos/1704488/pexels-photo-1704488.jpeg",
      "unread": 2,
      "isSeen": false
    },
    {
      "name": "Ali Khan",
      "message": "Project complete ho gaya?",
      "time": "6:30 PM",
      "image": "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg",
      "unread": 0,
      "isSeen": true
    },
    {
      "name": "Ahmed Raza",
      "message": "Ok, thanks bhai 👍",
      "time": "5:12 PM",
      "image": "https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg",
      "unread": 1,
      "isSeen": false
    },
    {
      "name": "Fatima Noor",
      "message": "Class kab start hogi?",
      "time": "4:20 PM",
      "image": "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg",
      "unread": 0,
      "isSeen": true
    },
    {
      "name": "Ayesha Bibi",
      "message": "Good night 🌙",
      "time": "Yesterday",
      "image": "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg",
      "unread": 0,
      "isSeen": true
    },
    {
      "name": "Mehreen",
      "message": "chalna hai ?",
      "time": "12:27 PM",
      "image": "https://images.pexels.com/photos/25696026/pexels-photo-25696026.jpeg",
      "unread": 3,
      "isSeen": false
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text('WhatsApp',
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        backgroundColor: Colors.teal,
        bottom: TabBar(
          controller: _tabController,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.white, width: 3),
          ),
          tabs: [
            Tab(icon: Icon(Icons.camera_alt, color: Colors.white)),
            Tab(
                child: Text('Chats',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))),
            Tab(
                child: Text('Status',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))),
            Tab(
                child: Text('Calls',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))),
          ],
        ),
        actions: [
          Icon(Icons.search, color: Colors.white),
          SizedBox(width: 20),
          PopupMenuButton<int>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              PopupMenuItem<int>(value: 1, child: Text('New Group')),
              PopupMenuItem<int>(value: 2, child: Text('Settings')),
              PopupMenuItem<int>(value: 3, child: Text('Logout')),
            ],
            onSelected: (value) {
              if (value == 1) {
                debugPrint("New Group clicked");
              } else if (value == 2) {
                debugPrint("Settings clicked");
              } else if (value == 3) {
                debugPrint("Logout clicked");
              }
            },
          ),
        ],
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          Icon(Icons.camera_alt, color: Colors.black38),

          // ✅ Chats Tab with Dummy Data + swipe actions
          ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];

              return Dismissible(
                key: Key(chat["name"]),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                secondaryBackground: Container(
                  color: Colors.blue,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.archive, color: Colors.white),
                ),
                onDismissed: (direction) {
                  setState(() {
                    chats.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(direction == DismissDirection.startToEnd
                          ? 'Chat deleted'
                          : 'Chat archived'),
                    ),
                  );
                },
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(chat["image"]),
                  ),
                  title: Text(chat["name"],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Row(
                    children: [
                      if (chat["isSeen"])
                        Icon(Icons.done_all, size: 18, color: Colors.blue)
                      else
                        Icon(Icons.done, size: 18, color: Colors.grey),
                      SizedBox(width: 4),
                      Expanded(child: Text(chat["message"])),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(chat["time"]),
                      if (chat["unread"] > 0)
                        Container(
                          margin: EdgeInsets.only(top: 4),
                          padding:
                          EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            chat["unread"].toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          name: chat["name"],
                          imageUrl: chat["image"],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          // ✅ Status Tab
          ListView(
            children: [
              ListTile(
                leading: Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          'https://images.pexels.com/photos/1704488/pexels-photo-1704488.jpeg'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.add, size: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                title: Text("My Status",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Tap to add status update"),
              ),

              //  Recent Updates
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text("Recent updates",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black54)),
              ),
              ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg'),
                  ),
                ),
                title: Text("Ali Khan",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("12 minutes ago"),
              ),
              ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg'),
                  ),
                ),
                title: Text("Ahmed Raza",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Today, 8:30 AM"),
              ),

              // ✅ Viewed Updates
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text("Viewed updates",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black54)),
              ),
              ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg'),
                  ),
                ),
                title: Text("Fatima Noor",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Yesterday, 9:45 PM"),
              ),
              ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        'https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg'),
                  ),
                ),
                title: Text("Ayesha Bibi",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Yesterday, 5:20 PM"),
              ),
            ],
          ),

          // ✅ Calls Tab

          ListView.builder(
            itemCount: 8,
            itemBuilder: (context, index) {
              bool isVideo = index % 3 == 0; // har 3rd call video hogi
              bool isMissed = index % 2 == 0; // har even call missed hogi
              bool isIncoming = index % 4 != 0; // thoda mix incoming/outgoing

              return ListTile(
                leading: Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(
                          'https://images.pexels.com/photos/1704488/pexels-photo-1704488.jpeg'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Icon(
                        isVideo ? Icons.videocam : Icons.phone,
                        size: 18,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                title: Text(
                  'Raja Rohail',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Row(
                  children: [
                    Icon(
                      isIncoming ? Icons.call_received : Icons.call_made,
                      size: 16,
                      color: isMissed ? Colors.red : Colors.green,
                    ),
                    SizedBox(width: 5),
                    Text(
                      isMissed
                          ? "Missed call, Today 5:${index} PM"
                          : "Yesterday, 7:${index} AM",
                    ),
                  ],
                ),
                trailing: Icon(
                  isVideo ? Icons.videocam : Icons.phone,
                  color: Colors.teal,
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isVideo ? "Video Call opening..." : "Voice Call opening...",
                      ),
                    ),
                  );
                },
              );
            },
          ),

        ],
      ),

      // ✅ FAB changes with tab
      floatingActionButton: Builder(
        builder: (context) {
          switch (_tabController.index) {
            case 1:
              return FloatingActionButton(
                backgroundColor: Colors.teal,
                onPressed: () {},
                child: Icon(Icons.message, color: Colors.white),
              );
            case 2:
              return FloatingActionButton(
                backgroundColor: Colors.teal,
                onPressed: () {},
                child: Icon(Icons.camera_alt, color: Colors.white),
              );
            case 3:
              return FloatingActionButton(
                backgroundColor: Colors.teal,
                onPressed: () {},
                child: Icon(Icons.add_call, color: Colors.white),
              );
            default:
              return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
