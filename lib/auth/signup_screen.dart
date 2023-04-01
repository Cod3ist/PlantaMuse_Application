import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:plantamuse/auth/user_account/MainPage.dart';
import 'package:plantamuse/auth/login_screen.dart';

import '../util/utils.dart';
import '../widgets/round_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  final users_database = FirebaseDatabase(databaseURL: "https://plantamuse-default-rtdb.asia-southeast1.firebasedatabase.app/").ref('Users').ref;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  void signUp(){
    setState(() {
      loading = true;
    });
    _auth.createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString()).then((value){
      users_database.update({
        value.user!.uid.toString() : 'null'
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => MainPageScreen(account: value.user!.uid.toString())));
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Sign up')),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 50,),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'E-Mail',
                      helperText: 'enter you emain as***@gmail.com',
                      prefixIcon: Icon(Icons.alternate_email),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Enter Email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height:20),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Enter Password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height:50),
                  RoundButton(
                    title: 'Sign up',
                    loading: loading,
                    onTap: (){
                      if (_formKey.currentState!.validate()){
                        signUp();
                      }
                    },
                  ),
                  SizedBox(height:20),
                  Row(
                    children: [
                      Text("Already have an account?"),
                      TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen( )));
                        },
                        child: Text('Login',style: TextStyle(color: Colors.green),),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
