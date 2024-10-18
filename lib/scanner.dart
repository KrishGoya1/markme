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
      appBar: AppBar(title: Text('NFC Scanner')),
      body: Center(
        child: ElevatedButton(
          child: Text('Scan NFC'),
          onPressed: _scanNFC,
        ),
      ),
    );
  }

  void _scanNFC() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      print('NFC is not available on this device');
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
