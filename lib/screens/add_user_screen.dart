import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import '../models/user.model.dart';
import 'home_screen.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({ Key? key }) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();
  @override
  Widget build(BuildContext context) {

final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.name,
      //obscureText: true,

      validator: (value){
        RegExp regex = new RegExp(r'^.{3,}$');
        if(value!.isEmpty){
          return ("First Name cannot be Empty ");
        }
        if(!regex.hasMatch(value)){
          return ("Please Enter Valid name (Min. 3 Charater)");
        }
        return null;
      },
      onSaved: (value){
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration:InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "First Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        )
      )
    );
    final secondNameField = TextFormField(
        autofocus: false,
        controller: secondNameEditingController,
        //obscureText: true,

        validator: (value){
        if(value!.isEmpty){
          return ("Second Name cannot be Empty ");
        }
        return null;
      },
        onSaved: (value){
          secondNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration:InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Second Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          )
        )
      );
    final emailNameField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        //obscureText: true,

        validator: (value){
        if(value!.isEmpty){
          return ("Please enter your email");
        }
        if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
          return ("Please Enter a valid email");
        }
        return null;
      },
        onSaved: (value){
          emailEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration:InputDecoration(
          prefixIcon: Icon(Icons.email),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          )
        )
      ); 
    final registerButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20,15, 20,15),
        minWidth: MediaQuery.of(context).size.width,

        onPressed: (){
          _registerContact();
        },
        child: Text("Registar contacto", textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold
        ))
      )
    );
        
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar Usuario"),
        centerTitle: true,
      ),
      body:  Center(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:<Widget>[
                    SizedBox(
                      height: 180,
                      child: Image.asset(
                        "assets/logo.png",  
                        fit: BoxFit.contain
                      ), 
                    ),
                    SizedBox(height: 45),
                    firstNameField,
                    SizedBox(height: 20),
                    secondNameField,
                    SizedBox(height: 20),
                    emailNameField, 
                    SizedBox(height: 10),
                    registerButton,
                    ],

                ),
              ),
            ),
          ),
        ),
      )
    );
  }

  _registerContact() async{
    var uuid = Uuid();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    //writing all the values
    userModel.email = emailEditingController.text;
    userModel.uid = uuid.v1();
    userModel.firstName = firstNameEditingController.text;
    userModel.secondName = secondNameEditingController.text;

    await firebaseFirestore
      .collection("users")
      .doc(user!.uid)
      .collection("contacts")
      .doc(uuid.v1())
      .set(userModel.toMap());

    Fluttertoast.showToast(msg: "Usuario agredado  :.");
    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=> HomeScreen()), 
      (route)=> false);
  }
}