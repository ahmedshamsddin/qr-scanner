// Author: Ahmad Shamsddin

import 'package:flutter/material.dart';
import 'package:qr_scanner/connecting-flutter-gsheet.dart';
import 'qr_scanner.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NameSheet.init();
  var points = await NameSheet.getPoints();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تجمع إبتكار',
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
          Column(
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
                          inactiveTrackColor:
                              const Color.fromRGBO(2, 36, 71, 1.0));
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
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromRGBO(2, 36, 71, 1.0),
                backgroundColor: const Color.fromRGBO(252, 181, 29, 1.0),
              ),
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
                // show dialog to get names
                var points = await NameSheet.getPoints();
                if (points != null) {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('لائحة النقاط'),
                        content: Table(
                          border: TableBorder.all(),
                          children: [
                            const TableRow(
                              children: [
                                TableCell(child: Center(child: Text('الاسم'))),
                                TableCell(child: Center(child: Text('النقاط'))),
                              ],
                            ),
                            for (var name in points)
                              TableRow(
                                children: [
                                  TableCell(
                                      child: Center(child: Text(name[0]))),
                                  TableCell(
                                      child: Center(
                                          child: Text(name[1].toString()))),
                                ],
                              ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('عرض النقاط'),
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
