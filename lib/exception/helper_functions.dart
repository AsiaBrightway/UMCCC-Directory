
import 'package:flutter/material.dart';

import '../ui/pages/login_page.dart';

void showUnauthorizedDialog(BuildContext context,String errorMessage){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        icon: const Icon(Icons.error_outline_sharp,color: Colors.redAccent,),
        content: Text(errorMessage,style: const TextStyle(fontSize: 18),),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage(),));
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

void showConnectionErrorDialog(BuildContext context,String errorMessage){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        icon: Image.asset('lib/icons/no_wifi.png',width: 30,height: 30,),
        content: Text(errorMessage,style: const TextStyle(fontSize: 16),),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

void showSuccessDialog(BuildContext context,String successMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        icon: Image.asset('lib/icons/accept.png',width: 20,height: 20),
        content: Padding(padding: const EdgeInsets.symmetric(vertical: 10),child: Text(successMessage)),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

void showErrorDialog(BuildContext context,String errorMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        icon: const Icon(Icons.error_outline_sharp,color: Colors.redAccent,),
        content: Text(errorMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}