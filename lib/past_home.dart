import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var faker = Faker();
  List<ChatItem> chatItems = [];
  bool alternate = false;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 237, 235, 224),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: const Color(0xFF05396b)),
          title: Text('Home', style: TextStyle(color: const Color(0xFF05396b))),
          backgroundColor: const Color(0xFF5cdb94),
          actions: [
            IconButton(
              icon: Icon(Icons.account_balance_wallet),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: const Color.fromARGB(255, 237, 235, 224),
                      title: Text("Confirmation",
                          style: TextStyle(
                              color: const Color(0xFF05396b),
                              fontSize: 22,
                              fontWeight: FontWeight.w500)),
                      content: Text("Are you sure you want to log out?",
                          style: TextStyle(color: const Color(0xFF05396b))),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("No",
                              style: TextStyle(color: const Color(0xFF05396b))),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dashboard()),
                            );
                          },
                          child: Text("Yes",
                              style: TextStyle(color: const Color(0xFF05396b))),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: "Dashboard", icon: Icon(Icons.dashboard)),
              Tab(text: "Users", icon: Icon(Icons.people)),
            ],
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: chatItems.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      chatItems.removeAt(index);
                    });
                  },
                  child: chatItems[index],
                );
              },
            ),
            Users(),
          ],
        ),
        floatingActionButton: _selectedIndex == 0
            ? FloatingActionButton(
                onPressed: () {
                  setState(() {
                    chatItems.add(ChatItem(
                      tileColor: alternate
                          ? const Color(0xFFedeae0)
                          : const Color(0xFFe4dfd0),
                      imageUrl: alternate
                          ? "https://cdn-icons-png.freepik.com/512/11045/11045308.png"
                          : "https://cdn-icons-png.freepik.com/512/11045/11045288.png",
                      title: faker.person.name(),
                      subtitle: faker.internet.userName(),
                      time: DateFormat.Hm().format(DateTime.now()),
                      imageUrl2: alternate
                          ? "images/sampah1.avif"
                          : "images/sampah2.avif",
                      desc: faker.lorem.sentence(),
                    ));
                    alternate = !alternate;
                  });
                },
                child: Icon(Icons.add),
                backgroundColor: const Color(0xFF5cdb94),
                foregroundColor: const Color(0xFF05396b),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String time;
  final String imageUrl2;
  final String desc;
  final Color tileColor;

  ChatItem({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.imageUrl2,
    required this.desc,
    required this.tileColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          tileColor: tileColor,
          contentPadding:
              EdgeInsets.only(top: 15, bottom: 17, left: 15, right: 25),
          title: Text(title,
              style: TextStyle(
                  color: const Color(0xFF05396b), fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          subtitle: Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: const Color(0xFF1d4c79)),
          ),
          leading: CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(imageUrl),
            backgroundColor: const Color(0xFF1d4c79),
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(time, style: TextStyle(color: const Color(0xFF1d4c79))),
            ],
          ),
          visualDensity: VisualDensity(horizontal: 0, vertical: -3),
        ),
        Container(
          height: 225,
          child: AvifImage.asset(
            imageUrl2,
            fit: BoxFit.cover,
          ),
        ),
        FractionallySizedBox(
          widthFactor: 1.0,
          child: Container(
            color: tileColor,
            width: 100,
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
            child: Text(
              desc,
              style: TextStyle(color: const Color(0xFF05396b)),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ],
    );
  }
}

class Users extends StatelessWidget {
  final List<Map<String, dynamic>> mylist = [
    {
      "Name": faker.person.name(),
      "Username": faker.internet.userName(),
      "favColor": ["Kirim Poin", "Lihat Postingan", "Lihat Riwayat"],
      "imageUrl": "https://cdn-icons-png.freepik.com/512/11045/11045308.png",
    },
    {
      "Name": faker.person.name(),
      "Username": faker.internet.userName(),
      "favColor": ["Kirim Poin", "Lihat Postingan", "Lihat Riwayat"],
      "imageUrl": "https://cdn-icons-png.freepik.com/512/11045/11045288.png",
    },
    {
      "Name": faker.person.name(),
      "Username": faker.internet.userName(),
      "favColor": ["Kirim Poin", "Lihat Postingan", "Lihat Riwayat"],
      "imageUrl": "https://cdn-icons-png.freepik.com/512/11045/11045308.png",
    },
    {
      "Name": faker.person.name(),
      "Username": faker.internet.userName(),
      "favColor": ["Kirim Poin", "Lihat Postingan", "Lihat Riwayat"],
      "imageUrl": "https://cdn-icons-png.freepik.com/512/11045/11045288.png",
    },
    {
      "Name": faker.person.name(),
      "Username": faker.internet.userName(),
      "favColor": ["Kirim Poin", "Lihat Postingan", "Lihat Riwayat"],
      "imageUrl": "https://cdn-icons-png.freepik.com/512/11045/11045308.png",
    },
    {
      "Name": faker.person.name(),
      "Username": faker.internet.userName(),
      "favColor": ["Kirim Poin", "Lihat Postingan", "Lihat Riwayat"],
      "imageUrl": "https://cdn-icons-png.freepik.com/512/11045/11045288.png",
    },
    {
      "Name": faker.person.name(),
      "Username": faker.internet.userName(),
      "favColor": ["Kirim Poin", "Lihat Postingan", "Lihat Riwayat"],
      "imageUrl": "https://cdn-icons-png.freepik.com/512/11045/11045308.png",
    },
    {
      "Name": faker.person.name(),
      "Username": faker.internet.userName(),
      "favColor": ["Kirim Poin", "Lihat Postingan", "Lihat Riwayat"],
      "imageUrl": "https://cdn-icons-png.freepik.com/512/11045/11045288.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.342;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 235, 224),
      body: ListView(
        children: mylist.map((data) {
          List myfavcolor = data["favColor"];
          int index = mylist.indexOf(data);

          return Card(
            margin: EdgeInsets.only(
                top: index == 0 ? 22.5 : 0, bottom: 22.5, left: 20, right: 20),
            color: const Color(0xFFe4dfd0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 0,
            child: Container(
              margin:
                  EdgeInsets.only(top: 22.5, bottom: 10, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30.0,
                            backgroundImage:
                                NetworkImage("${data['imageUrl']}"),
                            backgroundColor: const Color(0xFF1d4c79),
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${data['Name']}",
                                style: TextStyle(
                                  color: const Color(0xFF05396b),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "${data['Username']}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    TextStyle(color: const Color(0xFF1d4c79)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward, color: const Color(0xFF05396b)),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: myfavcolor.asMap().entries.map((entry) {
                        final int index = entry.key;
                        final String color = entry.value;

                        return Container(
                          width: containerWidth,
                          decoration: BoxDecoration(
                            color: Color(0xFFdbd4c0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          margin: EdgeInsets.only(
                            left: index == 0 ? 0 : 8,
                            right: 3,
                            top: 20,
                            bottom: 12,
                          ),
                          padding: EdgeInsets.only(
                              top: 8, bottom: 8, right: 13, left: 13),
                          child: Text(
                            color,
                            style: TextStyle(
                              color: const Color(0xFF05396b),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}