import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../models/user.model.dart';
import 'dart:convert';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loogedInUser = UserModel();



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
    Reference ref = storage.ref().child("images/${user!.uid}/"+DateTime.now().toString());
    File? compressedImage = await customCompressed(fileImage);
    //
    UploadTask uploadTask = ref.putFile(File(compressedImage!.path));
    await uploadTask;
    

  var dowurl = await ref.getDownloadURL();
  var  url = dowurl.toString();
  _sendEmail(url);
  print(url);




    image = null;
    setState(() {
      loading = false;
     });

  }

  void _sendEmail(String image_url) async{
    //Ib608vBVutD0JIl3c 
    final url=  Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    final response =  await http.post(
      url,
      headers: {
        "origin":"http://localhost",
        'Content-Type':'application/json',
      },
      body:json.encode ({
        'service_id':"service_sebytpd",
        'template_id':"template_583t674",
        "user_id":"Ib608vBVutD0JIl3c",
        "template_params":{
          'user_name':"ricardo",
          'to_email':"ricardo.tangarife@udea.edu.co, fabian.duque@udea.edu.co",
          "reply_to": "fabian.duque@udea.edu.co",
          'user_subject':"Cuchito, que mas pues",
          "user_message": "Oeeeeeeeeeeeeeeeeelo",
          "user_url": image_url
        }
      })
    ).then((res)=>{
      print("${res.statusCode} -------------")
    });
  

  }
}