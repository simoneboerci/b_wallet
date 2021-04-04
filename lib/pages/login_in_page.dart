import 'package:b_wallet/models/b_card.dart';
import 'package:b_wallet/models/b_user.dart';
import 'package:b_wallet/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatelessWidget{

  final FirebaseFirestore firebaseFirestore;

  LoginPage(this.firebaseFirestore);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            signInWithGoogle();
            FirebaseAuth.instance.authStateChanges().listen((User user) {
              if(user != null) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage(firebaseFirestore)));
              }
            });
          },
          child: Text("Login With Google"),
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async{
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    final BUser bUser = BUser(BCard("Main Card", 0), []);

    await firebaseFirestore.collection("users").doc(userCredential.user.uid).set(bUser.toJson());

    return userCredential;
  }
}