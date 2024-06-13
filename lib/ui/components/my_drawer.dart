import 'package:flutter/material.dart';
import 'package:pahg_group/ui/pages/add_company_page.dart';
import 'package:pahg_group/ui/pages/add_department_page.dart';
import 'package:pahg_group/ui/pages/add_employee_page.dart';
import 'package:pahg_group/ui/pages/add_position_page.dart';

import '../../exception/helper_functions.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});



  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.blueGrey.shade700,
              child: Center(
                child: DrawerHeader(
                child: Image.asset('assets/pahg_logo.png',width: 100,)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: Image.asset('lib/icons/profile.png',width: 25),
                title: const Text('My Profile',style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.w400),),
                onTap: (){
                  //TODO
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: Image.asset('lib/icons/add_employee.png',width: 25,color: Colors.black,),
                title: const Text('Add Employee',style: TextStyle(fontWeight: FontWeight.w400),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEmployeePage(isAdd: true, userId: '',),));
                },
              ),
            ),
            const Padding(padding:  EdgeInsets.symmetric(horizontal: 8.0), child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: Image.asset('lib/icons/edit_company.png',width: 25),
                title: const Text('Add Company',style: TextStyle(fontWeight: FontWeight.w400),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCompanyPage(isAdd: true)));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: Image.asset('lib/icons/add_company.png',width: 25,color: Colors.deepOrange,),
                title: const Text('Edit Company',style: TextStyle(fontWeight: FontWeight.w400),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCompanyPage(isAdd: false),));
                },
              ),
            ),
            const Padding(padding:  EdgeInsets.symmetric(horizontal: 8.0), child: Divider(),
            ),
            const Padding(padding: EdgeInsets.only(left: 12), child: Text('Department',style: TextStyle(fontSize: 16,color: Colors.grey),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: Image.asset('lib/icons/add_dept.png',width: 25),
                title: const Text('Add Department',style: TextStyle(fontWeight: FontWeight.w400),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddDepartmentPage(isAdd: true)));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: Image.asset('lib/icons/edit_dept.png',width: 25,color: Colors.deepOrange,),
                title: const Text('Edit Department',style: TextStyle(fontWeight: FontWeight.w400),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddDepartmentPage(isAdd: false)));
                },
              ),
            ),
            const Padding(padding:  EdgeInsets.symmetric(horizontal: 8.0), child: Divider(),),
            const Padding(padding: EdgeInsets.only(left: 12), child: Text('Position',style: TextStyle(fontSize: 16,color: Colors.grey))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: Image.asset('lib/icons/add_chair.png',width: 25),
                title: const Text('Add Position',style: TextStyle(fontWeight: FontWeight.w400),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPositionPage(isAdd: true),));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: Image.asset('lib/icons/edit_chair.png',width: 25,color: Colors.deepOrange,),
                title: const Text('Edit Position',style: TextStyle(fontWeight: FontWeight.w400),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPositionPage(isAdd: false),));
                },
              ),
            ),
            const Padding(padding:  EdgeInsets.symmetric(horizontal: 8.0), child: Divider(),),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password',style: TextStyle(fontWeight: FontWeight.w400),),
                onTap: (){
                  //TODO
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: const Text('Log out',style: TextStyle(fontWeight: FontWeight.w400),),
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
