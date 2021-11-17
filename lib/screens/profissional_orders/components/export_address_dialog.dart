import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sim_chefe_2021/models/address.dart';

class ExportAddressDialog extends StatelessWidget {

  ExportAddressDialog(this.address);

  final Address address;

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Endereço de Entrega'),
      content: Screenshot(
        controller: screenshotController,
        child: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.white,
          child: Text(
            '${address.street}, ${address.number} ${address.complement} \n'
                '${address.district}\n'
                '${address.city}/${address.state}\n'
                '${address.zipCode}'
          ),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
      actions: [
        if(Platform.isAndroid)
        ...[ElevatedButton(
          onPressed: () async {
           if(await Permission.storage.request().isGranted) {
             await screenshotController.capture().then((image) async{
               Navigator.of(context).pop();
               print(image);
               await ImageGallerySaver.saveImage(image!);
               print('Exportou');
             });
           }
          },
          style: ElevatedButton.styleFrom(
              onPrimary: Colors.black,
              primary: Colors.transparent,
              shadowColor: Colors.transparent
          ),
          child: const Text('Exportar'),
        ),
        ElevatedButton(
        onPressed: () async {
        MapsLauncher.launchQuery('${address.street}, ${address.number}');
        },
        style: ElevatedButton.styleFrom(
        onPrimary: Colors.black,
        primary: Colors.transparent,
        shadowColor: Colors.transparent
        ),
        child: const Text('Abrir Mapa'),
        ) ]
        else
          ...[
          ElevatedButton(
            onPressed: () async {
                await screenshotController.capture().then((image) async{
                  Navigator.of(context).pop();
                  print(image);
                  await ImageGallerySaver.saveImage(image!);
                  print('Exportou');
                });
              },
            style: ElevatedButton.styleFrom(
                onPrimary: Colors.black,
                primary: Colors.transparent,
                shadowColor: Colors.transparent
            ),
            child: const Text('Exportar'),
          ),
          ElevatedButton(
            onPressed: () async {
              MapsLauncher.launchQuery('${address.street}, ${address.number} - ${address.district}');
            },
            style: ElevatedButton.styleFrom(
                onPrimary: Colors.black,
                primary: Colors.transparent,
                shadowColor: Colors.transparent
            ),
            child: const Text('Abrir Mapa'),
          ),
          ]

      ],
    );
  }
}
