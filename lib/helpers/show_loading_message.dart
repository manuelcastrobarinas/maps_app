import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showLoadingMessage( BuildContext context ) {

  //Android

  if (Platform.isAndroid) {    
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: ( context ) => AlertDialog(
        title: const Text('Espere porfavor'),
        content: Container(
          height: 100,
          width: 100,
          margin: const EdgeInsets.only(top: 20),
          child : const Text('Calculando ruta')
        ),
      )
    );
    return;
  }

  showCupertinoDialog(
    context: context, 
    builder: ( context ) => const CupertinoAlertDialog(
      title: Text('Espere porfavor'),
      content: CupertinoActivityIndicator(),

    )
  );
}