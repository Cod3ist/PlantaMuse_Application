import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:plantamuse/auth/user_account/MainPage.dart';
import 'package:plantamuse/ui/QRScanner.dart';
import 'package:plantamuse/ui/choose_chord.dart';
import 'package:plantamuse/util/utils.dart';

class DeviceScreen extends StatefulWidget {
  final String account;
  final String device_name;
  const DeviceScreen({Key? key, required this.device_name, required this.account}) : super(key: key);

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}


class _DeviceScreenState extends State<DeviceScreen> {
  bool isSwitched = true;
  final device_database = FirebaseDatabase(databaseURL: "https://plantamuse-default-rtdb.asia-southeast1.firebasedatabase.app/").ref('Device');
  String music_play = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.device_name),
        backgroundColor: Colors.green,
        actions: [
          Switch(
            value: isSwitched,
              onChanged: (value){
                device_database.child(widget.device_name).child('State').onValue.listen((event){
                  final device_status = event.snapshot.value;
                  if (device_status == "ON"){
                    setState(() {
                      if( isSwitched == false ){
                      isSwitched = true;
                      } else {
                      isSwitched = false;
                      device_database.child(widget.device_name.toString()).set({
                      'Connection' : "ON",
                      'State' : "ON"
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MainPageScreen(account: widget.account.toString())));
                      }
                    });
                  } else {
                    Utils().toastMessage('Connection Off');
                    device_database.child(widget.device_name.toString()).set({
                      'Connection' : "OFF",
                      'State' : "ON"
                    });
                    if (widget.account.toString() == "Anonymous"){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => QRScanner(account: 'Anonymous',)));
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MainPageScreen(account: widget.account.toString())));
                    }
                  }
                });
              }
          )
        ],
      ),

      body: Container(
        child: Column(
          children: [
            SizedBox(height: 200,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 10,),
                ElevatedButton(
                  child: Icon(Icons.play_arrow_outlined, size: 100,),
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(Colors.lightGreen),
                    shape: MaterialStatePropertyAll(
                      CircleBorder(),
                    ),
                  ),
                  onPressed: (){
                    device_database.child(widget.device_name).update({
                      'Music':'ON',
                      'Connection':'ON',
                      'State':'ON'
                    });
                    play_music(widget.device_name);
                  },
                ),
                SizedBox(width: 15,),
                ElevatedButton(
                  child: Icon(Icons.stop_outlined, size: 100,),
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(Colors.lightGreen),
                    shape: MaterialStatePropertyAll(
                      CircleBorder(),
                    ),
                  ),
                  onPressed: (){
                    device_database.child(widget.device_name).update({
                      'Music':'OFF',
                      'Connection':'ON',
                      'State':'ON'
                    });
                    stop_music(widget.device_name);
                  },
                ),
                SizedBox(width: 10,),
              ],
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}
