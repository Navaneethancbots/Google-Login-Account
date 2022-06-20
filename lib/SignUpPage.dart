import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'LoginPage.dart';
import 'HomePage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final auth =FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool emailId = false;
  bool passwordId = false;

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.black,), onPressed: () { Navigator.pop(context); },
        ),
      ),
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text('Create Account',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20,fontFamily: 'Poppins'),),
      // ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Image.asset('images/signup.png',height: 200,width: double.infinity,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Sign up',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500 ,fontFamily: 'Poppins')),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5,right: 15),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.alternate_email),
                        labelText: 'Email ID',
                        errorText: emailId ? 'Error' : null,
                          labelStyle: TextStyle(fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5,right: 15),
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock_outlined),
                        labelText: 'Password',
                          errorText: passwordId ? 'Error' : null,
                          labelStyle: TextStyle(fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                  SizedBox(height: 25,),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text('By signing up,you\'re agree to our '),
                      ),
                      Text('Terms & Conditions',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                    ],
                  ),
                   SizedBox(height: 5,),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text('and '),
                      ),
                       SizedBox(width: 5,),
                      Text('Privacy Policy',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                      child: RaisedButton(
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.blue,
                        onPressed: (){

                          setState(()async {
                            _emailController.text.isEmpty ? emailId = true : emailId = false;
                            _passwordController.text.isEmpty ? passwordId = true : passwordId = false;

                            if(_emailController.text != null && _passwordController.text != null){

                              print("text ${_emailController.text} ${_passwordController.text}");


                              try{
                              await  auth.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text).then((value) {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage()),);
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
                        },child:Text('Continue',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Poppins'),),),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Joined us before?',style: TextStyle(fontFamily: 'Poppins'),),
                      RawMaterialButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()),);
                      },child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text('Login',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontFamily: 'Poppins'),),
                      ),),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

