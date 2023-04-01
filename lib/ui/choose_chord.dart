import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
final device_database = FirebaseDatabase(databaseURL: "https://plantamuse-default-rtdb.asia-southeast1.firebasedatabase.app/").ref('Device');
String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
final player = AudioPlayer();
void play_music(String device_name) {
  String path;
  device_database.child(device_name).child('Music').onValue.listen((event) {
    String state = event.snapshot.value as String;
    if (state == 'ON') {
      device_database.child(device_name).child('Readings').child(currentDate).child('value').onValue.listen((event) {
        int data = event.snapshot.value as int;
        data = data % 10;
        print(data);
        if (data == 9) {  path = 'Ahashmajor.mp3'; }
        else if (data == 8) { path = 'Amajor.mp3'; }
        else if (data == 7) { path = 'Bmajor.mp3'; }
        else if (data == 6) { path = 'Chashmajor.mp3'; }
        else if (data == 5) { path = 'Cmajor.mp3';  }
        else if (data == 4) { path = 'Dhashmajor.mp3'; }
        else if (data == 3) { path = 'Dmajor.mp3'; }
        else if (data == 2) { path = 'Emajor.mp3'; }
        else if (data == 1) { path = 'Fhashmajor.mp3'; }
        else {  path = 'Gmajor.mp3';  }
        device_database.child(device_name).child('Music').onValue.listen((event) {
          String state = event.snapshot.value as String;
          if (state == 'ON') {
            player.play(AssetSource(path));
          } else {
            player.stop();
          }
        });
      }); }
  }); }

void stop_music(String device_name){
  device_database.child(device_name).child('Music').onValue.listen((event) {
    String state = event.snapshot.value as String;
    if (state == 'OFF') {
      player.stop();
    }
  });
}