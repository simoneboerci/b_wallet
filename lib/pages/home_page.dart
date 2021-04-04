import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget{

  final FirebaseFirestore firebaseFirestore;

  HomePage(this.firebaseFirestore);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: firebaseFirestore.collection("users").doc(FirebaseAuth.instance.currentUser.uid).get(),
        builder: (context, snapshot){
          if(snapshot.hasError)
            return Text("Error");
          if(snapshot.connectionState == ConnectionState.done){
            Map<String, dynamic> data = snapshot.data.data();
            return Text("${data["main_card"]["amount"]}");
          }
          return Text("Loading...");
        },
      ),
    );
  }
}