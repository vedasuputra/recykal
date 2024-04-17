import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:faker/faker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qris/qris.dart';
import 'package:barcode_finder/barcode_finder.dart' as bf;
import 'package:image_picker/image_picker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PaymentModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        initialRoute: '/',
        routes: {
          '/paymentField': (context) => AirPage(),
          '/paymentConfirmation': (context) => PaymentDetailsPage(),
          '/transactionDetails': (context) => DetailPage(),
          '/transactionConfirm': (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as TransactionArguments;
            return TransaksiConfirm(
              paymentAmount: args.paymentAmount,
              merchantName: args.merchantName,
            );
          },
          '/transferNominal': (context) => TransferNominal(),
          '/transferConfirm': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments as TransferArguments;
            return TransferConfirm(
              paymentAmount: args.paymentAmount,
              paymentRek: args.paymentRek,
              fakeName: args.fakeName,
            );
          },
          '/tarikConfirm': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments as TarikArguments;
            return TarikConfirm(
              tarikAmount: args.tarikAmount,
            );
          },
          '/listrikConfirmation': (context) => TokenDetailsPage(),
        },
      ),
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

class CurrencyFormat {
  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }
}

class Transaction {
  IconData icon;
  String title;
  String description;
  String amount;
  String ID;
  String name;
  String fee;
  String admin;
  DateTime date;
  Transaction({
    required this.icon,
    required this.title,
    required this.description,
    required int feeAmount,
    required int adminAmount,
    required this.ID,
    required this.name,
    required this.date,
  })  : fee = '${CurrencyFormat.convertToIdr(feeAmount, 2)}',
        admin = '${CurrencyFormat.convertToIdr(adminAmount, 2)}',
        amount = '${CurrencyFormat.convertToIdr(feeAmount + adminAmount, 2)}';
}

class PaymentModel extends ChangeNotifier {
  int mainAccountBalance = 100000000;

  List<Transaction> transactions = [
    Transaction(
      icon: Icons.payment,
      title: 'Pembayaran',
      description: 'Pembayaran listrik',
      ID: '1511200300',
      name: 'Yastika Putra',
      feeAmount: 250000,
      adminAmount: 500,
      date: DateTime(2024, 4, 2, 10, 30, 0),
    ),
    Transaction(
      icon: Icons.attach_money,
      title: 'Penambahan Dana',
      description: 'Penambahan dana',
      ID: '1511100400',
      name: 'Dewina Savitri',
      feeAmount: 500000,
      adminAmount: 0,
      date: DateTime(2023, 8, 15, 14, 45, 0),
    ),
    Transaction(
      icon: Icons.payment,
      title: 'Pembayaran',
      description: 'Pembayaran air',
      ID: '1511500600',
      name: 'Veda Suputra',
      feeAmount: 749000,
      adminAmount: 1000,
      date: DateTime(2024, 1, 20, 9, 0, 0),
    ),
    Transaction(
      icon: Icons.payment,
      title: 'Transfer',
      description: 'Transfer ke akun lain',
      ID: '1511700800',
      name: 'Pratama Surya',
      feeAmount: 748500,
      adminAmount: 1500,
      date: DateTime(2023, 11, 5, 18, 20, 0),
    ),
    Transaction(
      icon: Icons.payment,
      title: 'Pembayaran',
      description: 'Pembayaran air',
      ID: '1511900000',
      name: 'Nanda Kuswanda',
      feeAmount: 748000,
      adminAmount: 2000,
      date: DateTime(2024, 6, 10, 12, 0, 0),
    ),
  ];

  void addTransaction(Transaction transaction) {
    int transactionAmount = int.parse(transaction.amount
        .replaceAll(RegExp(r',00$'), '')
        .replaceAll(RegExp(r'[^\d]'), ''));

    mainAccountBalance -= transactionAmount;
    transactions.insert(0, transaction);
    notifyListeners();
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage();

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaymentModel>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 235, 224),
      appBar: AppBar(
        iconTheme: IconThemeData(color: const Color(0xFF05396b)),
        backgroundColor: const Color(0xFF5cdb94),
        title: Center(
          child: Text(
            "Beranda",
            style: TextStyle(color: const Color(0xFF05396b)),
          ),
        ),
        automaticallyImplyLeading: false,
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
                    '${CurrencyFormat.convertToIdr(provider.mainAccountBalance, 2)}',
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
                                fontSize: 14, color: const Color(0xFF05396b)),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListrikPage()),
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
                            child: Icon(Icons.bolt,
                                size: 40, color: const Color(0xFF05396b)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Text(
                              'Listrik',
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
                          MaterialPageRoute(builder: (context) => AirPage()),
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
                            child: Icon(Icons.water_drop,
                                size: 40, color: const Color(0xFF05396b)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Text(
                              'PDAM',
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailPage()),
                      );
                    },
                    child: Row(
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
                itemCount: provider.transactions.length,
                itemBuilder: (context, index) {
                  final transaction = provider.transactions[index];
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0))),
                            backgroundColor: Colors.white,
                            title: Text(
                              'Informasi',
                              style: TextStyle(
                                color: const Color(0xFF05396b),
                                fontSize: 23.5,
                              ),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Table(
                                  columnWidths: {
                                    0: FixedColumnWidth(85),
                                    1: FlexColumnWidth(2),
                                  },
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  children: [
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Text(
                                            'ID:',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: const Color(0xFF05396b),
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            '${transaction.ID}',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: const Color(0xFF05396b),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Text(
                                            'Jenis:',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: const Color(0xFF05396b),
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            '${transaction.description}',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: const Color(0xFF05396b),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Text(
                                            'Nama:',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: const Color(0xFF05396b),
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            '${transaction.name}',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: const Color(0xFF05396b),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Text(
                                            'Tanggal:',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: const Color(0xFF05396b),
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            '${DateFormat('yyyy-MM-dd HH:mm').format(transaction.date)}',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: const Color(0xFF05396b),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Text(
                                            'Tagihan:',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: const Color(0xFF05396b),
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            '${transaction.fee}',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: const Color(0xFF05396b),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Text(
                                            'Lainnya:',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: const Color(0xFF05396b),
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            '${transaction.admin}',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: const Color(0xFF05396b),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Text(
                                            'Total:',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: const Color(0xFF05396b),
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Text(
                                            '${transaction.amount}',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: const Color(0xFF05396b),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                    color: const Color(0xFF05396b),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
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
                          transaction.icon,
                          color: const Color(0xFF05396b),
                        ),
                        title: Text(
                          transaction.title,
                          style: TextStyle(
                              color: const Color(0xFF05396b),
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          transaction.description,
                          style: TextStyle(color: const Color(0xFF05396b)),
                        ),
                        trailing: Text(
                          transaction.amount,
                          style: TextStyle(
                              color: const Color(0xFF05396b),
                              fontSize: 15,
                              fontWeight: FontWeight.normal),
                        ),
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
          onPressed: () {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (_) => const TransaksiPage(),
              ),
            )
                .then((result) {
              if (result is QRIS) {
                resultController.text = result.toString();
                setState(() {
                  _qris = result;
                });
              }
            });
          },
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
                  MaterialPageRoute(
                      builder: (context) => SettingsAndHelpPage()),
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

  @override
  void dispose() {
    resultController.dispose();
    super.dispose();
  }

  QRIS? _qris;

  late final resultController = TextEditingController();
}

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaymentModel>(context);
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 237, 235, 224),
          appBar: AppBar(
            bottom: TabBar(
              indicatorColor: const Color(0xFF05396b),
              labelColor: const Color(0xFF05396b),
              tabs: [
                Tab(text: 'Pengeluaran'),
                Tab(text: 'Pemasukan'),
              ],
            ),
            iconTheme: IconThemeData(color: const Color(0xFF05396b)),
            backgroundColor: const Color(0xFF5cdb94),
            title: Text("Riwayat Transaksi",
                style: TextStyle(color: const Color(0xFF05396b))),
            automaticallyImplyLeading: true,
          ),
          body: TabBarView(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: provider.transactions.length,
                itemBuilder: (context, index) {
                  final transaction = provider.transactions[index];
                  if (transaction.title.contains("Pembayaran") ||
                      transaction.title.contains("Transfer") ||
                      transaction.title.contains("Tarik")) {
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6.0))),
                              backgroundColor: Colors.white,
                              title: Text(
                                'Informasi',
                                style: TextStyle(
                                  color: const Color(0xFF05396b),
                                  fontSize: 23.5,
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Table(
                                    columnWidths: {
                                      0: FixedColumnWidth(85),
                                      1: FlexColumnWidth(2),
                                    },
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    children: [
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Text(
                                              'ID:',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Text(
                                              '${transaction.ID}',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Text(
                                              'Jenis:',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Text(
                                              '${transaction.description}',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Text(
                                              'Nama:',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Text(
                                              '${transaction.name}',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Text(
                                              'Tanggal:',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Text(
                                              '${DateFormat('yyyy-MM-dd HH:mm').format(transaction.date)}',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Text(
                                              'Tagihan:',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Text(
                                              '${transaction.fee}',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Text(
                                              'Lainnya:',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Text(
                                              '${transaction.admin}',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Text(
                                              'Total:',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Text(
                                              '${transaction.amount}',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'OK',
                                    style: TextStyle(
                                      color: const Color(0xFF05396b),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
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
                            transaction.icon,
                            color: const Color(0xFF05396b),
                          ),
                          title: Text(
                            transaction.title,
                            style: TextStyle(
                                color: const Color(0xFF05396b),
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            transaction.description,
                            style: TextStyle(color: const Color(0xFF05396b)),
                          ),
                          trailing: Text(
                            transaction.amount,
                            style: TextStyle(
                                color: const Color(0xFF05396b),
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    );
                  }
                  return SizedBox();
                },
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: provider.transactions.length,
                itemBuilder: (context, index) {
                  final transaction = provider.transactions[index];
                  if (transaction.title.contains("Penambahan")) {
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6.0))),
                              backgroundColor: Colors.white,
                              title: Text(
                                'Informasi',
                                style: TextStyle(
                                  color: const Color(0xFF05396b),
                                  fontSize: 23.5,
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Table(
                                    columnWidths: {
                                      0: FixedColumnWidth(85),
                                      1: FlexColumnWidth(2),
                                    },
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    children: [
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Text(
                                              'ID:',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Text(
                                              '${transaction.ID}',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Text(
                                              'Jenis:',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Text(
                                              '${transaction.description}',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Text(
                                              'Nama:',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Text(
                                              '${transaction.name}',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Text(
                                              'Tanggal:',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Text(
                                              '${DateFormat('yyyy-MM-dd HH:mm').format(transaction.date)}',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Text(
                                              'Tagihan:',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Text(
                                              '${transaction.fee}',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Text(
                                              'Lainnya:',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Text(
                                              '${transaction.admin}',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Text(
                                              'Total:',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Text(
                                              '${transaction.amount}',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: const Color(0xFF05396b),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                height: 1.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'OK',
                                    style: TextStyle(
                                      color: const Color(0xFF05396b),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
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
                            transaction.icon,
                            color: const Color(0xFF05396b),
                          ),
                          title: Text(
                            transaction.title,
                            style: TextStyle(
                                color: const Color(0xFF05396b),
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            transaction.description,
                            style: TextStyle(color: const Color(0xFF05396b)),
                          ),
                          trailing: Text(
                            transaction.amount,
                            style: TextStyle(
                                color: const Color(0xFF05396b),
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    );
                  }
                  return SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListrikPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 235, 224),
      appBar: AppBar(
        iconTheme: IconThemeData(color: const Color(0xFF05396b)),
        backgroundColor: const Color(0xFF5cdb94),
        title: Text("Bayar Listrik",
            style: TextStyle(color: const Color(0xFF05396b))),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: ListrikForm(),
      ),
    );
  }
}

class ListrikForm extends StatefulWidget {
  @override
  _ListrikFormState createState() => _ListrikFormState();
}

class _ListrikFormState extends State<ListrikForm> {
  final TextEditingController _paymentTokenController = TextEditingController();

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _paymentTokenController,
                decoration: InputDecoration(
                  labelText: 'Token Listrik',
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
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String paymentToken = _paymentTokenController.text;
                  if (paymentToken.length == 20) {
                    Navigator.pushNamed(
                      context,
                      '/listrikConfirmation',
                      arguments: paymentToken,
                    );
                  } else {
                    showErrorMessage(
                        "Token tidak terdiri dari 20 karakter. Coba lagi.");
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  backgroundColor: const Color(0xFF5cdb94),
                  foregroundColor: const Color(0xFF05396b),
                  padding: EdgeInsets.symmetric(vertical: 9),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Masukkan',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TokenDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String paymentToken =
        ModalRoute.of(context)!.settings.arguments.toString();
        
    final provider = Provider.of<PaymentModel>(context, listen: false);
    final faker = Faker();
    final dateTime =
        faker.date.dateTimeBetween(DateTime(2017, 9, 7), DateTime(2020, 9, 7));
    final formattedDate = DateFormat('d MMMM y', 'id_ID').format(dateTime);

    int fee = Random().nextInt(100000) + 10000;
    int adminFee = Random().nextInt(2000) + 500;
    int totalFee = fee + adminFee;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 235, 224),
      appBar: AppBar(
        iconTheme: IconThemeData(color: const Color(0xFF05396b)),
        backgroundColor: const Color(0xFF5cdb94),
        title: Text(
          "Bayar Listrik",
          style: TextStyle(color: const Color(0xFF05396b)),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: <Widget>[
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
                        'Token Listrik',
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
                          '$paymentToken',
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
                        'Jenis Pembayaran',
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
                          'Pembayaran Listrik',
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
                        'Nama Pelanggan',
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
                      ),
                    ),
                    TableCell(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          formattedDate,
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
                      ),
                    ),
                    TableCell(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${CurrencyFormat.convertToIdr(fee, 2)}',
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
                      ),
                    ),
                    TableCell(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${CurrencyFormat.convertToIdr(adminFee, 2)}',
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
                      ),
                    ),
                    TableCell(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${CurrencyFormat.convertToIdr(totalFee, 2)}',
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
                Transaction newTransaction = Transaction(
                  icon: Icons.payment,
                  title: 'Pembayaran',
                  description: 'Pembayaran listrik',
                  ID: '$paymentToken',
                  name: 'Gusti Putu Yastika Putra',
                  feeAmount: fee,
                  adminAmount: adminFee,
                  date: DateTime.now(),
                );

                provider.addTransaction(newTransaction);

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0))),
                      backgroundColor: Colors.white,
                      title: Text(
                        'Pembayaran Sukses',
                        style: TextStyle(
                          color: const Color(0xFF05396b),
                          fontSize: 23.5,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashboardPage()),
                            );
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(
                              color: const Color(0xFF05396b),
                            ),
                          ),
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
              child: Text(
                'Bayar Listrik',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
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
  final TextEditingController _paymentIdController = TextEditingController();

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _paymentIdController,
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
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String paymentId = _paymentIdController.text;
                  if (paymentId.length == 10) {
                    Navigator.pushNamed(
                      context,
                      '/paymentConfirmation',
                      arguments: paymentId,
                    );
                  } else {
                    showErrorMessage(
                        "ID tidak terdiri dari 10 karakter. Coba lagi.");
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  backgroundColor: const Color(0xFF5cdb94),
                  foregroundColor: const Color(0xFF05396b),
                  padding: EdgeInsets.symmetric(vertical: 9),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Masukkan',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PaymentDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String paymentId =
        ModalRoute.of(context)!.settings.arguments.toString();
    final provider = Provider.of<PaymentModel>(context, listen: false);
    final faker = Faker();
    final dateTime =
        faker.date.dateTimeBetween(DateTime(2017, 9, 7), DateTime(2020, 9, 7));
    final formattedDate = DateFormat('d MMMM y', 'id_ID').format(dateTime);

    int fee = Random().nextInt(100000) + 10000;
    int adminFee = Random().nextInt(2000) + 500;
    int totalFee = fee + adminFee;
    String fakeName = faker.person.name();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 235, 224),
      appBar: AppBar(
        iconTheme: IconThemeData(color: const Color(0xFF05396b)),
        backgroundColor: const Color(0xFF5cdb94),
        title: Text(
          "Bayar PDAM",
          style: TextStyle(color: const Color(0xFF05396b)),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: <Widget>[
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
                        'ID Pelanggan',
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
                          '$paymentId',
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
                        'Jenis Pembayaran',
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
                          'Pembayaran Air',
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
                        'Nama Pelanggan',
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
                          '$fakeName',
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
                      ),
                    ),
                    TableCell(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          formattedDate,
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
                      ),
                    ),
                    TableCell(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${CurrencyFormat.convertToIdr(fee, 2)}',
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
                      ),
                    ),
                    TableCell(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${CurrencyFormat.convertToIdr(adminFee, 2)}',
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
                      ),
                    ),
                    TableCell(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${CurrencyFormat.convertToIdr(totalFee, 2)}',
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
                Transaction newTransaction = Transaction(
                  icon: Icons.payment,
                  title: 'Pembayaran',
                  description: 'Pembayaran air',
                  ID: '$paymentId',
                  name: '$fakeName',
                  feeAmount: fee,
                  adminAmount: adminFee,
                  date: DateTime.now(),
                );

                provider.addTransaction(newTransaction);

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0))),
                      backgroundColor: Colors.white,
                      title: Text(
                        'Pembayaran Sukses',
                        style: TextStyle(
                          color: const Color(0xFF05396b),
                          fontSize: 23.5,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashboardPage()),
                            );
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(
                              color: const Color(0xFF05396b),
                            ),
                          ),
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
              child: Text(
                'Bayar PDAM',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TransaksiPage extends StatefulWidget {
  const TransaksiPage();

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: const Color(0xFF05396b)),
        backgroundColor: const Color(0xFF5cdb94),
        title: Text("Bayar dengan QR",
            style: TextStyle(color: const Color(0xFF05396b))),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.image,
              color: const Color(0xFF05396b),
            ),
            onPressed: readFromImage,
          ),
        ],
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          returnImage: true,
        ),
        onDetect: onDetect,
      ),
    );
  }

  late final MobileScannerController controller = MobileScannerController(
    formats: [
      BarcodeFormat.qrCode,
    ],
  );

  void onDetect(BarcodeCapture barcodes) {
    for (var barcode in barcodes.barcodes) {
      final rawValue = barcode.rawValue;
      if (rawValue != null) {
        try {
          final qris = QRIS(rawValue);
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TransaksiForm(qris: qris),
            ),
          );
          break;
        } catch (_) {
          print(_);
        }
      }
    }
  }

  Future<void> readFromImage() async {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    final filePath = xFile?.path;
    if (filePath != null) {
      final data = await bf.BarcodeFinder.scanFile(
        path: filePath,
        formats: [bf.BarcodeFormat.QR_CODE],
      );
      if (data != null) {
        final qris = QRIS(data);
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TransaksiForm(qris: qris),
          ),
        );
      }
    }
  }
}

class TransactionArguments {
  final String paymentAmount;
  final String merchantName;

  TransactionArguments(
      {required this.paymentAmount, required this.merchantName});
}

class TransferArguments {
  final String paymentAmount;
  final String paymentRek;
  final String fakeName;

  TransferArguments(
      {required this.paymentAmount,
      required this.paymentRek,
      required this.fakeName});
}

class TarikArguments {
  final String tarikAmount;

  TarikArguments(
      {required this.tarikAmount,});
}


class TransaksiForm extends StatefulWidget {
  final QRIS qris;
  const TransaksiForm({Key? key, required this.qris}) : super(key: key);

  @override
  State<TransaksiForm> createState() => _TransaksiFormState();
}

class _TransaksiFormState extends State<TransaksiForm> {
  final TextEditingController _paymentAmountController =
      TextEditingController();

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaymentModel>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 235, 224),
      appBar: AppBar(
        iconTheme: IconThemeData(color: const Color(0xFF05396b)),
        backgroundColor: const Color(0xFF5cdb94),
        title: Text("Bayar dengan QR",
            style: TextStyle(color: const Color(0xFF05396b))),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.0, top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.qris.merchantName}',
                      style: TextStyle(
                        fontSize: 22,
                        height: 1.25,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF05396b),
                      ),
                    ),
                    Text(
                      '${widget.qris.merchantCity}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: const Color(0xFF05396b),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20.0, top: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF5cdb94),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.store,
                      size: 26.0,
                      color: const Color(0xFF05396b),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _paymentAmountController,
                  decoration: InputDecoration(
                    labelText: 'Nominal Pembayaran',
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
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    String paymentAmount = _paymentAmountController.text;
                    int paymentNom = int.parse(paymentAmount, radix: 10);

                    if (paymentNom < provider.mainAccountBalance) {
                      Navigator.pushNamed(
                        context,
                        '/transactionConfirm',
                        arguments: TransactionArguments(
                          paymentAmount: paymentAmount,
                          merchantName: widget.qris.merchantName!,
                        ),
                      );
                    } else {
                      showErrorMessage(
                          "Nominal pembayaran melebihi saldo rekening Anda.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    backgroundColor: const Color(0xFF5cdb94),
                    foregroundColor: const Color(0xFF05396b),
                    padding: EdgeInsets.symmetric(vertical: 9),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('Masukkan',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TransaksiConfirm extends StatelessWidget {
  final String merchantName;
  final String paymentAmount;

  const TransaksiConfirm({
    Key? key,
    required this.paymentAmount,
    required this.merchantName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int paymentNom = int.tryParse(paymentAmount) ?? 0;

    final TransactionArguments args =
        ModalRoute.of(context)!.settings.arguments as TransactionArguments;
    final String merchantName = args.merchantName;

    final provider = Provider.of<PaymentModel>(context, listen: false);

    int id = Random().nextInt(4294967296) + 0;
    int fee = paymentNom;
    int adminFee = 0;
    int totalFee = fee + adminFee;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 235, 224),
      appBar: AppBar(
        iconTheme: IconThemeData(color: const Color(0xFF05396b)),
        backgroundColor: const Color(0xFF5cdb94),
        title: Text(
          "Transaksi Pembayaran",
          style: TextStyle(color: const Color(0xFF05396b)),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: <Widget>[
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
                        'ID Merchant',
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
                          '$id',
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
                        'Jenis Pembayaran',
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
                          'Transaksi eksternal',
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
                        'Nama Merchant',
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
                          merchantName,
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
                      ),
                    ),
                    TableCell(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${CurrencyFormat.convertToIdr(fee, 2)}',
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
                      ),
                    ),
                    TableCell(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${CurrencyFormat.convertToIdr(adminFee, 2)}',
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
                      ),
                    ),
                    TableCell(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${CurrencyFormat.convertToIdr(totalFee, 2)}',
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
                Transaction newTransaction = Transaction(
                  icon: Icons.payment,
                  title: 'Pembayaran',
                  description: 'Transaksi eksternal',
                  ID: '$id',
                  name: merchantName,
                  feeAmount: fee,
                  adminAmount: adminFee,
                  date: DateTime.now(),
                );

                provider.addTransaction(newTransaction);

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0))),
                      backgroundColor: Colors.white,
                      title: Text(
                        'Pembayaran Sukses',
                        style: TextStyle(
                          color: const Color(0xFF05396b),
                          fontSize: 23.5,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashboardPage()),
                            );
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(
                              color: const Color(0xFF05396b),
                            ),
                          ),
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
              child: Text(
                'Bayar Transaksi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TransferPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 235, 224),
      appBar: AppBar(
        iconTheme: IconThemeData(color: const Color(0xFF05396b)),
        backgroundColor: const Color(0xFF5cdb94),
        title: Text("Transfer Tunai",
            style: TextStyle(color: const Color(0xFF05396b))),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: TransferForm(),
      ),
    );
  }
}

class TransferForm extends StatefulWidget {
  @override
  State<TransferForm> createState() => _TransferFormState();
}

class _TransferFormState extends State<TransferForm> {
  final TextEditingController _paymentRekController = TextEditingController();

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _paymentRekController,
                decoration: InputDecoration(
                  labelText: 'Nomor Rekening Penerima',
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
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String paymentRek = _paymentRekController.text;
                  if (paymentRek.length == 10) {
                    Navigator.pushNamed(
                      context,
                      '/transferNominal',
                      arguments: paymentRek,
                    );
                  } else {
                    showErrorMessage(
                        "ID tidak terdiri dari 10 karakter. Coba lagi.");
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  backgroundColor: const Color(0xFF5cdb94),
                  foregroundColor: const Color(0xFF05396b),
                  padding: EdgeInsets.symmetric(vertical: 9),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Masukkan',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TransferNominal extends StatefulWidget {
  @override
  State<TransferNominal> createState() => _TransferNominalState();
}

class _TransferNominalState extends State<TransferNominal> {
  final TextEditingController _paymentAmountController =
      TextEditingController();

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaymentModel>(context, listen: false);
    final String fakeName = faker.person.name();
    final String paymentRek =
        ModalRoute.of(context)!.settings.arguments.toString();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 235, 224),
      appBar: AppBar(
        iconTheme: IconThemeData(color: const Color(0xFF05396b)),
        backgroundColor: const Color(0xFF5cdb94),
        title: Text("Transfer Tunai",
            style: TextStyle(color: const Color(0xFF05396b))),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.0, top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${fakeName}',
                      style: TextStyle(
                        fontSize: 22,
                        height: 1.25,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF05396b),
                      ),
                    ),
                    Text(
                      '${paymentRek}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: const Color(0xFF05396b),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20.0, top: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF5cdb94),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.credit_card,
                      size: 26.0,
                      color: const Color(0xFF05396b),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _paymentAmountController,
                  decoration: InputDecoration(
                    labelText: 'Nominal Pembayaran',
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
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    String paymentAmount = _paymentAmountController.text;
                    int paymentNom = int.tryParse(paymentAmount) ?? 0;

                    if (paymentNom < provider.mainAccountBalance) {
                      Navigator.pushNamed(
                        context,
                        '/transferConfirm',
                        arguments: TransferArguments(
                          paymentAmount: paymentAmount,
                          paymentRek: paymentRek,
                          fakeName: fakeName,
                        ),
                      );
                    } else {
                      showErrorMessage(
                          "Nominal pembayaran melebihi saldo rekening Anda.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    backgroundColor: const Color(0xFF5cdb94),
                    foregroundColor: const Color(0xFF05396b),
                    padding: EdgeInsets.symmetric(vertical: 9),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('Masukkan',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TransferConfirm extends StatelessWidget {
  final String paymentRek;
  final String paymentAmount;
  final String fakeName;

  const TransferConfirm({
    Key? key,
    required this.paymentAmount,
    required this.paymentRek,
    required this.fakeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int paymentNom = int.tryParse(paymentAmount) ?? 0;

    final TransferArguments args =
        ModalRoute.of(context)!.settings.arguments as TransferArguments;
    final String paymentRek = args.paymentRek;
    final String fakeName = args.fakeName;

    final provider = Provider.of<PaymentModel>(context, listen: false);

    int id = int.parse(paymentRek, radix: 10);
    int fee = paymentNom;
    int adminFee = 0;
    int totalFee = fee + adminFee;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 235, 224),
      appBar: AppBar(
        iconTheme: IconThemeData(color: const Color(0xFF05396b)),
        backgroundColor: const Color(0xFF5cdb94),
        title: Text(
          "Transfer Tunai",
          style: TextStyle(color: const Color(0xFF05396b)),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: <Widget>[
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
                        'ID Merchant',
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
                          '$id',
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
                        'Jenis Pembayaran',
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
                          'Transfer tunai',
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
                        'Nama Penerima',
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
                          '${fakeName}',
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
                      ),
                    ),
                    TableCell(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${CurrencyFormat.convertToIdr(fee, 2)}',
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
                      ),
                    ),
                    TableCell(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${CurrencyFormat.convertToIdr(adminFee, 2)}',
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
                      ),
                    ),
                    TableCell(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${CurrencyFormat.convertToIdr(totalFee, 2)}',
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
                Transaction newTransaction = Transaction(
                  icon: Icons.payment,
                  title: 'Transfer',
                  description: 'Transfer ke akun lain',
                  ID: '$id',
                  name: '$fakeName',
                  feeAmount: fee,
                  adminAmount: adminFee,
                  date: DateTime.now(),
                );

                provider.addTransaction(newTransaction);

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0))),
                      backgroundColor: Colors.white,
                      title: Text(
                        'Transfer Sukses',
                        style: TextStyle(
                          color: const Color(0xFF05396b),
                          fontSize: 23.5,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashboardPage()),
                            );
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(
                              color: const Color(0xFF05396b),
                            ),
                          ),
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
              child: Text(
                'Transfer Tunai',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TarikPage extends StatefulWidget {
  @override
  State<TarikPage> createState() => _TarikPageState();
}

class _TarikPageState extends State<TarikPage> {
  final TextEditingController _tarikAmountController =
      TextEditingController();

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaymentModel>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 235, 224),
      appBar: AppBar(
        iconTheme: IconThemeData(color: const Color(0xFF05396b)),
        backgroundColor: const Color(0xFF5cdb94),
        title: Text("Tarik Tunai",
            style: TextStyle(color: const Color(0xFF05396b))),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _tarikAmountController,
                  decoration: InputDecoration(
                    labelText: 'Nominal Tarik',
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
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    String tarikAmount = _tarikAmountController.text;
                    int tarikNom = int.parse(tarikAmount, radix: 10);

                    if (tarikNom < provider.mainAccountBalance) {
                      Navigator.pushNamed(
                        context,
                        '/tarikConfirm',
                        arguments: TarikArguments(
                          tarikAmount: tarikAmount,
                        ),
                      );
                    } else {
                      showErrorMessage(
                          "Nominal tarik melebihi saldo rekening Anda.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    backgroundColor: const Color(0xFF5cdb94),
                    foregroundColor: const Color(0xFF05396b),
                    padding: EdgeInsets.symmetric(vertical: 9),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('Masukkan',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TarikConfirm extends StatelessWidget {
  final String tarikAmount;

  const TarikConfirm({
    Key? key,
    required this.tarikAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int tarikNom = int.tryParse(tarikAmount) ?? 0;

    final TarikArguments args =
        ModalRoute.of(context)!.settings.arguments as TarikArguments;

    final provider = Provider.of<PaymentModel>(context, listen: false);

    int id = 1511000843;
    int fee = tarikNom;
    int adminFee = 0;
    int totalFee = fee + adminFee;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 235, 224),
      appBar: AppBar(
        iconTheme: IconThemeData(color: const Color(0xFF05396b)),
        backgroundColor: const Color(0xFF5cdb94),
        title: Text(
          "Tarik Tunai",
          style: TextStyle(color: const Color(0xFF05396b)),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: <Widget>[
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
                        'ID Merchant',
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
                          '$id',
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
                        'Jenis Pembayaran',
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
                          'Tarik tunai',
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
                        'Nama Pemilik',
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
                        'Tagihan',
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
                          '${CurrencyFormat.convertToIdr(fee, 2)}',
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
                      ),
                    ),
                    TableCell(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${CurrencyFormat.convertToIdr(adminFee, 2)}',
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
                      ),
                    ),
                    TableCell(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${CurrencyFormat.convertToIdr(totalFee, 2)}',
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
                Transaction newTransaction = Transaction(
                  icon: Icons.payment,
                  title: 'Penarikan',
                  description: 'Tarik tunai',
                  ID: '$id',
                  name: 'Gusti Putu Yastika Putra',
                  feeAmount: fee,
                  adminAmount: adminFee,
                  date: DateTime.now(),
                );

                provider.addTransaction(newTransaction);

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0))),
                      backgroundColor: Colors.white,
                      title: Text(
                        'Penarikan Sukses',
                        style: TextStyle(
                          color: const Color(0xFF05396b),
                          fontSize: 23.5,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashboardPage()),
                            );
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(
                              color: const Color(0xFF05396b),
                            ),
                          ),
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
              child: Text(
                'Tarik Tunai',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
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
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0))),
                    backgroundColor: Colors.white,
                    title: Text(
                      'Konfirmasi',
                      style: TextStyle(
                        color: const Color(0xFF05396b),
                        fontSize: 23.5,
                      ),
                    ),
                    content: Text(
                      "Apakah Anda yakin ingin keluar?",
                      style: TextStyle(
                        color: const Color(0xFF05396b),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Tidak',
                          style: TextStyle(
                            color: const Color(0xFF05396b),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        },
                        child: Text(
                          'Ya',
                          style: TextStyle(
                            color: const Color(0xFF05396b),
                          ),
                        ),
                      ),
                    ],
                  );
                },
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TransaksiPage()),
            );
          },
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
