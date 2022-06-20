import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_email_id/HomePage.dart';
import 'SignUpPage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  final auth =FirebaseAuth.instance;
    bool _passwordVisible = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _emailValue = false;
  bool _passwordValue = false;

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? user = _googleSignIn.currentUser;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Image.asset('images/Sign.png',height:200,width: double.infinity,),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Login',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w800 ,fontFamily: 'Poppins',)),
                    ),
                    //Icon(Icons.alternate_email),
                    Padding(
                      padding: EdgeInsets.only(left: 5,right: 15),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.alternate_email),
                          labelText: 'Email ID',
                          hintText: 'email',
                          labelStyle: TextStyle(fontFamily: 'Poppins'),
                          errorText: _emailValue ? 'Email-id required' : null,
                        ),
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: 5,right: 15),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              !_passwordVisible ? FluentIcons.eye_off_16_regular: FluentIcons.eye_16_regular
                            ),
                            onPressed: (){
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          labelText: 'Password',

                            hintText: 'password',
                          errorText: _passwordValue ? 'Password Required' : null,
                            labelStyle: TextStyle(fontFamily: 'Poppins'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RawMaterialButton(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Text('Forgot password?',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue,fontFamily: 'Poppins'),),
                          ),
                          onPressed: (){},
                        )
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: RaisedButton(
                          padding: EdgeInsets.all(10),
                          elevation: (0.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),
                          ),
                          color: Colors.blue,

                          onPressed: ()  {

                            setState(() async {

                                _emailController.text.isEmpty ? _emailValue = true : _emailValue = false;

                                _passwordController.text.isEmpty ? _passwordValue = true : _passwordValue = false;

                                if(_emailController.text != null && _passwordController.text != null){

                                  print("text ${_emailController.text} ${_passwordController.text}");


                                  try{

                                   await auth.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text).then((_){

                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage()));

                                  });

                                  }
                                  on FirebaseAuthException catch(error){

                                    String errorMsg = "";

                                    print("login error ${error.code} message :  ${error.message}");
                                    switch (error.code) {
                                      case "ERROR_EMAIL_ALREADY_IN_USE":
                                      case "account-exists-with-different-credential":
                                      case "email-already-in-use":
                                        errorMsg = "Email already used. Go to login page.";
                                        break;
                                      case "ERROR_WRONG_PASSWORD":
                                      case "wrong-password":
                                      errorMsg = "Wrong email/password combination.";
                                        break;
                                      case "ERROR_USER_NOT_FOUND":
                                      case "user-not-found":
                                      errorMsg = "No user found with this email.";
                                        break;
                                      case "ERROR_USER_DISABLED":
                                      case "user-disabled":
                                      errorMsg = "User disabled.";
                                        break;
                                      case "ERROR_TOO_MANY_REQUESTS":
                                      case "operation-not-allowed":
                                      errorMsg = "Too many requests to log into this account.";
                                        break;
                                      case "ERROR_OPERATION_NOT_ALLOWED":
                                      case "operation-not-allowed":
                                      errorMsg = "Server error, please try again later.";
                                        break;
                                      case "ERROR_INVALID_EMAIL":
                                      case "invalid-email":
                                      errorMsg = "Email address is invalid.";
                                        break;
                                      default:
                                        errorMsg = "Login failed. Please try again.";
                                        break;
                                    }

                                    Fluttertoast.showToast( msg: errorMsg,
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  }
                                }

                                else{

                                    Fluttertoast.showToast( msg: "Please enter Email & Password",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );


                                    }


                            });

                          },
                          child:
                            Text('Login',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Poppins',fontSize: 16))),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          height: 0.5,
                          width: 150,
                          padding: EdgeInsets.all(10),
                          color: Colors.grey,
                        ),
                        Text('OR',style: TextStyle(color: Colors.grey.shade500,fontWeight: FontWeight.bold,fontFamily: 'Poppins'),),
                        Container(
                          height: 0.5,
                          width: 150,
                          padding: EdgeInsets.all(10),
                          color: Colors.grey,
                        )

                      ],
                    ),

                    Padding(

                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                      child: RaisedButton(
                        padding: EdgeInsets.all(10),
                        elevation: (0.0),
                        color: Colors.grey[200],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () async{
                          await _googleSignIn.signIn();
                        },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 40),
                            child: Image.asset('images/google-icon.png',height: 25,width: 25,),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 50),
                            child: Text('Login with Google',style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w500),),
                          ),
                        ],
                      ),),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('New to Logistics?',style: TextStyle(fontFamily: 'Poppins'),),
                        RawMaterialButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpPage()),);
                        },child: Text('Register',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontFamily: 'Poppins'),),),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
