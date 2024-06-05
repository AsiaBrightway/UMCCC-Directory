import 'package:flutter/material.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: DrawerHeader(
                  child: Image.asset('assets/pahg_logo.png',width: 100,)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: const Icon(Icons.person_outline_outlined),
                title: const Text('Profile',style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: (){
                  //TODO
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password',style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: (){
                  //TODO
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: const Text('Log out',style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: (){
                  //TODO
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
