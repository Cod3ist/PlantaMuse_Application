import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plantamuse/auth/user_account/MainPage.dart';
import 'package:plantamuse/auth/user_account/device_status.dart';
import 'package:plantamuse/ui/choose_chord.dart';
import 'package:plantamuse/util/utils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class QRScanner extends StatefulWidget {
  const QRScanner({super.key, required this.account});
  final String account;

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final users_database = FirebaseDatabase(databaseURL: "https://plantamuse-default-rtdb.asia-southeast1.firebasedatabase.app/").ref('Users').ref;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');


  @override
  void reassemble() {
    super.reassemble();
    controller?.pauseCamera();
  }

  Barcode? result;
  QRViewController? controller;
  void _onQRViewCreated(QRViewController controller){
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        controller.resumeCamera();
        result = scanData;
        if (widget.account == 'Anonymous') {
          device_database.child(result!.code.toString()).child('State').onValue.listen((event) {
            final device_status = event.snapshot.value;

            if (device_status == 'ON') {
              Utils().toastMessage(device_status.toString());
              if (widget.account == 'Anonymous') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DeviceScreen(account: 'Anonymous', device_name: result!.code.toString(),)));
                controller.pauseCamera();
              } else {
                Utils().toastMessage('DEVICE OFF');
              }
            }
          });
        } else {
          users_database.child(widget.account).update({
            Random().nextInt(5).toString() : result!.code.toString()
          });
          Navigator.push(context, MaterialPageRoute(builder: (context) => MainPageScreen(account: widget.account.toString())));
        }
      });
    });
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('SCAN QR'),
      ),
        body: Column(
            children:[
              Expanded(
                flex: 5,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
              Expanded(
                  child: Center(
                    child: (result != null) ? Text("Barcode Type: ${describeEnum(result!.format)} Data: ${result!.code}") : Text("Scan") ,
                  )
              )
            ]
        )
    );
  }
}
