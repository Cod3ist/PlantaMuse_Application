import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:plantamuse/auth/user_account/MainPage.dart';
import 'package:plantamuse/ui/QRScanner.dart';
import 'package:plantamuse/auth/signup_screen.dart';
import 'package:plantamuse/widgets/round_button.dart';
import '../util/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool loading = false;
  final auth = FirebaseAuth.instance;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login(){
    setState(() {
      loading = true;
    });
    auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text.toString()).then((value){
      Utils().toastMessage(value.user!.email.toString());

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MainPageScreen(account: value.user!.uid.toString())));
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace){
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
    });

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center( child: Text('Login')),
          backgroundColor: Colors.green,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
            padding:EdgeInsets.symmetric(horizontal: 20),
            child:Column(
                children: [
                  SizedBox(height: 50),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: 'Enter E-mail'
                    ),
                  ),
                  SizedBox(height: 50),
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                        hintText: 'Enter Password'
                    ),
                  ),
                  SizedBox(height: 30),
                  RoundButton(title: 'Login',
                      loading: loading,
                      onTap: (){
                          setState(() {
                            loading = true;
                          });
                          login();
                      }),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Dont have an account"),
                      TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                        },
                        child: Text('SignUP',style: TextStyle(color: Colors.green),),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  InkWell(
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                              color: Colors.grey
                          )
                      ),
                      child: Center(child:Text('ANONYMOUS', style: TextStyle(color: Colors.grey),)),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => QRScanner(account: 'Anonymous')));
                    },
                  )

                ]
            )
        )
    );
  }
}
