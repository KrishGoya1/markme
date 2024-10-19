import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'display.dart';

class NFCScanner extends StatefulWidget {
  @override
  _NFCScannerState createState() => _NFCScannerState();
}

class _NFCScannerState extends State<NFCScanner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 30),
            const SizedBox(width: 10),
            const Text('MARKME', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Recent Records',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildRecordCard('CSP', 'COA', '12:55 PM', 36),
                _buildRecordCard('CSE', 'CN', '1:45 PM', 40),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {},
            ),
            const SizedBox(width: 32), // Space for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanNFC,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildRecordCard(String className, String subject, String time, int count) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Class: $className', style: const TextStyle(fontSize: 18)),
                Text('Subject: $subject', style: const TextStyle(fontSize: 18)),
                Text('Time: $time', style: const TextStyle(fontSize: 18)),
                Text('Count: $count', style: const TextStyle(fontSize: 18)),
              ],
            ),
            const Icon(Icons.bookmark, size: 40),
          ],
        ),
      ),
    );
  }

  void _scanNFC() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      debugPrint('NFC is not available on this device');
      return;
    }

    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      Map<String, dynamic> scannedData = {};

      if (tag.data['ndef'] != null) {
        var ndefMessage = tag.data['ndef']['cachedMessage'];
        if (ndefMessage != null) {
          for (var record in ndefMessage['records']) {
            if (record['typeNameFormat'] == NdefTypeNameFormat.media) {
              String mimeType = String.fromCharCodes(record['type']);
              String payload = String.fromCharCodes(record['payload']);
              scannedData['MIME Type'] = mimeType;
              scannedData['Payload'] = payload;
            } else {
              // Handle other record types if needed
              scannedData['Type'] = record['typeNameFormat'].toString();
              scannedData['Payload'] = String.fromCharCodes(record['payload']);
            }
          }
        }
      } else {
        scannedData['Raw Data'] = tag.data.toString();
      }

      NfcManager.instance.stopSession();

      // Ensure we're calling showNFCResult on the main thread
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showNFCResult(context, scannedData);
      });
    });
  }
}
