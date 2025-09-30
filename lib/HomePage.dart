import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_email_id/LoginPage.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('HomePage',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text('WELCOME',),

          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 500),
          //   child: FlatButton(
          //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          //     color: Colors.blue[800],
          //     child: Text('Signout',style: TextStyle(color: Colors.white,fontFamily: 'poppins',fontWeight: FontWeight.w900),),onPressed: (){
          //     auth.signOut();
          //     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginPage()),);
          //   },),
          // ),
        ],
      ),
    );
  }
}
