import 'package:flutter/material.dart';

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
              color: const Color(0xFF5cdb94).withOpacity(0.5),
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
              Navigator.pop(context);
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
                            MaterialPageRoute(builder: (context) => MyApp()),
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
