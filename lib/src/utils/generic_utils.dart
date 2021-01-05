import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

ImagePicker _imagePicker = ImagePicker();

Future<void> tomarFotoDialog(BuildContext context, Size size, Map<String, File> imagenMap)async{
  File imagen;
  
  await showDialog(
    context: context,
    builder: (BuildContext buildContext){
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.width * 0.035)
        ),
        child: Container(
          padding: EdgeInsets.all(0.0),
          height: size.height * 0.15,
          width: size.width * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(size.width * 0.035)
          ),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  height: size.height * 0.075,
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.025),
                  child: Text(
                    'Subir imagen',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.85),
                      fontSize: size.width * 0.047
                    ),
                  ),
                ),
                onTap: ()async{
                  imagen = await _procesarImagen(context, ImageSource.gallery);
                  imagenMap['imagen'] = imagen;
                  Navigator.of(context).pop(imagen);
                },
              ),
              Container(
                color: Colors.black.withOpacity(0.9),
                height: size.height * 0.0005,
              ),
              GestureDetector(
                child: Container(
                  height: size.height * 0.07,
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.017),
                  child: Text(
                    'Tomar foto',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.85),
                      fontSize: size.width * 0.047
                    ),
                  ),
                ),
                onTap: ()async{
                  imagen = await _procesarImagen(context, ImageSource.camera );
                  imagenMap['imagen'] = imagen;
                  Navigator.of(context).pop(imagen);
                },
              )

            ],
          ),
        ),
      );
    }
  );
  /*
  await showDialog(
    context: context,
     builder: (BuildContext buildContext){
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.width * 0.035)
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(size.width * 0.035)
          ),
          
          padding: EdgeInsets.symmetric(vertical:0.0),
          height: size.height * 0.24,
          width: size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.35),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withOpacity(0.9)
                    )
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size.width * 0.035),
                    topRight: Radius.circular(size.width * 0.035)
                  )
                  
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      child: IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.redAccent.withOpacity(0.9),
                        ),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                ),
              ),
              CupertinoButton(
                borderRadius: BorderRadius.all(Radius.circular(0.0)),
                //color: Colors.blueGrey.withOpacity(0.35),
                child: Text(
                  'Subir imagen',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.45),
                    fontSize: size.width * 0.049
                  ),
                ),
                onPressed: ()async{
                  imagen = await _procesarImagen(context, ImageSource.gallery);
                  imagenMap['imagen'] = imagen;
                  Navigator.of(context).pop(imagen);
                }
              ),
              Container(
                color: Colors.black.withOpacity(0.3),
                height: size.height * 0.001,
              ),
              CupertinoButton(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(size.width * 0.035), bottomRight: Radius.circular(size.width * 0.035)),
                //color: Colors.blueGrey.withOpacity(0.35),
                child: Text(
                  'Tomar foto',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.45),
                    fontSize: size.width * 0.049
                  ),
                ),
                onPressed: ()async{
                  imagen = await _procesarImagen(context, ImageSource.camera );
                  imagenMap['imagen'] = imagen;
                  Navigator.of(context).pop(imagen);
                }
              ),
            ],
          ),
        ),
      );
    }
  );
  */
}

void showBottomSheetByScaffoldState(GlobalKey<ScaffoldState> scaffoldKey, Size size, String mensaje){
    PersistentBottomSheetController bottomSheetController;
    bottomSheetController =  scaffoldKey.currentState.showBottomSheet(
      (BuildContext context){
        Future.delayed(
          const Duration(milliseconds: 3000),
          (){
            bottomSheetController.close();
          }
        );
        return Card(
          color: Colors.white.withOpacity(0.98),
          elevation: size.width * 0.01,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            height: size.height * 0.15,
            width: size.width,
            alignment: Alignment.center,
            child: Text(
              mensaje,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.045
              ),
            ),
          ),
        );
      }
    );
  }



Future<File> _procesarImagen(BuildContext context, ImageSource imageSource)async{
  PickedFile pickedFile = await _imagePicker.getImage(
      source: imageSource
    );
    File imagen = File(pickedFile.path);
    return imagen;    
}

