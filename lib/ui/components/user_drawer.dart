import 'package:flutter/material.dart';


import '../../dialog/change_password_dialog.dart';
import '../../utils/helper_functions.dart';
import '../pages/employee_profile_page.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer({super.key, required this.userId});
  final String userId;
  @override
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: DrawerHeader(
                  child: Image.asset('assets/umccc_logo.png',width: 100,)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: const Icon(Icons.person_outline_outlined),
                title: const Text('Profile',style: TextStyle(fontWeight: FontWeight.w500),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeProfilePage(userId: widget.userId)));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password',style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: (){
                  showChangePasswordDialog(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: const Text('Log out',style: TextStyle(fontWeight: FontWeight.w500),),
                onTap: (){
                  showLogoutDialog(context);
                  },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
