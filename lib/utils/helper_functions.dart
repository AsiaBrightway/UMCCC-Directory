
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ui/pages/login_page.dart';
import '../ui/providers/auth_provider.dart';

void showUnauthorizedDialog(BuildContext context,String errorMessage){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        icon: const Icon(Icons.cloud_off,color: Colors.redAccent),
        content: Text(errorMessage,textAlign: TextAlign.center,style: const TextStyle(fontSize: 18),),
        actions: <Widget>[
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage(),));
              },
              child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),child: Text('OK')
              ),
            ),
          ),
        ],
      );
    },
  );
}

void showConnectionErrorDialog(BuildContext context,String errorMessage,Function() onRefresh){
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        icon: Image.asset('lib/icons/no_wifi.png', width: 30, height: 30,),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(errorMessage, style: const TextStyle(fontSize: 16),),
            const SizedBox(height: 20),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  onRefresh();
                  Navigator.of(context).pop(); // Close the dialog after refresh
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showErrorRefreshDialog(BuildContext context,String errorMessage,Function() onRefresh){
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        icon: const Icon(Icons.cloud_off,color: Colors.grey,),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(errorMessage, style: const TextStyle(fontSize: 16),),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  onRefresh();
                  Navigator.of(context).pop(); // Close the dialog after refresh
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
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
        icon: const Icon(Icons.cloud_off),
        content: Text(errorMessage,textAlign: TextAlign.center),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('OK'),
              ],
            ),
          ),
        ],
      );
    },
  );
}

void showScaffoldMessage(context,String name){
  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
    backgroundColor: Colors.grey.shade700,
    content: Expanded(child: Text(name,style: const TextStyle(color: Colors.white),)),
    duration: const Duration(milliseconds: 1700),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(horizontal: 50,vertical: 10),
    behavior: SnackBarBehavior.floating,
  ));
}

void showSuccessScaffold(BuildContext context,String name){
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12)
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle,size: 20,color: Colors.white,),
              const SizedBox(width: 12),
              Expanded(child: Text(name,style: const TextStyle(fontSize: 15),))
            ],
          ),
        ),
       duration: const Duration(milliseconds: 1700),
       backgroundColor: Colors.green,
       elevation: 3,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
       margin: const EdgeInsets.only(bottom : 20, left: 40,right: 40),
       behavior: SnackBarBehavior.floating,
     )
    );
}

///subscribe to topic
Future<void> unsubscribeFromTopic() async {
  await FirebaseMessaging.instance.unsubscribeFromTopic('all');
}

void showLogoutDialog(BuildContext context){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        icon: const Text('Logout' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        content: const Text('Are you sure to logout?',style: TextStyle(fontSize: 16),),
        actions: <Widget>[
          TextButton(
            child: const Text("cancel"),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white
            ),
            onPressed: () {
              Navigator.of(context).pop();
              AuthProvider authProvider = Provider.of<AuthProvider>(context,listen: false);
              authProvider.clearTokenAndRoleAndId();
              unsubscribeFromTopic();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}