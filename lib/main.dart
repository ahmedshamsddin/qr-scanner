// Author: Ahmad Shamsddin

import 'package:flutter/material.dart';
import 'package:qr_scanner/connecting-flutter-gsheet.dart';
import 'qr_scanner.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NameSheet.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Scanner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const QRCodeScreen(),
    );
  }
}

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({super.key});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  final ValueNotifier<bool> _isRegistrationMode = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/ibtikar-logo-yellow.png',
          height: 150,
          width: 150,
        ),
        backgroundColor: const Color.fromRGBO(2, 36, 71, 1.0),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                children: [
                  Text(
                    'زيادة نقاط',
                    style: TextStyle(
                        color: Color.fromRGBO(2, 36, 71, 1.0),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  // Icon(
                  //   Icons.plus_one,
                  //   size: 32,
                  //   color: Color.fromRGBO(2, 36, 71, 1.0),
                  // ),
                ],
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _isRegistrationMode,
                builder: (context, value, child) {
                  return Switch(
                      value: value,
                      onChanged: (value) {
                        _isRegistrationMode.value = value;
                      },
                      activeColor: const Color.fromRGBO(252, 181, 29, 1.0),
                      inactiveTrackColor: const Color.fromRGBO(2, 36, 71, 1.0));
                },
              ),
              const Row(
                children: [
                  // Icon(
                  //   Icons.person,
                  //   size: 32,
                  //   color: Color.fromRGBO(252, 181, 29, 1.0),
                  // ),
                  Text('تسجيل الحضور',
                      style: TextStyle(
                          color: Color.fromRGBO(252, 181, 29, 1.0),
                          fontSize: 16,
                          fontWeight: FontWeight.bold))
                ],
              ),
            ],
          ),
          SizedBox(
            height: 350,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
              child: QRCodeReader(isRegistrationMode: _isRegistrationMode),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _isRegistrationMode.dispose();
    super.dispose();
  }
}
