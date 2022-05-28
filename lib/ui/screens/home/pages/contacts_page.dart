import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/ui/models/user.model.dart';
import 'package:login/ui/screens/add_user_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login/ui/screens/user_screen.dart';
import 'package:login/ui/screens/home/home_screen.dart';

class ContactsPage extends StatefulWidget {
  final List<UserModel> contacts;
  final User? user;
  final UserModel loogedInUser;
  const ContactsPage(
      {Key? key, required this.contacts, this.user, required this.loogedInUser})
      : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          "CONTACTOS",
          style: TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.8,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        _getFloat(),
        Flexible(
          child: ListView.builder(
              itemCount: widget.contacts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UserScreen(userModel: widget.contacts[index])));
                  },
                  onLongPress: () {},
                  title: Text(widget.contacts[index].firstName! +
                      " " +
                      widget.contacts[index].secondName!),
                  subtitle: Text(widget.contacts[index].email!),
                  leading: CircleAvatar(
                    backgroundColor: Colors.redAccent.shade100,
                    child: Text(
                        widget.contacts[index].firstName!.substring(0, 1),
                        style: const TextStyle(color: Colors.black)),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            _deleteContact(widget.contacts[index]);
                          },
                          icon: const Icon(Icons.delete),
                          color: Colors.redAccent.shade100),
                      Icon(
                        Icons.edit,
                        color: Colors.redAccent.shade100,
                      ),
                    ],
                  ),
                );
              }),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _getFloat() {
    if (widget.contacts.length < 5) {
      return FloatingActionButton(
          child: const Icon(Icons.add, color: Colors.black),
          backgroundColor: Colors.redAccent.shade100,
          hoverColor: Colors.grey,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddUserScreen()));
          });
    } else {
      return FloatingActionButton(
          child: const Icon(Icons.add, color: Colors.black),
          backgroundColor: Colors.grey.shade400,
          hoverColor: Colors.grey,
          onPressed: () {
            Fluttertoast.showToast(msg: "Máximo de Contactos");
          });
    }
  }

  void _deleteContact(UserModel contact) async {
    var collection = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user!.uid)
        .collection("contacts");
    var snapshot = await collection.where('uid', isEqualTo: contact.uid).get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
    Fluttertoast.showToast(msg: "Contacto eliminado  :.");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false);

    setState(() {});
  }
}
