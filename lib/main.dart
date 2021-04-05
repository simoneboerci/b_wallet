import 'package:b_wallet/pages/login_in_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ota_update/ota_update.dart';
import 'package:firebase_storage/firebase_storage.dart';
import './pages/home_page.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(BWallet());
}

class BWallet extends StatefulWidget {

  final String appVersion = "0.0.1";
  final bool releaseVersion = false;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  _BWalletState createState() => _BWalletState();
}

class _BWalletState extends State<BWallet> {
 OtaEvent currentEvent;

 @override
  void initState() {
    super.initState();
    checkForUpdates();
  }

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
       title: 'BWallet',
       theme: ThemeData(
         primarySwatch: Colors.blue,
       ),
       home: widget.auth.currentUser == null ? LoginPage(widget.firebaseFirestore) : HomePage(widget.firebaseFirestore)
   );
  }

  Future<void> checkForUpdates() async{
   if(await needToUpdate())
     await tryOtaUpdate();
  }

  Future<void> tryOtaUpdate() async{

   String apkUrl = await FirebaseStorage.instance.ref().child("BWallet.apk").getDownloadURL();

    try{
      OtaUpdate().execute(
        apkUrl,
        destinationFilename: "BWallet.apk",
      ).listen((event) {
        setState(() => currentEvent = event);
      });
    }catch(e){

    }
  }

  Future<bool> needToUpdate() async{
   String latestVersion;

   DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("app").doc("versions").get();

   if(widget.releaseVersion)
     latestVersion = snapshot.data()["release"];
   else
     latestVersion = snapshot.data()["debug"];

   if(int.parse(widget.appVersion.split(".")[0]) < int.parse(latestVersion.split(".")[0]))
     return true;
   else{
     if(int.parse(widget.appVersion.split(".")[1]) < int.parse(latestVersion.split(".")[1]))
       return true;
     else{
       if(int.parse(widget.appVersion.split(".")[2]) < int.parse(latestVersion.split(".")[2]))
         return true;
     }
   }

   return false;
  }
}
