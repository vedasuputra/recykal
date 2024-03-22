import 'package:flutter/material.dart';
import 'package:faker/faker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Wallet(),
    );
  }
}

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: isSwitched
            ? const Color(0xFF05396b)
            : const Color.fromARGB(255, 237, 235, 224),
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
                MaterialPageRoute(builder: (context) => Wallet()),
              );
            },
            color: const Color(0xFF05396b),
          ),
          actions: [
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  color: const Color(0xFF05396b),
                );
              },
            ),
          ],
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: const Color(0xFF5cdb94),
                ),
                child: Text(
                  'Settings',
                  style: TextStyle(
                    color: const Color(0xFF05396b),
                    fontSize: 24,
                  ),
                ),
              ),
              SwitchListTile(
                title: Text('Dark Mode'),
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
                inactiveTrackColor: Color.fromARGB(255, 47, 77, 110),
                activeTrackColor: Color.fromARGB(255, 40, 64, 92),
                activeThumbImage: AssetImage('assets/switch_thumb.png'),
                inactiveThumbImage:
                    AssetImage('assets/switch_thumb_inactive.png'),
                thumbColor: MaterialStateProperty.all(Colors.white),
                secondary: Icon(Icons.settings),
              ),
            ],
          ),
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
              borderRadius: BorderRadius.circular(8),
              walletNumber: index + 1,
            );
          }),
        ),
      ),
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}

class WalletBox extends StatelessWidget {
  final Color backgroundColor;
  final BorderRadiusGeometry borderRadius;
  final int walletNumber;

  WalletBox({
    required this.backgroundColor,
    required this.borderRadius,
    required this.walletNumber,
  });

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
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
            child: Icon(
              Icons.account_balance_wallet,
              size: 48,
              color: const Color(0xFF05396b),
            ),
          ),
          SizedBox(height: 21),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'Wallet $walletNumber',
              style: TextStyle(
                color: const Color(0xFF05396b),
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              faker.lorem.word().toCapitalized(),
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
