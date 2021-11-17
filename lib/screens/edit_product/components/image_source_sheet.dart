import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {

  ImageSourceSheet({required this.onImageSelected});

  final Function(File) onImageSelected;

  final _picker = ImagePicker();



  @override
  Widget build(BuildContext context) {

    Future<void> editImage(String path) async{
      final File? croppedFinal = await ImageCropper.cropImage(
          sourcePath: path,
          aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
          androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Editar Imagem',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
          ),
        iosUiSettings: const IOSUiSettings(
          title: 'Editar Imagem',
          cancelButtonTitle: 'Cancelar',
          doneButtonTitle: 'Concluir',

        )
      );
      if(croppedFinal != null) {
        onImageSelected(croppedFinal);
      }
    }

    if(Platform.isAndroid)
    return BottomSheet(
      onClosing: (){},
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
         TextButton(
           onPressed: () async {
           final XFile? file =
           await _picker.pickImage(source: ImageSource.camera);
           editImage(file!.path);

           },
           child: const Text('Câmera'),
         ),
          TextButton(
            onPressed: () async {
              final XFile? file =
              await _picker.pickImage(source: ImageSource.gallery);
              editImage(file!.path);
            },
            child: const Text('Galeria'),
          )
        ],
      ),
    );
    else
      return CupertinoActionSheet(
        title: const Text('Selecionar foto para a receita'),
        message: const Text('Escolha a origem da foto'),
        cancelButton: CupertinoActionSheetAction(
          onPressed: Navigator.of(context).pop,
          child: const Text('Cancelar'),
        ),
        actions: [
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () async {
              final XFile? file =
              await _picker.pickImage(source: ImageSource.camera);
              editImage(file!.path);
            },
            child: const Text('Câmera'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              final XFile? file =
              await _picker.pickImage(source: ImageSource.gallery);
              editImage(file!.path);
            },
            child: const Text('Galeria'),
          ),
        ],
      );
  }
}
