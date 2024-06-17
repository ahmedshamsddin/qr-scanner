import "package:flutter/material.dart";
import "package:mobile_scanner/mobile_scanner.dart";
import 'package:qr_scanner/connecting-flutter-gsheet.dart'; // Import the correct path

class QRCodeReader extends StatefulWidget {
  const QRCodeReader({super.key, required this.isRegistrationMode});

  final ValueNotifier<bool> isRegistrationMode;

  @override
  State<QRCodeReader> createState() => _QRCodeReaderState();
}

class _QRCodeReaderState extends State<QRCodeReader> {
  late MobileScannerController _controller;
  bool _hasDetected = false;
  TextEditingController _passwordController = TextEditingController();
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

  void _onDetect(BarcodeCapture capture) async {
    if (!_hasDetected) {
      final barcode = capture.barcodes.first;

      setState(() {
        _hasDetected = true;
      });

      await NameSheet.init(); // Initialize Google Sheets connection
      _controller.stop(); // Stop scanning

      // Extract id and name from the scanned value
      String rawValue = barcode.rawValue ?? "";
      List<String> parts = rawValue.split('-');

      if (parts.length == 2) {
        String idStr = parts[0];
        int id = int.tryParse(idStr) ?? 0;
        // String name = parts[1]; // Not used in current logic

        if (!widget.isRegistrationMode.value) {
          // Prompt for password
          bool passwordCorrect = await _promptPassword();

          if (!passwordCorrect) {
            _showErrorDialog("Incorrect password");
            // Password incorrect, reset detection
            _resetDetection();
            return;
          }
        }
        // Check mode and update the Google Sheet
        if (widget.isRegistrationMode.value) {
          // Update "attended" column to "TRUE"
          await NameSheet.userSheet!.values.insertValue(
            'TRUE', // Value to insert
            column: 4, // Column to update
            row: id, // Row key (id)
          );
        } else {
          // Fetch current points
          var currentPointsStr = await NameSheet.userSheet!.values.value(
            column: 2,
            row: id,
          );

          // Convert current points to integer and increment
          var currentPoints = int.tryParse(currentPointsStr ?? '0') ?? 0;
          var newPoints = currentPoints + 1;

          // Update "no of points" column
          await NameSheet.userSheet!.values.insertValue(
            newPoints.toString(), // New value for points
            column: 2, // Column to update
            row: id, // Row key (id)
          );
        }
      }
      // Handle invalid QR code format
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

  Future<bool> _promptPassword() async {
    String enteredPassword = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Enter Password"),
        content: TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(hintText: "Password"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, "");
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, _passwordController.text);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );

    // Trim entered password to remove leading/trailing white spaces
    enteredPassword = enteredPassword.trim();

    // Debugging output to verify entered password
    print('Entered password: $enteredPassword');

    // Check if the entered password matches your criteria
    // For simplicity, let's assume the correct password is "123456"
    bool isPasswordCorrect = enteredPassword == '102022';

    if (!isPasswordCorrect) {
      _showErrorDialog("Incorrect password");
      // Password incorrect, reset detection
      _resetDetection();
    }

    return isPasswordCorrect;
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetDetection();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetDetection();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
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
