import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:flutter/services.dart';

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
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1596571026162-ba38f30d222e',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: const Color(0xFF163631).withOpacity(0.5),
            ),
          ),
          Center(
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
                              'Bank Sampah untuk Menabung dan Pembayaran Digital Guna Mengurangi Polusi Sampah Berlebih Pada Rumah Tangga',
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
        ],
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
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: const Color(0xFF05396b),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
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
                        onPressed: () {},
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
                                builder: (context) => DashboardPage()),
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

class Transaction {
  IconData icon;
  String title;
  String description;
  String amount;
  Transaction(
      {required this.icon,
      required this.title,
      required this.description,
      required this.amount});
}

List<Transaction> transactions = [
  Transaction(
    icon: Icons.payment,
    title: 'Pembayaran',
    description: 'Pembayaran listrik',
    amount: '-Rp250.000,00',
  ),
  Transaction(
    icon: Icons.attach_money,
    title: 'Penambahan Dana',
    description: 'Penambahan dana',
    amount: '+Rp500.000,00',
  ),
  Transaction(
    icon: Icons.payment,
    title: 'Pembayaran',
    description: 'Pembayaran air',
    amount: '-Rp750.000,00',
  ),
  Transaction(
    icon: Icons.attach_money,
    title: 'Transfer Keluar',
    description: 'Transfer ke akun lain',
    amount: '-Rp750.000,00',
  ),
  Transaction(
    icon: Icons.payment,
    title: 'Pembayaran',
    description: 'Pembayaran air',
    amount: '-Rp750.000,00',
  ),
];

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 235, 224),
      appBar: AppBar(
        iconTheme: IconThemeData(color: const Color(0xFF05396b)),
        backgroundColor: const Color(0xFF5cdb94),
        title:
            Text("Beranda", style: TextStyle(color: const Color(0xFF05396b))),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(19),
              decoration: BoxDecoration(
                color: const Color(0xFFe4dfd0),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Saldo Rekening Utama",
                        style: TextStyle(
                          fontSize: 15,
                          color: const Color(0xFF05396b),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0),
                  Text(
                    "Rp100.000.000,00",
                    style: TextStyle(
                      fontSize: 32,
                      color: const Color(0xFF05396b),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            width: 1.0, color: const Color(0xFF6988a6)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            "No Rekening",
                            style: TextStyle(
                                fontSize: 14, color: const Color(0xFF6988a6)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "1511 0008 43",
                            style: TextStyle(
                                fontSize: 14, color: const Color(0xFF05396b)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TransaksiPage()),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 4 - 16,
                            height: 70,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFe4dfd0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.payment,
                                size: 40, color: const Color(0xFF05396b)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Text(
                              'Transaksi',
                              style: TextStyle(color: const Color(0xFF05396b)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TransferPage()),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 4 - 16,
                            height: 70,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFe4dfd0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.transfer_within_a_station,
                                size: 40, color: const Color(0xFF05396b)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Text(
                              'Transfer',
                              style: TextStyle(color: const Color(0xFF05396b)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TarikPage()),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 4 - 16,
                            height: 70,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFe4dfd0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.attach_money,
                                size: 40, color: const Color(0xFF05396b)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Text(
                              'Tarik',
                              style: TextStyle(color: const Color(0xFF05396b)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return PopupDialog();
                          },
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 4 - 16,
                            height: 70,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFe4dfd0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.more_horiz,
                                size: 40, color: const Color(0xFF05396b)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Text(
                              'Lainnya',
                              style: TextStyle(color: const Color(0xFF05396b)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.only(bottom: 15, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Riwayat Transaksi',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF05396b)),
                  ),
                  Row(
                    children: [
                      Text(
                        'Lihat Detail',
                        style: TextStyle(
                            fontSize: 15.0, color: const Color(0xFF05396b)),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward,
                          size: 15, color: const Color(0xFF05396b)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFe4dfd0),
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFF6988a6),
                    width: 1.0,
                  ),
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: const Color(0xFF6988a6),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(
                        transactions[index].icon,
                        color: const Color(0xFF05396b),
                      ),
                      title: Text(
                        transactions[index].title,
                        style: TextStyle(
                            color: const Color(0xFF05396b),
                            fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        transactions[index].description,
                        style: TextStyle(color: const Color(0xFF05396b)),
                      ),
                      trailing: Text(
                        transactions[index].amount,
                        style: TextStyle(
                            color: const Color(0xFF05396b),
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 65,
        height: 65,
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(
            Icons.qr_code,
            size: 40,
            color: const Color(0xFF05396b),
          ),
          backgroundColor: const Color(0xFF5cdb94),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFe4dfd0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              iconSize: 35,
              icon: Icon(Icons.home),
              color: const Color(0xFF05396b),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                );
              },
            ),
            SizedBox(),
            IconButton(
              iconSize: 35,
              icon: Icon(Icons.account_circle),
              color: const Color(0xFF05396b),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingsAndHelpPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PopupDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListrikPage()),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 4 - 16,
                        height: 85,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFe4dfd0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.bolt,
                            size: 40, color: const Color(0xFF05396b)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Bayar Listrik',
                          style: TextStyle(
                              color: const Color(0xFFe4dfd0),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 25),
              Flexible(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AirPage()),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 4 - 16,
                        height: 85,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFe4dfd0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.water_drop,
                            size: 40, color: const Color(0xFF05396b)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Bayar PDAM',
                          style: TextStyle(
                              color: const Color(0xFFe4dfd0),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ListrikPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bayar Listrik'),
      ),
      body: Center(
        child: Text('Under Construction'),
      ),
    );
  }
}

class AirPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 235, 224),
      appBar: AppBar(
        iconTheme: IconThemeData(color: const Color(0xFF05396b)),
        backgroundColor: const Color(0xFF5cdb94),
        title: Text("Bayar PDAM",
            style: TextStyle(color: const Color(0xFF05396b))),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: PaymentForm(),
      ),
    );
  }
}

class PaymentForm extends StatefulWidget {
  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  String rekeningId = '';
  bool paymentInitiated = false;

  void initiatePayment() {
    print('Payment initiated for rekening ID: $rekeningId');
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        paymentInitiated = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'ID Pelanggan PDAM',
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: const Color(0x9905396b),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              hintStyle: TextStyle(
                color: const Color(0x9905396b),
              ),
              labelStyle: TextStyle(
                color: const Color(0x9905396b),
              ),
            ),
            onChanged: (value) {
              setState(() {
                rekeningId = value;
              });
            },
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(
                  RegExp(r'[0-9]')), // Allow only numbers
            ],
            keyboardType: TextInputType.number,
          ),
        ),
        Container(
          width: double.infinity,
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: ElevatedButton(
            onPressed: rekeningId.isEmpty ? null : initiatePayment,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              backgroundColor: const Color(0xFF5cdb94),
              foregroundColor: const Color(0xFF05396b),
              padding: EdgeInsets.symmetric(vertical: 9),
            ),
            child: Text('Masukkan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
        ),
        SizedBox(height: 20),
        if (paymentInitiated)
          Column(
            children: [
              Container(
                color: const Color(0xFFe4dfd0),
                padding: EdgeInsets.all(20),
                child: Table(
                  columnWidths: {
                    0: FixedColumnWidth(150),
                    1: FlexColumnWidth(),
                  },
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Text(
                            'Pemilik Rekening',
                            style: TextStyle(
                              color: const Color(0xFF05396b),
                              fontSize: 15,
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Gusti Putu Yastika Putra',
                              style: TextStyle(
                                color: const Color(0xFF05396b),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                            child: Text(
                          'Tenggat Pembayaran',
                          style: TextStyle(
                            color: const Color(0xFF05396b),
                            fontSize: 15,
                          ),
                        )),
                        TableCell(
                          child: Container(
                            alignment: Alignment
                                .centerRight, // Align text to the right
                            child: Text(
                              '24 Maret 2024',
                              style: TextStyle(
                                color: const Color(0xFF05396b),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                            child: Text(
                          'Tagihan',
                          style: TextStyle(
                            color: const Color(0xFF05396b),
                            fontSize: 15,
                          ),
                        )),
                        TableCell(
                          child: Container(
                            alignment: Alignment
                                .centerRight, // Align text to the right
                            child: Text(
                              '2.500',
                              style: TextStyle(
                                color: const Color(0xFF05396b),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                            child: Text(
                          'Biaya Admin',
                          style: TextStyle(
                            color: const Color(0xFF05396b),
                            fontSize: 15,
                          ),
                        )),
                        TableCell(
                          child: Container(
                            alignment: Alignment
                                .centerRight, // Align text to the right
                            child: Text(
                              '500',
                              style: TextStyle(
                                color: const Color(0xFF05396b),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                            child: Text(
                          'Total',
                          style: TextStyle(
                            color: const Color(0xFF05396b),
                            fontSize: 15,
                          ),
                        )),
                        TableCell(
                          child: Container(
                            alignment: Alignment
                                .centerRight, // Align text to the right
                            child: Text(
                              'Rp. 3.000',
                              style: TextStyle(
                                color: const Color(0xFF05396b),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Pembayaran Sukses'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
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
                  child: Text('Bayar PDAM',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class TransaksiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaksi'),
      ),
      body: Center(
        child: Text('Under Construction'),
      ),
    );
  }
}

class TransferPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer'),
      ),
      body: Center(
        child: Text('Under Construction'),
      ),
    );
  }
}

class TarikPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarik'),
      ),
      body: Center(
        child: Text('Under Construction'),
      ),
    );
  }
}

class SettingsAndHelpPage extends StatelessWidget {
  final List<String> settings = [
    'Umum',
    'Keamanan',
    'Aksesibilitas',
  ];

  final List<String> help = [
    'Syarat dan Ketentuan',
    'Pusat Bantuan',
    'Kontak',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 235, 224),
      appBar: AppBar(
        iconTheme: IconThemeData(color: const Color(0xFF05396b)),
        backgroundColor: const Color(0xFF5cdb94),
        title: Text("Akun", style: TextStyle(color: const Color(0xFF05396b))),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: const Color(0xFFe4dfd0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage('images/sampah1.avif'),
                      ),
                      SizedBox(width: 15.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gusti Putu Yastika Putra',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF05396b)),
                          ),
                          SizedBox(height: 0.0),
                          Text(
                            '1581 BS Galang Panji',
                            style: TextStyle(
                                fontSize: 14, color: const Color(0xFF05396b)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: const Color(0xFF05396b),
                    size: 25.0,
                  ),
                ],
              ),
            ),
          ),
          _buildSection('Settings', settings),
          _buildSection('Help', help),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              decoration: BoxDecoration(
                color: const Color(0xFF5cdb94),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Center(
                child: Text(
                  'Keluar',
                  style: TextStyle(
                    color: const Color(0xFF05396b),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 35),
        ]),
      ),
      floatingActionButton: Container(
        width: 65,
        height: 65,
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(
            Icons.qr_code,
            size: 40,
            color: const Color(0xFF05396b),
          ),
          backgroundColor: const Color(0xFF5cdb94),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFe4dfd0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              iconSize: 35,
              icon: Icon(Icons.home),
              color: const Color(0xFF05396b),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                );
              },
            ),
            SizedBox(),
            IconButton(
              iconSize: 35,
              icon: Icon(Icons.account_circle),
              color: const Color(0xFF05396b),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingsAndHelpPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 20.0, right: 20.0, top: 25, bottom: 17),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF05396b),
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Container(
                padding:
                    EdgeInsets.only(left: 5.0, right: 5.0, top: 3, bottom: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFe4dfd0),
                  border: Border(
                    top: BorderSide(
                      color: const Color(0xFF6988a6),
                      width: 1.0,
                    ),
                    bottom: index == items.length - 1
                        ? BorderSide(
                            color: const Color(0xFF6988a6),
                            width: 1.0,
                          )
                        : BorderSide.none,
                  ),
                ),
                child: ListTile(
                  title: Text(items[index],
                      style: TextStyle(
                        color: const Color(0xFF05396b),
                        fontSize: 17,
                      )),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: const Color(0xFF05396b),
                  ),
                  onTap: () {},
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
