import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:intl/intl.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5cdb94),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 90.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 237, 235, 224),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  height: 200,
                  width: 400,
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Recykal',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF3a9283),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                          'Platform Jual-Beli dan Sharing Ide Karya Daur Ulang Sampah',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF05396b),
                          )),
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

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController myController = TextEditingController();
  final TextEditingController myController2 = TextEditingController();

  String hasil = "";
  String hasil2 = "HASIL INPUT";
  String errorMessage = '';

  bool _obscureText = true;
  bool _isValidUsername(String username) {
    RegExp regex = RegExp(r'^[a-zA-Z0-9-_]+$');
    return regex.hasMatch(username);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 237, 235, 224),
        appBar: AppBar(
          backgroundColor: const Color(0xFF5cdb94),
          title:
              Text("Login", style: TextStyle(color: const Color(0xFF05396b))),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            color: const Color(0xFF05396b),
          ),
        ),
        body: Center(
          child: Container(
            height: 255,
            width: 330,
            padding: EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              color: const Color(0xFFe4dfd0),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  autocorrect: false,
                  autofocus: true,
                  cursorColor: errorMessage.isNotEmpty
                      ? Colors.red
                      : const Color(0xFF05396b),
                  style: TextStyle(
                    color: errorMessage.isNotEmpty
                        ? Colors.red
                        : const Color(0xFF05396b),
                  ),
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.person,
                      size: 35,
                      color: const Color(0xFF05396b),
                    ),
                    hintText: 'Enter your username here',
                    hintStyle: TextStyle(
                        color: errorMessage.isNotEmpty
                            ? Colors.red
                            : const Color(0x9905396b)),
                    labelText: "Username",
                    labelStyle: TextStyle(
                        color: errorMessage.isNotEmpty
                            ? Colors.red
                            : const Color(0xFF05396b)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: errorMessage.isNotEmpty
                                ? Colors.red
                                : const Color(0x9905396b))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: errorMessage.isNotEmpty
                                ? Colors.red
                                : const Color(0xFF05396b))),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 13),
                  ),
                  controller: myController,
                  onSubmitted: (value) {
                    print(value);
                    setState(() {
                      hasil = value;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      errorMessage = _isValidUsername(value)
                          ? ''
                          : '  Username contain a-z, 0-9, -, and _';
                    });
                  },
                ),
                Text(
                  errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  autocorrect: false,
                  autofocus: true,
                  cursorColor: const Color(0xFF05396b),
                  style: TextStyle(
                    color: const Color(0xFF05396b),
                  ),
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.lock,
                      size: 35,
                      color: const Color(0xFF05396b),
                    ),
                    hintText: 'Enter your password here',
                    hintStyle: TextStyle(color: const Color(0x9905396b)),
                    labelText: "Password",
                    labelStyle: TextStyle(color: const Color(0xFF05396b)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: const Color(0x9905396b))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: const Color(0xFF05396b))),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 13),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility
                            : Icons
                                .visibility_off,
                        color: const Color(0xFF05396b),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText =
                              !_obscureText; 
                        });
                      },
                    ),
                  ),
                  controller: myController2,
                  onSubmitted: (value) {
                    print(value);
                    setState(() {
                      hasil2 = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          backgroundColor: const Color(0xdd05396b),
                          foregroundColor: const Color(0xFFFFFFFF),
                          padding: EdgeInsets.symmetric(vertical: 9),
                        ),
                        child: Text('Create Account',
                            style: TextStyle(fontSize: 15)),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Dashboard()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          backgroundColor: const Color(0xFF5cdb94),
                          foregroundColor: const Color(0xFF05396b),
                          padding: EdgeInsets.symmetric(vertical: 9),
                        ),
                        child: Text('Log In', style: TextStyle(fontSize: 15)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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
                  MaterialPageRoute(builder: (context) => Wallet()),
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
                                  builder: (context) => HomePage()),
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
            ListView(
              children: [
                ChatItem(
                  tileColor: const Color(0xFFedeae0),
                  imageUrl:
                      "https://cdn-icons-png.freepik.com/512/11045/11045308.png",
                  title: faker.person.name(),
                  subtitle: faker.internet.userName(),
                  time: DateFormat.Hm().format(DateTime.now()),
                  imageUrl2: "images/sampah1.avif",
                  desc: faker.lorem.sentence(),
                ),
                for (var chatItem in chatItems) chatItem,
              ],
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

class Wallet extends StatelessWidget {
  final List<Container> myList = List.generate(
    90,
    (index) {
      return Container(
        height: 50,
        width: 50,
        color: Color.fromARGB(
          255,
          Random().nextInt(256),
          Random().nextInt(256),
          Random().nextInt(256),
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 237, 235, 224),
        appBar: AppBar(
          iconTheme: IconThemeData(color: const Color(0xFF05396b)),
          title:
              Text('Wallets', style: TextStyle(color: const Color(0xFF05396b))),
          backgroundColor: const Color(0xFF5cdb94),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              );
            },
            color: const Color(0xFF05396b),
          ),
          actions: [
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
                                  builder: (context) => HomePage()),
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
        ),
        body: GridView.count(
          childAspectRatio: 1 / 1,
          padding: EdgeInsets.all(10),
          crossAxisCount: 2,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          children: List.generate(8, (index) {
            return WalletBox(
              backgroundColor: const Color(0xFFe4dfd0), 
              borderRadius: BorderRadius.circular(
                  8),
              walletNumber: index + 1,
            );
          }),
        ),
      ),
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
}

class WalletBox extends StatelessWidget {
  final Color backgroundColor;
  final BorderRadiusGeometry borderRadius;
  final int walletNumber;

  WalletBox(
      {required this.backgroundColor,
      required this.borderRadius,
      required this.walletNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
            child: Icon(
              Icons.account_balance_wallet,
              size: 48,
              color: const Color(0xFF05396b),
            ),
          ),
          SizedBox(height: 21),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text('Wallet $walletNumber',
              style: TextStyle(
                color: const Color(0xFF05396b),
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(faker.lorem.word().toCapitalized(),
              style: TextStyle(
                color: const Color(0x9905396b),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
