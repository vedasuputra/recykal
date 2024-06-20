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
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await Firebase.initializeApp(
      name: "Recykal", options: DefaultFirebaseOptions.currentPlatform);
  User? user = FirebaseAuth.instance.currentUser;
  runApp(MyApp(user: user));
}

class MyApp extends StatelessWidget {
  final User? user;

  const MyApp({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PaymentModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: user == null ? Login() : DashboardPage(),
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
              recipientName: args.recipientName,
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
          '/keamanan': (context) => KeamananPage(),
          '/syarat-dan-ketentuan': (context) => SyaratDanKetentuanPage(),
          '/pusat-bantuan': (context) => PusatBantuanPage(),
          '/kontak': (context) => KontakPage(),
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String emailErrorMessage = '';
  String passwordErrorMessage = '';

  bool _obscureText = true;

  bool _isValidEmail(String email) {
    RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  bool _validateFields() {
    if (emailController.text.isEmpty) {
      _showAlert('Email');
      return false;
    }
    if (passwordController.text.isEmpty) {
      _showAlert('Password');
      return false;
    }
    return true;
  }

  void _showAlert(String field) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.0))),
          backgroundColor: Colors.white,
          title: Text(
            'Error',
            style: TextStyle(
              color: const Color(0xFF05396b),
              fontSize: 23.5,
            ),
          ),
          content: Text(
            "$field must not be empty. Please try again.",
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
  }

  String email = '';
  String password = '';

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
                  cursorColor: const Color(0xFF05396b),
                  style: TextStyle(color: const Color(0xFF05396b)),
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.email,
                      size: 35,
                      color: const Color(0xFF05396b),
                    ),
                    hintText: 'Enter your email here',
                    hintStyle: TextStyle(color: const Color(0x9905396b)),
                    labelText: "Email",
                    labelStyle: TextStyle(color: const Color(0xFF05396b)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color(0x9905396b)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFF05396b)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 13),
                  ),
                  controller: emailController,
                ),
                SizedBox(height: 10),
                TextField(
                  autocorrect: false,
                  autofocus: true,
                  cursorColor: const Color(0xFF05396b),
                  style: TextStyle(color: const Color(0xFF05396b)),
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
                      borderSide: BorderSide(color: const Color(0x9905396b)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFF05396b)),
                    ),
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
                  controller: passwordController,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateAccount()),
                          );
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
                        onPressed: () async {
                          if (_validateFields()) {
                            setState(() {
                              email = emailController.text;
                              password = passwordController.text;
                            });
                            try {
                              final credential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: email, password: password);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashboardPage()),
                              );
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6.0))),
                                      backgroundColor: Colors.white,
                                      title: Text(
                                        'Error',
                                        style: TextStyle(
                                          color: const Color(0xFF05396b),
                                          fontSize: 23.5,
                                        ),
                                      ),
                                      content: Text(
                                        "No user found for that email.",
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
                              } else if (e.code == 'wrong-password') {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6.0))),
                                      backgroundColor: Colors.white,
                                      title: Text(
                                        'Error',
                                        style: TextStyle(
                                          color: const Color(0xFF05396b),
                                          fontSize: 23.5,
                                        ),
                                      ),
                                      content: Text(
                                        "Wrong password provided for that user.",
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
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6.0))),
                                      backgroundColor: Colors.white,
                                      title: Text(
                                        'Error',
                                        style: TextStyle(
                                          color: const Color(0xFF05396b),
                                          fontSize: 23.5,
                                        ),
                                      ),
                                      content: Text(
                                        "An error occured: ${e.message}",
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
                              }
                            } catch (e) {
                              print(e);
                            }
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

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('users');
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String nameErrorMessage = '';
  String emailErrorMessage = '';
  String passwordErrorMessage = '';
  String confirmPasswordErrorMessage = '';
  String nicknameErrorMessage = '';
  String phoneErrorMessage = '';

  bool _obscureText = true;
  bool _obscureConfirmText = true;

  bool _isValidEmail(String email) {
    RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  bool _isValidNickname(String nickname) {
    RegExp regex = RegExp(r'^[a-zA-Z ]+$');
    return regex.hasMatch(nickname);
  }

  bool _isValidPhoneNumber(String phone) {
    RegExp regex = RegExp(r'^[0-9]{1,13}$');
    return regex.hasMatch(phone);
  }

  bool _validateFields() {
    if (nameController.text.isEmpty) {
      _showAlert('Name');
      return false;
    }
    if (nicknameController.text.isEmpty) {
      _showAlert('Nickname');
      return false;
    }
    if (!_isValidNickname(nicknameController.text)) {
      setState(() {
        nicknameErrorMessage = 'Invalid nickname';
      });
      return false;
    }
    if (emailController.text.isEmpty) {
      _showAlert('Email');
      return false;
    }
    if (!_isValidEmail(emailController.text)) {
      setState(() {
        emailErrorMessage = 'Invalid email address';
      });
      return false;
    }
    if (phoneController.text.isEmpty) {
      _showAlert('Phone Number');
      return false;
    }
    if (!_isValidPhoneNumber(phoneController.text)) {
      setState(() {
        phoneErrorMessage = 'Invalid phone number';
      });
      return false;
    }
    if (passwordController.text.isEmpty) {
      _showAlert('Password');
      return false;
    }
    if (confirmPasswordController.text.isEmpty) {
      _showAlert('Confirm Password');
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        confirmPasswordErrorMessage = 'Passwords do not match';
      });
      return false;
    }
    return true;
  }

  void _showAlert(String field) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.0))),
          backgroundColor: Colors.white,
          title: Text(
            'Error',
            style: TextStyle(
              color: const Color(0xFF05396b),
              fontSize: 23.5,
            ),
          ),
          content: Text(
            "$field must not be empty or invalid. Please try again.",
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
  }

  String email = '';
  String password = '';
  List<String> avatarUrls = [
    'https://images.unsplash.com/photo-1604187351574-c75ca79f5807',
    'https://images.unsplash.com/photo-1620509048004-415ebb9e2755',
    'https://images.unsplash.com/photo-1511189226387-984ec4ffea80'
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 237, 235, 224),
        appBar: AppBar(
          backgroundColor: const Color(0xFF5cdb94),
          title: Text(
            "Create Account",
            style: TextStyle(color: const Color(0xFF05396b)),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            color: const Color(0xFF05396b),
          ),
        ),
        body: Center(
          child: Container(
            height: 500,
            width: 330,
            padding: EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              color: const Color(0xFFe4dfd0),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    autocorrect: false,
                    autofocus: true,
                    cursorColor: nameErrorMessage.isNotEmpty
                        ? Colors.red
                        : const Color(0xFF05396b),
                    style: TextStyle(
                      color: nameErrorMessage.isNotEmpty
                          ? Colors.red
                          : const Color(0xFF05396b),
                    ),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.person,
                        size: 35,
                        color: const Color(0xFF05396b),
                      ),
                      hintText: 'Enter your name here',
                      hintStyle: TextStyle(
                          color: nameErrorMessage.isNotEmpty
                              ? Colors.red
                              : const Color(0x9905396b)),
                      labelText: "Name",
                      labelStyle: TextStyle(
                          color: nameErrorMessage.isNotEmpty
                              ? Colors.red
                              : const Color(0xFF05396b)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: nameErrorMessage.isNotEmpty
                                  ? Colors.red
                                  : const Color(0x9905396b))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: nameErrorMessage.isNotEmpty
                                  ? Colors.red
                                  : const Color(0xFF05396b))),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 13),
                    ),
                    controller: nameController,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    autocorrect: false,
                    autofocus: true,
                    cursorColor: nicknameErrorMessage.isNotEmpty
                        ? Colors.red
                        : const Color(0xFF05396b),
                    style: TextStyle(
                      color: nicknameErrorMessage.isNotEmpty
                          ? Colors.red
                          : const Color(0xFF05396b),
                    ),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.face,
                        size: 35,
                        color: const Color(0xFF05396b),
                      ),
                      hintText: 'Enter your nickname here',
                      hintStyle: TextStyle(
                          color: nicknameErrorMessage.isNotEmpty
                              ? Colors.red
                              : const Color(0x9905396b)),
                      labelText: "Nickname",
                      labelStyle: TextStyle(
                          color: nicknameErrorMessage.isNotEmpty
                              ? Colors.red
                              : const Color(0xFF05396b)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: nicknameErrorMessage.isNotEmpty
                                  ? Colors.red
                                  : const Color(0x9905396b))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: nicknameErrorMessage.isNotEmpty
                                  ? Colors.red
                                  : const Color(0xFF05396b))),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 13),
                    ),
                    controller: nicknameController,
                    onChanged: (value) {
                      setState(() {
                        nicknameErrorMessage = _isValidNickname(value)
                            ? ''
                            : '             Nickname must only contain alphabets.';
                      });
                    },
                  ),
                  nicknameErrorMessage.isNotEmpty
                      ? Column(
                          children: [
                            Text(
                              nicknameErrorMessage,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 15),
                          ],
                        )
                      : SizedBox(height: 10),
                  TextField(
                    autocorrect: false,
                    autofocus: true,
                    cursorColor: emailErrorMessage.isNotEmpty
                        ? Colors.red
                        : const Color(0xFF05396b),
                    style: TextStyle(
                      color: emailErrorMessage.isNotEmpty
                          ? Colors.red
                          : const Color(0xFF05396b),
                    ),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.email,
                        size: 35,
                        color: const Color(0xFF05396b),
                      ),
                      hintText: 'Enter your email here',
                      hintStyle: TextStyle(
                          color: emailErrorMessage.isNotEmpty
                              ? Colors.red
                              : const Color(0x9905396b)),
                      labelText: "Email",
                      labelStyle: TextStyle(
                          color: emailErrorMessage.isNotEmpty
                              ? Colors.red
                              : const Color(0xFF05396b)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: emailErrorMessage.isNotEmpty
                                  ? Colors.red
                                  : const Color(0x9905396b))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: emailErrorMessage.isNotEmpty
                                  ? Colors.red
                                  : const Color(0xFF05396b))),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 13),
                    ),
                    controller: emailController,
                    onChanged: (value) {
                      setState(() {
                        emailErrorMessage = _isValidEmail(value)
                            ? ''
                            : '  Please enter a valid email address';
                      });
                    },
                  ),
                  emailErrorMessage.isNotEmpty
                      ? Column(
                          children: [
                            Text(
                              emailErrorMessage,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 15),
                          ],
                        )
                      : SizedBox(height: 10),
                  TextField(
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    autofocus: true,
                    cursorColor: phoneErrorMessage.isNotEmpty
                        ? Colors.red
                        : const Color(0xFF05396b),
                    style: TextStyle(
                      color: phoneErrorMessage.isNotEmpty
                          ? Colors.red
                          : const Color(0xFF05396b),
                    ),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.phone,
                        size: 35,
                        color: const Color(0xFF05396b),
                      ),
                      hintText: 'Enter your phone number',
                      hintStyle: TextStyle(
                          color: phoneErrorMessage.isNotEmpty
                              ? Colors.red
                              : const Color(0x9905396b)),
                      labelText: "Phone Number",
                      labelStyle: TextStyle(
                          color: phoneErrorMessage.isNotEmpty
                              ? Colors.red
                              : const Color(0xFF05396b)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: phoneErrorMessage.isNotEmpty
                                  ? Colors.red
                                  : const Color(0x9905396b))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: phoneErrorMessage.isNotEmpty
                                  ? Colors.red
                                  : const Color(0xFF05396b))),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 13),
                    ),
                    controller: phoneController,
                    onChanged: (value) {
                      setState(() {
                        phoneErrorMessage = _isValidPhoneNumber(value)
                            ? ''
                            : 'No further than 13 digits, please ';
                      });
                    },
                  ),
                  phoneErrorMessage.isNotEmpty
                      ? Column(
                          children: [
                            Text(
                              phoneErrorMessage,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 15),
                          ],
                        )
                      : SizedBox(height: 10),
                  TextField(
                    autocorrect: false,
                    autofocus: true,
                    cursorColor: passwordErrorMessage.isNotEmpty
                        ? Colors.red
                        : const Color(0xFF05396b),
                    style: TextStyle(
                      color: passwordErrorMessage.isNotEmpty
                          ? Colors.red
                          : const Color(0xFF05396b),
                    ),
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.lock,
                        size: 35,
                        color: const Color(0xFF05396b),
                      ),
                      hintText: 'Enter your password here',
                      hintStyle: TextStyle(
                          color: passwordErrorMessage.isNotEmpty
                              ? Colors.red
                              : const Color(0x9905396b)),
                      labelText: "Password",
                      labelStyle: TextStyle(
                          color: passwordErrorMessage.isNotEmpty
                              ? Colors.red
                              : const Color(0xFF05396b)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: passwordErrorMessage.isNotEmpty
                                  ? Colors.red
                                  : const Color(0x9905396b))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: passwordErrorMessage.isNotEmpty
                                  ? Colors.red
                                  : const Color(0xFF05396b))),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 13),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xFF05396b),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    controller: passwordController,
                    onChanged: (value) {
                      setState(() {
                        passwordErrorMessage = value.length >= 6
                            ? ''
                            : '  Password must be 6+ characters';
                      });
                    },
                  ),
                  passwordErrorMessage.isNotEmpty
                      ? Column(
                          children: [
                            Text(
                              passwordErrorMessage,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 15),
                          ],
                        )
                      : SizedBox(height: 10),
                  TextField(
                    autocorrect: false,
                    autofocus: true,
                    cursorColor: confirmPasswordErrorMessage.isNotEmpty
                        ? Colors.red
                        : const Color(0xFF05396b),
                    style: TextStyle(
                      color: confirmPasswordErrorMessage.isNotEmpty
                          ? Colors.red
                          : const Color(0xFF05396b),
                    ),
                    obscureText: _obscureConfirmText,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.check_circle,
                        size: 35,
                        color: const Color(0xFF05396b),
                      ),
                      hintText: 'Confirm your password',
                      hintStyle: TextStyle(
                          color: confirmPasswordErrorMessage.isNotEmpty
                              ? Colors.red
                              : const Color(0x9905396b)),
                      labelText: "Confirm Password",
                      labelStyle: TextStyle(
                          color: confirmPasswordErrorMessage.isNotEmpty
                              ? Colors.red
                              : const Color(0xFF05396b)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: confirmPasswordErrorMessage.isNotEmpty
                                  ? Colors.red
                                  : const Color(0x9905396b))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: confirmPasswordErrorMessage.isNotEmpty
                                  ? Colors.red
                                  : const Color(0xFF05396b))),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 13),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xFF05396b),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmText = !_obscureConfirmText;
                          });
                        },
                      ),
                    ),
                    controller: confirmPasswordController,
                    onChanged: (value) {
                      setState(() {
                        confirmPasswordErrorMessage =
                            passwordController.text == value
                                ? ''
                                : '  Both passwords are not the same';
                      });
                    },
                  ),
                  confirmPasswordErrorMessage.isNotEmpty
                      ? Column(
                          children: [
                            Text(
                              confirmPasswordErrorMessage,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 15),
                          ],
                        )
                      : SizedBox(height: 10),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
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
                          child: Text('Login Instead',
                              style: TextStyle(fontSize: 15)),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_validateFields()) {
                              setState(() {
                                email = emailController.text;
                                password = passwordController.text;
                              });
                              try {
                                final credential = await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );
                                final User? user =
                                    FirebaseAuth.instance.currentUser;
                                Random random = Random();
                                int index = random.nextInt(avatarUrls.length);
                                String selectedAvatarUrl = avatarUrls[index];
                                int generateRandomNumber() {
                                  Random random = Random();
                                  int randomNumber =
                                      random.nextInt(900000) + 100000;
                                  return randomNumber;
                                }

                                int randomNumber = generateRandomNumber();
                                int rek = int.parse('1511$randomNumber');

                                int generateRandomBalance() {
                                  Random random = Random();
                                  List<int> possibleBalances = [
                                    10000,
                                    20000,
                                    30000,
                                    40000,
                                    50000,
                                    60000,
                                    70000,
                                    80000,
                                    90000,
                                    100000,
                                    200000,
                                    300000,
                                    400000,
                                    500000,
                                    600000,
                                    700000,
                                    800000,
                                    900000,
                                    1000000,
                                    2000000,
                                    3000000,
                                    4000000,
                                    5000000,
                                    6000000,
                                    7000000,
                                    8000000,
                                    9000000,
                                    10000000
                                  ];
                                  int index =
                                      random.nextInt(possibleBalances.length);
                                  return possibleBalances[index];
                                }

                                if (user != null) {
                                  String uid = user.uid;
                                  String email = user.email ?? '';
                                  int balance = generateRandomBalance();
                                  dbRef.child(uid).set({
                                    'userID': uid,
                                    'email': email,
                                    'name': nameController.text,
                                    'nickname': nicknameController.text,
                                    'phone': phoneController.text,
                                    'ava': selectedAvatarUrl,
                                    'rek': rek,
                                    'balance': balance,
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DashboardPage()),
                                  );
                                }
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'email-already-in-use') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6.0))),
                                        backgroundColor: Colors.white,
                                        title: Text(
                                          'Error',
                                          style: TextStyle(
                                            color: const Color(0xFF05396b),
                                            fontSize: 23.5,
                                          ),
                                        ),
                                        content: Text(
                                          "The account already exists for that email.",
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
                                }
                              } catch (e) {
                                print(e);
                              }
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
                          ),
                          child: Text('Create Account',
                              style: TextStyle(fontSize: 15)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

bool _isValidEmail(String email) {
  RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return regex.hasMatch(email);
}

bool _isValidPhoneNumber(String phone) {
  RegExp regex = RegExp(r'^[0-9]{1,13}$');
  return regex.hasMatch(phone);
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

class PaymentModel extends ChangeNotifier {
  int mainAccountBalance = 0;
  final UserData _userData = UserData();

  List<Transaction> transactions = [];

  PaymentModel() {
    _initializeBalance();
    _fetchTransactions();
  }

  Future<void> _initializeBalance() async {
    Map<String, dynamic> userInfo = await _userData.getUserInfo();
    String balanceString = userInfo['balance'];
    mainAccountBalance = int.parse(balanceString);
    notifyListeners();
  }

  Future<void> _fetchTransactions() async {
    final user = FirebaseAuth.instance.currentUser;
    final database = FirebaseDatabase.instance.reference();

    final snapshot = await database.child('transactions').get();
    if (snapshot.exists && snapshot.value is Map) {
      Map<dynamic, dynamic> allTransactions =
          snapshot.value as Map<dynamic, dynamic>;

      List<Transaction> userTransactions = [];
      allTransactions.forEach((key, value) {
        if (value['senderID'] == user?.uid ||
            value['recipientID'] == user?.uid) {
          userTransactions.add(Transaction(
            icon: Icons.payment,
            title: value['paymentType'] ?? 'Transfer',
            description: value['paymentDesc'] ??
                'Transaction with ${value['recipientName']}',
            ID: key,
            name: value['recipientName'] ?? 'Unknown',
            feeAmount: value['fee'] ?? 0,
            adminAmount: value['adminFee'] ?? 0,
            date: DateTime.parse(value['date']),
          ));
        }
      });

      // Sort the transactions based on date in descending order
      userTransactions.sort((a, b) => b.date.compareTo(a.date));

      transactions = userTransactions;
      notifyListeners();
    }
  }

  void addTransaction(Transaction transaction) {
    int transactionAmount = int.parse(transaction.amount
        .replaceAll(RegExp(r',00$'), '')
        .replaceAll(RegExp(r'[^\d]'), ''));

    mainAccountBalance -= transactionAmount;
    transactions.insert(0, transaction);
    notifyListeners();
  }

  void resetState() {
    mainAccountBalance = 0;
    notifyListeners();
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

class DashboardPage extends StatefulWidget {
  const DashboardPage();

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final UserData userData = UserData();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Provider.of<PaymentModel>(context, listen: false).resetState();
      } else {
        Provider.of<PaymentModel>(context, listen: false)._initializeBalance();
        Provider.of<PaymentModel>(context, listen: false)._fetchTransactions();
      }
    });
  }

  Widget build(BuildContext context) {
    final provider = Provider.of<PaymentModel>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 235, 224),
      appBar: AppBar(
        iconTheme: IconThemeData(color: const Color(0xFF05396b)),
        backgroundColor: const Color(0xFF5cdb94),
        title: Text(
          "Beranda",
          style: TextStyle(color: const Color(0xFF05396b)),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
          future: userData.getUserInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              String nickname = snapshot.data?['nickname'] ?? '';
              int rek = snapshot.data?['rek'] ?? '';
              String balance = snapshot.data?['balance'] ?? '';
              PaymentModel paymentModel =
                  Provider.of<PaymentModel>(context, listen: false);
              return Column(
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
                              "Halo, $nickname!",
                              style: TextStyle(
                                fontSize: 15,
                                color: const Color(0xFF05396b),
                              ),
                            ),
                          ],
                        ),
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
                                    fontSize: 14,
                                    color: const Color(0xFF05396b),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  '$rek',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: const Color(0xFF05396b),
                                  ),
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
                                  builder: (context) => TransferPage(),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 4 -
                                      16,
                                  height: 70,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFe4dfd0),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.transfer_within_a_station,
                                    size: 40,
                                    color: const Color(0xFF05396b),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 6),
                                  child: Text(
                                    'Transfer',
                                    style: TextStyle(
                                        color: const Color(0xFF05396b)),
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
                                    builder: (context) => TarikPage()),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 4 -
                                      16,
                                  height: 70,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFe4dfd0),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.attach_money,
                                    size: 40,
                                    color: const Color(0xFF05396b),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 6),
                                  child: Text(
                                    'Tarik',
                                    style: TextStyle(
                                        color: const Color(0xFF05396b)),
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
                                  width: MediaQuery.of(context).size.width / 4 -
                                      16,
                                  height: 70,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFe4dfd0),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.bolt,
                                    size: 40,
                                    color: const Color(0xFF05396b),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 6),
                                  child: Text(
                                    'Listrik',
                                    style: TextStyle(
                                        color: const Color(0xFF05396b)),
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
                                    builder: (context) => AirPage()),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 4 -
                                      16,
                                  height: 70,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFe4dfd0),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.water_drop,
                                    size: 40,
                                    color: const Color(0xFF05396b),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 6),
                                  child: Text(
                                    'PDAM',
                                    style: TextStyle(
                                        color: const Color(0xFF05396b)),
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
                              MaterialPageRoute(
                                  builder: (context) => DetailPage()),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                'Lihat Detail',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: const Color(0xFF05396b)),
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
                                        BorderRadius.all(Radius.circular(6.0)),
                                  ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  'Jenis:',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xFF05396b),
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1.3,
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  '${transaction.description}',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xFF05396b),
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
                                                    color:
                                                        const Color(0xFF05396b),
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1.3,
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  '${transaction.name}',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xFF05396b),
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
                                                    color:
                                                        const Color(0xFF05396b),
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1.3,
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  '${DateFormat('yyyy-MM-dd HH:mm').format(transaction.date)}',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xFF05396b),
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
                                                    color:
                                                        const Color(0xFF05396b),
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1.3,
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  '${transaction.fee}',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xFF05396b),
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
                                                    color:
                                                        const Color(0xFF05396b),
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1.3,
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  '${transaction.admin}',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xFF05396b),
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
                                                    color:
                                                        const Color(0xFF05396b),
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1.3,
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  '${transaction.amount}',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xFF05396b),
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
                                style:
                                    TextStyle(color: const Color(0xFF05396b)),
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
              );
            }
          },
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
      backgroundColor: const Color.fromARGB(255, 237, 235, 224),
      appBar: AppBar(
        iconTheme: IconThemeData(color: const Color(0xFF05396b)),
        backgroundColor: const Color(0xFF5cdb94),
        title: Text(
          "Riwayat Transaksi",
          style: TextStyle(color: const Color(0xFF05396b)),
        ),
        automaticallyImplyLeading: true,
      ),
      body: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: provider.transactions.length,
        itemBuilder: (context, index) {
          final transaction = provider.transactions[index];
          if (transaction.title.contains("Pembayaran") ||
              transaction.title.contains("Transfer") ||
              transaction.title.contains("Penarikan")) {
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      ),
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
        faker.date.dateTimeBetween(DateTime(2024, 6, 20), DateTime(2024, 7, 20));
    final formattedDate = DateFormat('d MMMM y', 'id_ID').format(dateTime);
    final database = FirebaseDatabase.instance.reference();
    final user = FirebaseAuth.instance.currentUser;

    return FutureBuilder<Map<String, dynamic>>(
      future: UserData().getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error fetching user information'));
        }

        Map<String, dynamic>? userInfo = snapshot.data;

        if (userInfo == null) {
          return Center(child: Text('No user information available'));
        }

        String id = paymentToken;
        int fee = Random().nextInt(100000) + 10000;
        int adminFee = Random().nextInt(2000) + 500;
        int totalFee = fee + adminFee;
        String name = userInfo['username'];

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
                              'Pembayaran listrik',
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
                              name,
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
                  onPressed: () async {
                    Transaction newTransaction = Transaction(
                      icon: Icons.payment,
                      title: 'Pembayaran',
                      description: 'Pembayaran listrik',
                      ID: '$paymentToken',
                      name: name,
                      feeAmount: fee,
                      adminAmount: adminFee,
                      date: DateTime.now(),
                    );

                    provider.addTransaction(newTransaction);

                    DatabaseEvent senderEvent = await database
                        .child('users/${user?.uid}/balance')
                        .once();

                    DataSnapshot senderSnapshot = senderEvent.snapshot;
                    int senderBalance = senderSnapshot.value as int;

                    await database.child('transactions').push().set({
                      'senderID': user?.uid,
                      'senderRek': userInfo['rek'],
                      'recipientID': '$paymentToken',
                      'recipientRek': userInfo['rek'],
                      'paymentType': 'Pembayaran',
                      'paymentDesc': 'Pembayaran listrik',
                      'recipientName': 'PLN',
                      'fee': fee,
                      'adminFee': adminFee,
                      'total': totalFee,
                      'date': DateTime.now().toIso8601String(),
                    });

                    await database
                        .child('users/${user?.uid}/balance')
                        .set(senderBalance - totalFee);

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.0))),
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
      },
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
        faker.date.dateTimeBetween(DateTime(2024, 6, 20), DateTime(2024, 7, 20));
    final formattedDate = DateFormat('d MMMM y', 'id_ID').format(dateTime);
    final database = FirebaseDatabase.instance.reference();
    final user = FirebaseAuth.instance.currentUser;

    return FutureBuilder<Map<String, dynamic>>(
      future: UserData().getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error fetching user information'));
        }

        Map<String, dynamic>? userInfo = snapshot.data;

        if (userInfo == null) {
          return Center(child: Text('No user information available'));
        }

        int fee = Random().nextInt(100000) + 10000;
        int adminFee = Random().nextInt(2000) + 500;
        int totalFee = fee + adminFee;
        String name = userInfo['username'];

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
                              'Pembayaran air',
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
                              name,
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
                  onPressed: () async {
                    Transaction newTransaction = Transaction(
                      icon: Icons.payment,
                      title: 'Pembayaran',
                      description: 'Pembayaran air',
                      ID: '$paymentId',
                      name: name,
                      feeAmount: fee,
                      adminAmount: adminFee,
                      date: DateTime.now(),
                    );

                    provider.addTransaction(newTransaction);

                    DatabaseEvent senderEvent = await database
                        .child('users/${user?.uid}/balance')
                        .once();

                    DataSnapshot senderSnapshot = senderEvent.snapshot;
                    int senderBalance = senderSnapshot.value as int;

                    await database.child('transactions').push().set({
                      'senderID': user?.uid,
                      'senderRek': userInfo['rek'],
                      'recipientID': '$paymentId',
                      'recipientRek': userInfo['rek'],
                      'paymentType': 'Pembayaran',
                      'paymentDesc': 'Pembayaran air',
                      'recipientName': 'PDAM',
                      'fee': fee,
                      'adminFee': adminFee,
                      'total': totalFee,
                      'date': DateTime.now().toIso8601String(),
                    });

                    await database
                        .child('users/${user?.uid}/balance')
                        .set(senderBalance - totalFee);

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.0))),
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
      },
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
  final String recipientName;

  TransferArguments({
    required this.paymentAmount,
    required this.paymentRek,
    required this.fakeName,
    required this.recipientName,
  });
}

class TarikArguments {
  final String tarikAmount;

  TarikArguments({
    required this.tarikAmount,
  });
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
    final user = FirebaseAuth.instance.currentUser;
    final database = FirebaseDatabase.instance.reference();

    final TransactionArguments args =
        ModalRoute.of(context)!.settings.arguments as TransactionArguments;
    final String merchantName = args.merchantName;

    final provider = Provider.of<PaymentModel>(context, listen: false);

    return FutureBuilder<Map<String, dynamic>>(
      future: UserData().getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error fetching user information'));
        }

        Map<String, dynamic>? userInfo = snapshot.data;

        if (userInfo == null) {
          return Center(child: Text('No user information available'));
        }

        int id = Random().nextInt(4294967296) + 0;
        int fee = paymentNom;
        int adminFee = 0;
        int totalFee = fee + adminFee;

        String? recipientID;

        UserData().getUserIDByRek(id).then((value) {
          recipientID = value;
        });

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
                  onPressed: () async {
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

                    DatabaseEvent senderEvent = await database
                        .child('users/${user?.uid}/balance')
                        .once();

                    DataSnapshot senderSnapshot = senderEvent.snapshot;
                    int senderBalance = senderSnapshot.value as int;

                    await database.child('transactions').push().set({
                      'senderID': user?.uid,
                      'senderRek': userInfo['rek'],
                      'recipientID': '$id',
                      'recipientRek': '$id',
                      'paymentType': 'Pembayaran',
                      'paymentDesc': 'Pembayaran merchant',
                      'recipientName': merchantName,
                      'fee': fee,
                      'adminFee': adminFee,
                      'total': totalFee,
                      'date': DateTime.now().toIso8601String(),
                    });

                    await database
                        .child('users/${user?.uid}/balance')
                        .set(senderBalance - totalFee);

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.0))),
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
      },
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

  String currentUserRek = '';

  @override
  void initState() {
    super.initState();
    fetchCurrentUserRek();
  }

  void fetchCurrentUserRek() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref('users/${user.uid}');
      DatabaseEvent event = await ref.once();
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          currentUserRek = data['rek']?.toString() ?? '';
        });
      } else {
        setState(() {
          currentUserRek = '';
        });
      }
    }
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void navigateToTransferNominal(String paymentRek) async {
    if (paymentRek == currentUserRek) {
      showErrorMessage(
          "Anda tidak dapat mentransfer ke rekening Anda sendiri.");
    } else {
      DatabaseReference ref = FirebaseDatabase.instance.ref('users');
      DatabaseEvent event =
          await ref.orderByChild('rek').equalTo(int.parse(paymentRek)).once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        Navigator.pushNamed(
          context,
          '/transferNominal',
          arguments: paymentRek,
        );
      } else {
        showErrorMessage("Rekening tidak ditemukan. Silakan coba lagi.");
      }
    }
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
                    navigateToTransferNominal(paymentRek);
                  } else {
                    showErrorMessage(
                        "Nomor rekening harus terdiri dari 10 digit. Coba lagi.");
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
  String recipientName = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchRecipientName();
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void fetchRecipientName() async {
    final String paymentRek =
        ModalRoute.of(context)!.settings.arguments.toString();
    DatabaseReference ref = FirebaseDatabase.instance.ref('users');
    DatabaseEvent event =
        await ref.orderByChild('rek').equalTo(int.parse(paymentRek)).once();
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> users =
          event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        recipientName = users.values.first['name'];
      });
    } else {
      setState(() {
        recipientName = 'Unknown';
      });
    }
  }

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
                      '${recipientName}',
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
                    String paymentAmount = _paymentAmountController.text.trim();
                    if (paymentAmount.isEmpty) {
                      showErrorMessage(
                          "Nominal pembayaran tidak boleh kosong.");
                      return;
                    }

                    int paymentNom = int.tryParse(paymentAmount) ?? 0;

                    if (paymentNom <= 0) {
                      showErrorMessage(
                          "Nominal pembayaran harus lebih dari 0.");
                      return;
                    }

                    if (paymentNom >= provider.mainAccountBalance) {
                      showErrorMessage(
                          "Nominal pembayaran melebihi saldo rekening Anda.");
                      return;
                    }

                    Navigator.pushNamed(
                      context,
                      '/transferConfirm',
                      arguments: TransferArguments(
                        paymentAmount: paymentAmount,
                        paymentRek: paymentRek,
                        fakeName: fakeName,
                        recipientName: recipientName,
                      ),
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
  final String recipientName;

  const TransferConfirm({
    Key? key,
    required this.paymentAmount,
    required this.paymentRek,
    required this.fakeName,
    required this.recipientName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaymentModel>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;
    final database = FirebaseDatabase.instance.reference();

    return FutureBuilder<Map<String, dynamic>>(
      future: UserData().getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error fetching user information'));
        }

        Map<String, dynamic>? userInfo = snapshot.data;

        if (userInfo == null) {
          return Center(child: Text('No user information available'));
        }

        int id = int.parse(paymentRek, radix: 10);
        int fee = int.tryParse(paymentAmount) ?? 0;
        int adminFee = 0;
        int totalFee = fee + adminFee;

        String? recipientID;

        UserData().getUserIDByRek(id).then((value) {
          recipientID = value;
        });

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
                            'Rekening Penerima',
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
                              '$recipientName',
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
                  onPressed: () async {
                    Transaction newTransaction = Transaction(
                      icon: Icons.payment,
                      title: 'Transfer',
                      description: 'Transfer ke akun lain',
                      ID: '$id',
                      name: '$recipientName',
                      feeAmount: fee,
                      adminAmount: adminFee,
                      date: DateTime.now(),
                    );

                    provider.addTransaction(newTransaction);

                    DatabaseEvent senderEvent = await database
                        .child('users/${user?.uid}/balance')
                        .once();
                    DatabaseEvent recipientEvent = await database
                        .child('users/$recipientID/balance')
                        .once();

                    DataSnapshot senderSnapshot = senderEvent.snapshot;
                    DataSnapshot recipientSnapshot = recipientEvent.snapshot;

                    int senderBalance = senderSnapshot.value as int;
                    int recipientBalance = recipientSnapshot.value as int;

                    await database.child('transactions').push().set({
                      'senderID': user?.uid,
                      'senderRek': userInfo['rek'],
                      'recipientID': recipientID,
                      'recipientRek': id,
                      'paymentType': 'Transfer',
                      'paymentDesc': 'Transfer ke akun lain',
                      'recipientName': recipientName,
                      'fee': fee,
                      'adminFee': adminFee,
                      'total': totalFee,
                      'date': DateTime.now().toIso8601String(),
                    });

                    await database
                        .child('users/${user?.uid}/balance')
                        .set(senderBalance - totalFee);
                    await database
                        .child('users/$recipientID/balance')
                        .set(recipientBalance + fee);

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0)),
                          ),
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
                                    builder: (context) => DashboardPage(),
                                  ),
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
      },
    );
  }
}

class TarikPage extends StatefulWidget {
  @override
  State<TarikPage> createState() => _TarikPageState();
}

class _TarikPageState extends State<TarikPage> {
  final TextEditingController _tarikAmountController = TextEditingController();

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

                    if (tarikAmount.isEmpty) {
                      showErrorMessage("Nominal penarikan tidak boleh kosong.");
                      return;
                    }

                    int? tarikNom = int.tryParse(tarikAmount);

                    if (tarikNom == null) {
                      showErrorMessage(
                          "Masukkan nominal penarikan yang valid.");
                      return;
                    }

                    if (tarikNom <= 0) {
                      showErrorMessage("Nominal penarikan harus lebih dari 0.");
                      return;
                    }

                    if (tarikNom >= provider.mainAccountBalance) {
                      showErrorMessage(
                          "Nominal penarikan melebihi saldo rekening Anda.");
                      return;
                    }

                    Navigator.pushNamed(
                      context,
                      '/tarikConfirm',
                      arguments: TarikArguments(
                        tarikAmount: tarikAmount,
                      ),
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
    final user = FirebaseAuth.instance.currentUser;
    final database = FirebaseDatabase.instance.reference();

    return FutureBuilder<Map<String, dynamic>>(
      future: UserData().getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error fetching user information'));
        }

        Map<String, dynamic>? userInfo = snapshot.data;

        if (userInfo == null) {
          return Center(child: Text('No user information available'));
        }

        int id = userInfo['rek'];
        int fee = tarikNom;
        int adminFee = 1000;
        int totalFee = fee + adminFee;
        String name = userInfo['username'];

        String? recipientID;

        UserData().getUserIDByRek(id).then((value) {
          recipientID = value;
        });

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
                            'Rekening Anda',
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
                              name,
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
                  onPressed: () async {
                    Transaction newTransaction = Transaction(
                      icon: Icons.payment,
                      title: 'Penarikan',
                      description: 'Tarik tunai',
                      ID: '$id',
                      name: name,
                      feeAmount: fee,
                      adminAmount: adminFee,
                      date: DateTime.now(),
                    );

                    provider.addTransaction(newTransaction);

                    DatabaseEvent senderEvent = await database
                        .child('users/${user?.uid}/balance')
                        .once();

                    DataSnapshot senderSnapshot = senderEvent.snapshot;
                    int senderBalance = senderSnapshot.value as int;

                    await database.child('transactions').push().set({
                      'senderID': user?.uid,
                      'senderRek': userInfo['rek'],
                      'recipientID': user?.uid,
                      'recipientRek': userInfo['rek'],
                      'paymentType': 'Penarikan',
                      'paymentDesc': 'Tarik tunai',
                      'recipientName': name,
                      'fee': fee,
                      'adminFee': adminFee,
                      'total': totalFee,
                      'date': DateTime.now().toIso8601String(),
                    });

                    await database
                        .child('users/${user?.uid}/balance')
                        .set(senderBalance - totalFee);

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.0))),
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
      },
    );
  }
}

class UserData {
  Future<Map<String, dynamic>> getUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? userID = user?.uid;
    final ref = FirebaseDatabase.instance.ref();

    final usernameSnapshot = await ref.child('users/$userID/name').get();
    String username =
        usernameSnapshot.exists ? usernameSnapshot.value.toString() : '';

    final avatarSnapshot = await ref.child('users/$userID/ava').get();
    String avatarUrl =
        avatarSnapshot.exists ? avatarSnapshot.value.toString() : '';

    final balanceSnapshot = await ref.child('users/$userID/balance').get();
    String balance =
        balanceSnapshot.exists ? balanceSnapshot.value.toString() : '';

    final nicknameSnapshot = await ref.child('users/$userID/nickname').get();
    String nickname =
        nicknameSnapshot.exists ? nicknameSnapshot.value.toString() : '';

    final phoneSnapshot = await ref.child('users/$userID/phone').get();
    String phone = phoneSnapshot.exists ? phoneSnapshot.value.toString() : '';

    final emailSnapshot = await ref.child('users/$userID/email').get();
    String email = emailSnapshot.exists ? emailSnapshot.value.toString() : '';

    final rekSnapshot = await ref.child('users/$userID/rek').get();
    int rek = rekSnapshot.exists ? int.parse(rekSnapshot.value.toString()) : 0;

    return {
      'username': username,
      'avatarUrl': avatarUrl,
      'balance': balance,
      'nickname': nickname,
      'phone': phone,
      'email': email,
      'rek': rek,
    };
  }

  Future<String?> getUserIDByRek(int rek) async {
    final ref = FirebaseDatabase.instance.reference();

    DataSnapshot usersSnapshot = await ref.child('users').get();

    if (usersSnapshot.exists && usersSnapshot.value != null) {
      Map<String, dynamic> usersData = Map<String, dynamic>.from(
          usersSnapshot.value as Map<dynamic, dynamic>);

      for (var entry in usersData.entries) {
        if (entry.value['rek'] == rek) {
          return entry.key;
        }
      }
    }
    return null;
  }
}

class SettingsAndHelpPage extends StatelessWidget {
  final List<String> help = [
    'Keamanan',
    'Syarat dan Ketentuan',
    'Pusat Bantuan',
    'Kontak',
  ];

  final UserData userData = UserData();

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
      body: FutureBuilder<Map<String, dynamic>>(
        future: userData.getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            String username = snapshot.data?['username'] ?? '';
            String avatarUrl = snapshot.data?['avatarUrl'] ?? '';

            return SingleChildScrollView(
              child: Column(children: [
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfileScreen(
                                  avatarUrl: avatarUrl,
                                  fullName: username,
                                )),
                      );
                    },
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
                                backgroundImage: NetworkImage(avatarUrl),
                              ),
                              SizedBox(width: 15.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    username,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF05396b),
                                    ),
                                  ),
                                  SizedBox(height: 0.0),
                                  Text(
                                    '1581 BS Galang Panji',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: const Color(0xFF05396b),
                                    ),
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
                ),
                _buildSection('Help', help),
                GestureDetector(
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
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
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
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
            );
          }
        },
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
                  onTap: () {
                    String route;
                    switch (items[index]) {
                      case 'Keamanan':
                        route = '/keamanan';
                        break;
                      case 'Syarat dan Ketentuan':
                        route = '/syarat-dan-ketentuan';
                        break;
                      case 'Pusat Bantuan':
                        route = '/pusat-bantuan';
                        break;
                      case 'Kontak':
                        route = '/kontak';
                        break;
                      default:
                        route = '/';
                        break;
                    }
                    Navigator.pushNamed(context, route);
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final String avatarUrl;
  final String fullName;

  EditProfileScreen({required this.avatarUrl, required this.fullName});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final UserData _userData = UserData();
  late Future<Map<String, dynamic>> _userInfoFuture;
  String nameErrorMessage = '';
  String phoneErrorMessage = '';
  String avaErrorMessage = '';
  int rek = 0;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController avaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userInfoFuture = _userData.getUserInfo();
    _userInfoFuture.then((userInfo) {
      setState(() {
        nameController.text = userInfo['nickname'] ?? '';
        phoneController.text = userInfo['phone'] ?? '';
        avaController.text = userInfo['avatarUrl'] ?? '';
        rek = userInfo['rek'] ?? 0;
      });
    });
  }

  bool _validateFields() {
    bool isValid = true;

    if (nameController.text.isEmpty) {
      _showAlert('Name');
      isValid = false;
    }
    if (phoneController.text.isEmpty) {
      _showAlert('Phone Number');
      isValid = false;
    } else if (!_isValidPhoneNumber(phoneController.text)) {
      setState(() {
        phoneErrorMessage = 'Invalid phone number';
      });
      isValid = false;
    }
    if (avaController.text.isEmpty) {
      _showAlert('Avatar URL');
      isValid = false;
    } else if (!_isValidUrl(avaController.text)) {
      setState(() {
        avaErrorMessage = 'Invalid URL';
      });
      isValid = false;
    }

    return isValid;
  }

  void _showAlert(String field) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.0))),
          backgroundColor: Colors.white,
          title: Text(
            'Error',
            style: TextStyle(
              color: const Color(0xFF05396b),
              fontSize: 23.5,
            ),
          ),
          content: Text(
            "$field must not be empty or invalid. Please try again.",
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
  }

  bool _isValidUrl(String url) {
    final urlRegExp = RegExp(
      r'^https:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,}\/?.*$',
      caseSensitive: false,
    );
    return urlRegExp.hasMatch(url);
  }

  bool _isValidPhoneNumber(String phone) {
    RegExp regex = RegExp(r'^[0-9]{1,13}$');
    return regex.hasMatch(phone);
  }

  bool _isValidNickname(String nickname) {
    RegExp regex = RegExp(r'^[a-zA-Z ]+$');
    return regex.hasMatch(nickname);
  }

  void _saveChanges() {
    if (_validateFields()) {
      User? user = FirebaseAuth.instance.currentUser;
      String? userId = user?.uid;

      DatabaseReference userRef =
          FirebaseDatabase.instance.reference().child('users/$userId');

      userRef.update({
        'nickname': nameController.text,
        'phone': phoneController.text,
        'ava': avaController.text,
      }).then((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
              ),
              backgroundColor: Colors.white,
              title: Text(
                'Success',
                style: TextStyle(
                  color: const Color(0xFF05396b),
                  fontSize: 23.5,
                ),
              ),
              content: Text(
                'Changes saved successfully!',
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
      }).catchError((error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
              ),
              backgroundColor: Colors.white,
              title: Text(
                'Error',
                style: TextStyle(
                  color: const Color(0xFF05396b),
                  fontSize: 23.5,
                ),
              ),
              content: Text(
                'Failed to save changes: $error',
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 235, 224),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5cdb94),
        title: Text("Edit Profile",
            style: TextStyle(color: const Color(0xFF05396b))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsAndHelpPage()),
            );
          },
          color: const Color(0xFF05396b),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _userInfoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(widget.avatarUrl),
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      widget.fullName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF05396b),
                      ),
                    ),
                    Text(
                      '$rek | 1581 BS Galang Panji',
                      style: TextStyle(
                        fontSize: 15,
                        color: const Color(0xFF05396b),
                      ),
                    ),
                    SizedBox(height: 40.0),
                    TextField(
                      autocorrect: false,
                      cursorColor: nameErrorMessage.isNotEmpty
                          ? Colors.red
                          : const Color(0xFF05396b),
                      style: TextStyle(
                        color: nameErrorMessage.isNotEmpty
                            ? Colors.red
                            : const Color(0xFF05396b),
                      ),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.person,
                          size: 35,
                          color: const Color(0xFF05396b),
                        ),
                        hintText: 'Enter your nickname here',
                        hintStyle: TextStyle(
                            color: nameErrorMessage.isNotEmpty
                                ? Colors.red
                                : const Color(0x9905396b)),
                        labelText: "Nickname",
                        labelStyle: TextStyle(
                            color: nameErrorMessage.isNotEmpty
                                ? Colors.red
                                : const Color(0xFF05396b)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: nameErrorMessage.isNotEmpty
                                    ? Colors.red
                                    : const Color(0x9905396b))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: nameErrorMessage.isNotEmpty
                                    ? Colors.red
                                    : const Color(0xFF05396b))),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 13),
                      ),
                      controller: nameController,
                      onTap: () {
                        nameController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: nameController.text.length,
                        );
                      },
                      onChanged: (value) {
                        setState(() {
                          nameErrorMessage = _isValidNickname(value)
                              ? ''
                              : 'Nickname must only contain alphabets.           ';
                        });
                      },
                    ),
                    if (nameErrorMessage.isNotEmpty)
                      Column(
                        children: [
                          Text(
                            nameErrorMessage,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    SizedBox(height: 15.0),
                    TextField(
                      autocorrect: false,
                      keyboardType: TextInputType.phone,
                      cursorColor: phoneErrorMessage.isNotEmpty
                          ? Colors.red
                          : const Color(0xFF05396b),
                      style: TextStyle(
                        color: phoneErrorMessage.isNotEmpty
                            ? Colors.red
                            : const Color(0xFF05396b),
                      ),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.call,
                          size: 35,
                          color: const Color(0xFF05396b),
                        ),
                        hintText: 'Enter your phone number',
                        hintStyle: TextStyle(
                            color: phoneErrorMessage.isNotEmpty
                                ? Colors.red
                                : const Color(0x9905396b)),
                        labelText: "Phone Number",
                        labelStyle: TextStyle(
                            color: phoneErrorMessage.isNotEmpty
                                ? Colors.red
                                : const Color(0xFF05396b)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: phoneErrorMessage.isNotEmpty
                                  ? Colors.red
                                  : const Color(0x9905396b)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: phoneErrorMessage.isNotEmpty
                                  ? Colors.red
                                  : const Color(0xFF05396b)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 13),
                      ),
                      controller: phoneController,
                      onTap: () {
                        phoneController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: phoneController.text.length,
                        );
                      },
                      onChanged: (value) {
                        setState(() {
                          phoneErrorMessage = _isValidPhoneNumber(value)
                              ? ''
                              : 'No more than 13 digits, please                          ';
                        });
                      },
                    ),
                    if (phoneErrorMessage.isNotEmpty)
                      Column(
                        children: [
                          Text(
                            phoneErrorMessage,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    SizedBox(height: 15.0),
                    TextField(
                      autocorrect: false,
                      cursorColor: avaErrorMessage.isNotEmpty
                          ? Colors.red
                          : const Color(0xFF05396b),
                      style: TextStyle(
                        color: avaErrorMessage.isNotEmpty
                            ? Colors.red
                            : const Color(0xFF05396b),
                      ),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.image,
                          size: 35,
                          color: const Color(0xFF05396b),
                        ),
                        hintText: 'Enter your avatar URL',
                        hintStyle: TextStyle(
                            color: avaErrorMessage.isNotEmpty
                                ? Colors.red
                                : const Color(0x9905396b)),
                        labelText: "Avatar URL:",
                        labelStyle: TextStyle(
                            color: avaErrorMessage.isNotEmpty
                                ? Colors.red
                                : const Color(0xFF05396b)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: avaErrorMessage.isNotEmpty
                                    ? Colors.red
                                    : const Color(0x9905396b))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: avaErrorMessage.isNotEmpty
                                    ? Colors.red
                                    : const Color(0xFF05396b))),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 13),
                      ),
                      controller: avaController,
                      onTap: () {
                        avaController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: avaController.text.length,
                        );
                      },
                      onChanged: (value) {
                        setState(() {
                          avaErrorMessage = _isValidUrl(value)
                              ? ''
                              : 'Make sure the URL is correct and valid.           ';
                        });
                      },
                    ),
                    if (avaErrorMessage.isNotEmpty)
                      Column(
                        children: [
                          Text(
                            avaErrorMessage,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          backgroundColor: const Color(0xFF5cdb94),
                          foregroundColor: const Color(0xFF05396b),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                        onPressed: _saveChanges,
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class KeamananPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 235, 224),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5cdb94),
        title:
            Text("Keamanan", style: TextStyle(color: const Color(0xFF05396b))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: const Color(0xFF05396b),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Kebijakan Privasi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Terakhir diperbarui: 1 Juni 2024',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Pendahuluan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Recykal adalah sebuah aplikasi yang dikembangkan untuk memudahkan pengguna dalam mengakses informasi dan melakukan transaksi terkait dengan bank sampah. Kami menghargai privasi pengguna kami dan berkomitmen untuk melindungi informasi pribadi yang dikumpulkan.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Informasi yang Kami Kumpulkan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Kami dapat mengumpulkan informasi berikut dari pengguna aplikasi:',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 10),
              Text(
                '- Informasi identifikasi pribadi seperti nama, alamat, nomor telepon, dan alamat email.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              Text(
                '- Informasi akun bank yang diperlukan untuk melakukan transaksi melalui aplikasi.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              Text(
                '- Informasi lokasi jika pengguna mengizinkan akses ke layanan lokasi pada perangkat.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Penggunaan Informasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Informasi yang dikumpulkan dapat digunakan untuk:',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 10),
              Text(
                '- Memproses transaksi yang diminta pengguna.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              Text(
                '- Mengirimkan pemberitahuan dan informasi terkait layanan.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              Text(
                '- Memperbaiki dan mengembangkan layanan kami.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Keamanan Informasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Kami menggunakan langkah-langkah keamanan teknis dan administratif yang sesuai untuk melindungi informasi pribadi pengguna dari akses, penggunaan, atau pengungkapan yang tidak sah.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Perubahan pada Kebijakan Privasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Kami dapat memperbarui kebijakan privasi ini dari waktu ke waktu. Kami akan memberitahukan pengguna tentang perubahan tersebut dengan cara yang sesuai.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Kontak Kami',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Jika Anda memiliki pertanyaan atau komentar tentang kebijakan privasi kami, silakan hubungi kami di support@banksampahapp.com.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class SyaratDanKetentuanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 235, 224),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5cdb94),
        title: Text(
          "Syarat dan Ketentuan",
          style: TextStyle(color: const Color(0xFF05396b)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: const Color(0xFF05396b),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Pendahuluan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Recykal adalah sebuah aplikasi yang bertujuan untuk memfasilitasi pengguna dalam mengakses informasi dan melakukan transaksi terkait bank sampah. Kami menghargai kepercayaan Anda menggunakan aplikasi ini dan berkomitmen untuk memberikan layanan yang aman dan bermanfaat.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Syarat Penggunaan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Dengan mengunduh, mengakses, atau menggunakan aplikasi Recykal, Anda menyetujui syarat dan ketentuan yang berlaku dan memahami bahwa penggunaan aplikasi ini tunduk pada kebijakan privasi yang tercantum di bawah.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Ketentuan Layanan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Recykal menyediakan platform untuk menghubungkan pengguna dengan layanan bank sampah. Kami tidak bertanggung jawab atas kualitas layanan yang diberikan oleh pihak ketiga, termasuk bank sampah yang terdaftar di aplikasi ini.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Perubahan Syarat dan Ketentuan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Kami dapat memperbarui syarat dan ketentuan ini dari waktu ke waktu. Pengguna akan diberitahu tentang perubahan tersebut melalui aplikasi atau alamat email yang terdaftar.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Kontak Kami',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Jika Anda memiliki pertanyaan atau masukan terkait syarat dan ketentuan aplikasi Recykal, silakan hubungi kami di support@recykalapp.com.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class PusatBantuanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 235, 224),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5cdb94),
        title: Text("Pusat Bantuan",
            style: TextStyle(color: const Color(0xFF05396b))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: const Color(0xFF05396b),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Apa Itu Bank Sampah?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Bank Sampah adalah sebuah sistem yang menggalakkan masyarakat untuk mengumpulkan sampah-sampah yang sudah dipilah sesuai jenisnya, untuk dijual kepada pengepul atau daur ulang. Pengumpulan sampah ini biasanya memberikan imbalan berupa uang atau hadiah lainnya.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Bagaimana Cara Menggunakan Aplikasi Recykal untuk Bank Sampah?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Untuk menggunakan aplikasi Recykal dalam transaksi di bank sampah, ikuti langkah-langkah berikut:',
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 10),
              Text(
                '1. Unduh dan pasang aplikasi Recykal dari Google Play Store atau Apple App Store.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              Text(
                '2. Daftar atau masuk dengan akun Anda.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              Text(
                '3. Pilih menu Setoran, lalu ikuti instruksi untuk memilah dan mengirimkan sampah Anda.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Apa Manfaat Menggunakan Bank Sampah?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Menggunakan bank sampah dan aplikasi Recykal memberikan banyak manfaat, antara lain:',
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 10),
              Text(
                '- Membantu dalam pengelolaan sampah secara lebih efisien.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              Text(
                '- Mendorong kesadaran lingkungan dan kepedulian terhadap daur ulang.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              Text(
                '- Memberikan penghasilan tambahan bagi masyarakat yang mengumpulkan sampah.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Bagaimana Cara Mendapatkan Poin atau Imbalan di Aplikasi Recykal?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Poin atau imbalan di aplikasi Recykal didapatkan dari transaksi setoran sampah ke bank sampah. Semakin banyak dan berkualitas sampah yang Anda kumpulkan, semakin banyak poin yang bisa Anda dapatkan.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Apakah Aplikasi Recykal Aman untuk Digunakan?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Kami mengutamakan keamanan data pengguna. Aplikasi Recykal dilengkapi dengan teknologi keamanan mutakhir untuk melindungi informasi pribadi Anda.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Bagaimana Cara Menghubungi Layanan Pelanggan Recykal?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Jika Anda memiliki pertanyaan lebih lanjut atau mengalami masalah, jangan ragu untuk menghubungi tim dukungan kami melalui email di support@recykalapp.com.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class KontakPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 235, 224),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5cdb94),
        title: Text("Kontak", style: TextStyle(color: const Color(0xFF05396b))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: const Color(0xFF05396b),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Hubungi Kami',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Jika Anda memiliki pertanyaan lebih lanjut atau masukan, jangan ragu untuk menghubungi kami:',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Email: support@recykalapp.com',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Telepon: +62 123 456 789',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF05396b),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
