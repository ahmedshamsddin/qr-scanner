// Author: Ahmad Shamsddin

import "package:flutter/material.dart";
import "package:mobile_scanner/mobile_scanner.dart";

class QRCodeReader extends StatefulWidget {
  const QRCodeReader({super.key, required this.isRegistrationMode});

  final ValueNotifier<bool> isRegistrationMode;

  @override
  State<QRCodeReader> createState() => _QRCodeReaderState();
}

class _QRCodeReaderState extends State<QRCodeReader> {
  late MobileScannerController _controller;
  bool _hasDetected = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
    widget.isRegistrationMode.addListener(_updateScanner);
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.isRegistrationMode.removeListener(_updateScanner);
    super.dispose();
  }

  void _updateScanner() {
    setState(() {});
  }

  void _onDetect(BarcodeCapture capture) {
    if (!_hasDetected) {
      final barcode = capture.barcodes.first;

      setState(() {
        _hasDetected = true;
      });

      _controller.stop();

      // update google sheet depending on the mode
      // if (widget.isRegistrationMode.value) {
      //   // update attended column
      // } else {
      //   // update points column
      // }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
              widget.isRegistrationMode.value ? "أهلاً وسهلاً" : "زيادة نقاط"),
          content: Text(barcode.rawValue ?? "No barcode found"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetDetection();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void _resetDetection() {
    setState(() {
      _hasDetected = false;
    });
    _controller.start();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: SizedBox(
        height: 350,
        child: MobileScanner(
          controller: _controller,
          onDetect: _onDetect,
        ),
      ),
    );
  }
}
