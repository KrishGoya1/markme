import 'package:flutter/material.dart';

class NFCDisplayScreen extends StatelessWidget {
  final Map<String, dynamic> scannedData;

  const NFCDisplayScreen({Key? key, required this.scannedData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NFC Scan Result')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: scannedData.entries.map((entry) {
          return Card(
            child: ListTile(
              title: Text(entry.key),
              subtitle: Text(entry.value.toString()),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Helper function to navigate to the display screen
void showNFCResult(BuildContext context, Map<String, dynamic> data) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => NFCDisplayScreen(scannedData: data),
    ),
  );
}
