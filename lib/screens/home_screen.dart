import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/models/user.model.dart';
import 'package:login/screens/add_user_screen.dart';
import 'package:login/screens/image_screen.dart';
import 'package:login/screens/login_screen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:login/screens/record_screen.dart';
import 'package:login/screens/user_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  List<UserModel> users = [];

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
        print(value.data());
        loogedInUser = UserModel.fromMap(value.data());
        setState(() {});
      });
      FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .collection("contacts")
      .get()
      .then((value) {
        value.docs.forEach((doc) => {users.add(UserModel.fromMap(doc.data()))});
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contactos"),
        centerTitle: true,
        actions: [IconButton(
          icon: const Icon(Icons.output,),
          onPressed: (){
            logout(context);
          },
        ),
        ]
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
            child: const Icon(Icons.add, color: Colors.redAccent),
            label: "Contacto",
            onTap: (){
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context)=> const AddUserScreen()));
            }
          ),
        ],
      ),
      body:
      ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index){
                  return ListTile(
                    onTap: (){
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context)=>  UserScreen(userModel: users[index])));
                    },
                    onLongPress: (){},
                    title: Text(users[index].firstName! + " " + users[index].secondName!),
                    subtitle: Text(users[index].email!),
                    leading: CircleAvatar(
                      child: Text(users[index].firstName!.substring(0,1)),
                    ),
                    trailing: const Icon(
                      Icons.edit,
                      color: Colors.redAccent,
                    ),
                  );
                }
              ) 
    );
  }

  Future<void> logout (BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> LoginScreen()));
  }

}