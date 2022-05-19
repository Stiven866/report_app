import 'package:flutter/material.dart';
import 'package:login/models/user.model.dart';

class UserScreen extends StatelessWidget {
  final UserModel userModel;
  const UserScreen({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Usuario registrado"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${userModel.firstName!.toUpperCase()}  ${userModel.secondName!.toUpperCase()}"),
            Text("${userModel.email}")
          ],
        ),
      )   
    );
  }
}