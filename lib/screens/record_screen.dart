import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
class RecordScreen extends StatelessWidget {
  const RecordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enviar un reporte de audio"),
        centerTitle: true,
      ),
      body: Center(
        child: Text("Record voice"),
      ),
      floatingActionButton:SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.redAccent,
        overlayColor: Colors.grey,
        overlayOpacity: 0.5,
        spacing: 15,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.mic, color: Colors.redAccent,),
            label: "Audio",
            onTap: (){
            }
          ),
        ]
      )   
    );
  }
}