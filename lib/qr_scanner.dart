import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
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
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

      if (parts.length != 2) {
        // Handle invalid QR code format
        _showErrorDialog("Invalid QR Code");
      }

      if (parts.length == 2) {
        String idStr = parts[0];
        int id = int.tryParse(idStr) ?? 0;
        String name = parts[1];

        showDialog(
          context: context,
          barrierDismissible:
              false, // Prevents closing the dialog by tapping outside
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
        if (id == 0) {
          // Handle invalid ID
          Navigator.pop(context); // Close the loading dialog
          _showErrorDialog("Invalid QR");
        }
        // check values exist
        var rowValues = await NameSheet.userSheet!.values.row(id);

        if (rowValues.isEmpty || rowValues == null || rowValues[0] != name) {
          Navigator.pop(context); // Close the loading dialog
          _showErrorDialog("User not found");
          return;
        }

        // Check mode and update the Google Sheet
        if (widget.isRegistrationMode.value) {
          // Update "attended" column to "TRUE"
          //check if the user is in the sheet

          await NameSheet.userSheet!.values.insertValue(
            'TRUE', // Value to insert
            column: 4, // Column to update
            row: id, // Row key (id)
          );
        } else {
          // prompt for password
          bool isPasswordCorrect = await _promptPassword();

          if (!isPasswordCorrect) {
            Navigator.pop(context); // Close the loading dialog
            _showErrorDialog("Incorrect password");
            return;
          }

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
        Navigator.pop(context); // Close the loading dialog

        showDialog(
          context: context,
          barrierDismissible:
              false, // Prevents closing the dialog by tapping outside
          builder: (context) => AlertDialog(
            title: Text(widget.isRegistrationMode.value
                ? "أهلاً وسهلاً"
                : "زيادة نقاط"),
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
  }

  void _resetDetection() {
    setState(() {
      _hasDetected = false;
    });
    _controller.start();
  }

  Future<bool> _promptPassword() async {
    bool isPasswordCorrect = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Enter Password"),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(hintText: "Password"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              } else if (value != '102022') {
                // Replace with your password validation logic
                return 'Incorrect password';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
              // Return false if canceled
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                isPasswordCorrect = true;
                Navigator.pop(
                    context, true); // Return true if password is correct
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );

    return isPasswordCorrect;
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Success"),
        content: Text(message),
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

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(errorMessage),
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
