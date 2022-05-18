import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login/models/user.model.dart';
import 'package:login/screens/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        obscureText: true,

        validator: (value){
        RegExp regex = new RegExp(r'^.{6,}$');
        if(value!.isEmpty){
          return ("Password is required for loggin ");
        }
        if(!regex.hasMatch(value)){
          return ("Please Enter Valid Password (Min. 6 Charater)");
        }
      },
        onSaved: (value){
          passwordEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration:InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          )
        )
      );
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: confirmPasswordEditingController,
        obscureText: true,

        validator: (value){
          if(confirmPasswordEditingController.text != passwordEditingController.text){
            return "Password dont match";
          }
          return null;
        },
        onSaved: (value){
          confirmPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration:InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
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
          signUp(emailEditingController.text,passwordEditingController.text);
        },
        child: Text("SignUp", textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold
        ))
      )
    );
      


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.redAccent,),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
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
                    SizedBox(height: 20),
                    passwordField,
                    SizedBox(height: 20),
                    confirmPasswordField,
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



  void signUp(String email, String password) async{
    if(_formKey.currentState!.validate()){
      try{
        await _auth.createUserWithEmailAndPassword(email:email, password:password).then(
        (value) => {
          postDetailsFirestore()
        }
      );
      }on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(msg: "Error create");
      }
      
    }
  }

  postDetailsFirestore() async {
    //calling our firestore
    // calling our user model
    // sending these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    //writinf all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.secondName = secondNameEditingController.text;

    await firebaseFirestore
      .collection("users")
      .doc(user.uid)
      .set(userModel.toMap());

    Fluttertoast.showToast(msg: "Account created successfuly :.");
    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=> HomeScreen()), 
      (route)=> false);
  }
}