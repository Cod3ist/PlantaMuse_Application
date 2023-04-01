import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:plantamuse/ui/QRScanner.dart';
import 'package:plantamuse/auth/login_screen.dart';
import 'package:plantamuse/auth/user_account/device_status.dart';
import 'package:plantamuse/util/utils.dart';


class MainPageScreen extends StatefulWidget {
  final String account;
  const MainPageScreen({Key? key, required this.account}) : super(key: key);

  @override
  State<MainPageScreen> createState() => _MainPageScreenState();
}

class _MainPageScreenState extends State<MainPageScreen> {
  bool loading = false;
  final device_database = FirebaseDatabase(databaseURL: "https://plantamuse-default-rtdb.asia-southeast1.firebasedatabase.app/").ref('Device');
  final users_database = FirebaseDatabase(databaseURL: "https://plantamuse-default-rtdb.asia-southeast1.firebasedatabase.app/").ref('Users');
  Icon icon_type = Icon(Icons.play_arrow_outlined);
  bool isSwitched = false;
  String text = 'CONNECT';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Devices'),
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: Icon(Icons.exit_to_app)
          )
        ],
      ),
      body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StreamBuilder(
                            stream: users_database.child(widget.account.toString()).onValue,
                            builder: (context,AsyncSnapshot<DatabaseEvent> snapshot){
                              try{
                                if (snapshot.hasData){
                                  List<dynamic> list = [];
                                  if (snapshot.data?.snapshot.value.runtimeType.toString() == 'List<Object?>'){
                                    Object? obj = snapshot.data?.snapshot.value;
                                    list = (obj as List?)!;
                                  } else {
                                    Map<dynamic, dynamic> map = snapshot.data?.snapshot.value as dynamic;
                                    list.clear();
                                    list = map.values.toList();
                                  }
                                  return ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: snapshot.data?.snapshot.children.length,
                                      itemBuilder: (context, index) {
                                        return TextButton(
                                            child: Text(list[index].toString(), style: TextStyle(fontSize: 40, color: Colors.teal,fontFamily: 'Dosis')),
                                            onPressed:(){
                                              device_database.child(list[index]).child('State').onValue.listen((event) {
                                                final device_status = event.snapshot.value;
                                                if (device_status == "ON"){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DeviceScreen(device_name: list[index].toString(), account: widget.account.toString(),)));
                                                  device_database.child(list[index].toString()).set({
                                                    'Connection' : "ON",
                                                    'State' : "ON"
                                                  });
                                                } else {
                                                  Utils().toastMessage('DEVICE OFF');
                                                }
                                              });
                                            }
                                        );
                                      }
                                  );
                                } else {
                                  return Center(
                                    child: Column(
                                        children: [
                                          SizedBox(height: 25,),
                                          CircularProgressIndicator(),
                                          SizedBox(height: 10,),
                                          Text('Please wait',style: TextStyle(fontSize: 16,),)
                                        ]
                                    ),
                                  );
                                }
                              } catch (e){
                                return Column(
                                    children:[
                                      SizedBox(height: 15.0,),
                                      Text('Add Device', style: TextStyle(color: Colors.grey, fontSize: 30.0),),
                                    ]
                                );
                              }
                            }
                        )
                      ],
                    )
                )
          )
            ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(Icons.add, size: 40,),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => QRScanner(account: widget.account,)));
        },
      ),
    );
  }
}
