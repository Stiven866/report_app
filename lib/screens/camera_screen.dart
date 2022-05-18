import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';

class CameraScreen extends StatefulWidget {
  CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}


enum WidgetState {NONE, LOADING, LOADED, ERROR}
class _CameraScreenState extends State<CameraScreen> {
  WidgetState _widgetState = WidgetState.NONE;
  late List<CameraDescription> _cameras;
  late CameraController _cameraController;
  XFile? xFile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeCamera();
  }
  @override
  Widget build(BuildContext context) {
    switch(_widgetState){
      case WidgetState.NONE:
      case WidgetState.LOADING:
        return  _buildScaffold(context, Center(child: CircularProgressIndicator()));
        break;
      case WidgetState.LOADED:
        return _buildScaffold(context, CameraPreview(_cameraController));
      case WidgetState.ERROR:
        return _buildScaffold(context, Center(child: Text("La cámara no se pudo inicializar")));
    }
  }

  Widget _buildScaffold(BuildContext context, Widget body){
    return Scaffold(
      appBar: AppBar(
        title: Text("Cámara"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: 
      Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget> [
              body,
              FloatingActionButton( 
                onPressed: () async {
                  try {
                    xFile = await  _cameraController.takePicture();
                    GallerySaver.saveImage(xFile!.path);
                  } catch (e) {
                            print(e); //show error
                        }             
                    },
                  child: Icon(Icons.camera),
              ),
    
          ],
        )
        )
      )
    );
  }

  initializeCamera() async{
    _widgetState = WidgetState.LOADING;
    if(mounted) setState(() {});

    _cameras = await  availableCameras();
    _cameraController = new CameraController(_cameras[0], ResolutionPreset.max);

    await _cameraController.initialize();
    if(_cameraController.value.hasError){
      _widgetState = WidgetState.ERROR;
      if(mounted) setState(() {});
    }else{
      _widgetState = WidgetState.LOADED;
      if(mounted) setState(() {});
    }
  }
}