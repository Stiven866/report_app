import 'package:flutter/material.dart';
import 'package:login/screens/home_screen.dart';
import 'package:login/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  //firebase
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
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
        emailController.text = value!;
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
      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
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
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration:InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        )
      )
    );
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20,15, 20,15),
        minWidth: MediaQuery.of(context).size.width,

        onPressed: (){
          signIn(emailController.text, passwordController.text);
        },
        child: Text("Login", textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold
        ))
      )
    );


  

    return Scaffold(
      backgroundColor: Colors.white,
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
                      height: 200,
                      child: Image.asset(
                        "assets/logo.png",  
                        fit: BoxFit.contain
                      ), 
                    ),
                    SizedBox(height: 45),
                    emailField,
                    SizedBox(height: 25),
                    passwordField, 
                    SizedBox(height: 35),
                    loginButton,
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:<Widget> [
                        Text("Don't have an account? "),
                        GestureDetector(
                          onTap:(){
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context)=>RegisterScreen()));
                          },
                          child: Text(
                            "SignUp", 
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w600,
                              fontSize: 15
                            )
                            ),
                        )
                      ],
                    )
                    ],

                ),
              ),
            ),
          ),
        ),
      )
    );
  }

//loggin function

void signIn(String email, String password) async{
  if(_formKey.currentState!.validate()){
    try {
          await _auth.signInWithEmailAndPassword(email:email, password:password).then((uid) => {
          Fluttertoast.showToast(msg: "Login Successful"),
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen()))
        });
      }
      on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(msg: "The user does not exist");
      }
    };
  }

}