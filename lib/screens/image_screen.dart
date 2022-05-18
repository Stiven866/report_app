import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {

  File? image;

  Future<File?> customCompressed(File file) async{
    final img = AssetImage(file.path);
    const config = ImageConfiguration();

    AssetBundleImageKey key = await img.obtainKey(config);
    final dir = await path_provider.getTemporaryDirectory();
    final  result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      dir.absolute.path + "/temp.jpg",
      quality: 88,
    );

    return result;
  }

  final ImagePicker _imagePicker = ImagePicker();
  Future selectImage(option) async {
    XFile? pickedFile;
    if(option == 1){
      pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
    }else{
      pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      if(pickedFile !=null){
        image = File(pickedFile.path);
      }else{
        Fluttertoast.showToast(msg: "Imagen no selecionada");
      }
    });
    //Navigator.of(context).pop();
  }

  
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return _buidScaffold(context);
  }

  

  Widget _buidScaffold(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Enviar un reporte de video o imagen"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                const SizedBox(height: 30,),
                image == null ? 
                const Center():
                Center(
                  child: Card(
                    shape: RoundedRectangleBorder(  
                      borderRadius: BorderRadius.circular(8.0)
                      ),
                    
                    color: Colors.white,
                    elevation: 10,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AspectRatio(
                              aspectRatio: 18.0/13.0,
                              child: Image.file(image!,  fit: BoxFit.fill)),
                          ),
                            Center(
                              child: ButtonBar(  
                              children: <Widget>[ 
                                loading ? const Center(child: CircularProgressIndicator()):const Center(),
                                TextButton(  
                                  child: Container(child: Column(
                                    children: const [
                                      Icon(Icons.upload),
                                      Text("Enviar")
                                    ],
                                  )),  
                                  onPressed: () {
                                    
                                    setState(() {
                                      loading = true;  
                                    });
                                    _sendImage(image!);
                                  },
                                ), 
                                Column(
                                  children: [
                                    TextButton(
                                      child: Column(
                                        children: const [
                                          Icon(Icons.cancel),
                                          Text("Cancelar")
                                        ],
                                      ),  
                                      onPressed: () {
                                        image = null;
                                        setState(() { });
                                      },  
                                    ),
                                  ],
                                ),   
                              ],
                              ),
                            ),
                        ] 
                    ) 
                  )
                ) 
              ],
            ),
          )
        ],
      ),
      
      floatingActionButton:SpeedDial(
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
              selectImage(1);
            }
          ),
          SpeedDialChild(
            child: const Icon(Icons.image, color: Colors.redAccent,),
            label: "Foto",
            onTap: (){
              selectImage(2);
            }
          ),
        ]
      )   
    );
  }

  
_sendImage(File fileImage) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("images/"+DateTime.now().toString());
    File? compressedImage = await customCompressed(fileImage);
    UploadTask uploadTask = ref.putFile(File(compressedImage!.path));
    await uploadTask;
    image = null;
    setState(() {
      loading = false;
     });
  }
}