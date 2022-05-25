import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/ui/models/user.model.dart';
import 'package:login/ui/screens/add_user_screen.dart';
import 'package:login/ui/screens/home/pages/image_screen.dart';
import 'package:login/ui/screens/login/login_screen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:login/ui/screens/home/pages/record_screen.dart';
import 'package:login/ui/screens/user_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:login/ui/screens/home/pages/contacts_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 1;
  final items = <Widget>[
    const Icon(Icons.camera_alt_outlined, size: 30),
    const Icon(Icons.person, size: 30),
    const Icon(Icons.mic, size: 30),
  ];

  List<UserModel> contacts = [];
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loogedInUser = UserModel();

  @override
  void initState() {
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
    reloadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
          title: const Text("SENSORS APP"),
          backgroundColor: Colors.black,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.output,
              ),
              onPressed: () {
                logout(context);
              },
            ),
          ]),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.redAccent.shade100,
        backgroundColor: Colors.transparent,
        height: 60,
        index: index,
        items: items,
        onTap: (index) => setState(() => this.index = index),
      ),
      body: _getBody(),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  Widget _getBody() {
    Widget body = ContactsPage(
        contacts: contacts, user: user, loogedInUser: loogedInUser);
    switch (index) {
      case 0:
        body = const ImageScreen();
        break;
      case 1:
        body = ContactsPage(
            contacts: contacts, user: user, loogedInUser: loogedInUser);
        break;
      case 2:
        body = const RecordScreen();
        break;
      default:
        body = ContactsPage(
            contacts: contacts, user: user, loogedInUser: loogedInUser);
    }
    return body;
  }

  void reloadContacts() {
    contacts = [];
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("contacts")
        .get()
        .then((value) {
      value.docs
          .forEach((doc) => {contacts.add(UserModel.fromMap(doc.data()))});
      setState(() {});
    });
  }
}
