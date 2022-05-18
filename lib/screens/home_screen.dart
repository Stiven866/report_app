import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/models/user.model.dart';
import 'package:login/screens/camera_screen.dart';
import 'package:login/screens/image_screen.dart';
import 'package:login/screens/login_screen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:login/screens/record_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loogedInUser = UserModel();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .get()
      .then((value) {
        loogedInUser = UserModel.fromMap(value.data());
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
        centerTitle: true,
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.redAccent,
        overlayColor: Colors.grey,
        overlayOpacity: 0.5,
        spacing: 15,

        children: [
          SpeedDialChild(
            child: const Icon(Icons.camera_alt, color: Colors.redAccent,),
            label: "Camara",
            onTap: (){
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context)=> const ImageScreen()));
            }
          ),
          SpeedDialChild(
            child: const Icon(Icons.mic, color: Colors.redAccent,),
            label: "Sonido",
            onTap: (){
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context)=> const RecordScreen()));
            }
          ),
          SpeedDialChild(
            child: const Icon(Icons.output_rounded, color: Colors.redAccent),
            label: "Salir",
            onTap: (){
              logout(context);
            }
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 180,
                child: Image.asset("assets/logo.png", fit:BoxFit.contain),
              ),
              Text(
                "Welcome back", 
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(
                height: 10,),
              Text(
                "${loogedInUser.firstName} ${loogedInUser.secondName}", 
                style: TextStyle(
                  color: Colors.black54, 
                  fontWeight: FontWeight.w500
                ),
              ),
              SizedBox(
                height: 10,),
              Text(
                "${loogedInUser.email}", 
                style: TextStyle(
                  color: Colors.black54, 
                  fontWeight: FontWeight.w500
                ),
              ),
              SizedBox(
                height: 15,),
              ActionChip(
                  label:Text("Logout"),
                  onPressed: () { 
                    logout(context);
                  },
              ),
              // GestureDetector(
              //   child: new Text("Camera: CameraPreview"),
              //   onTap: (){
              //     Navigator.push(
              //       context, 
              //       MaterialPageRoute(builder: (context)=> ImageScreen()));
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout (BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> LoginScreen()));
  }

}