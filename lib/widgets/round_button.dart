import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {

  final VoidCallback onTap;
  final String title;
  final bool loading;

  const RoundButton({Key? key, required this.title, required this.onTap, this.loading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.brown,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Center(
          child: loading ? CircularProgressIndicator() : Text(title, style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
