import 'package:flutter/material.dart';
import 'package:pahg_group/ui/pages/add_category_page.dart';
import 'package:pahg_group/ui/pages/add_facility_page.dart';

import '../../dialog/change_password_dialog.dart';
import '../../utils/helper_functions.dart';
import '../pages/add_company_page.dart';
import '../pages/add_department_page.dart';
import '../pages/add_employee_page.dart';
import '../pages/add_position_page.dart';
import '../pages/employee_profile_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key, required this.userId});
  final String userId;
  @override
  Widget build(BuildContext context) {

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.onError,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: DrawerHeader(
              child: Image.asset('assets/logo.png',width: 100,)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: Image.asset('lib/icons/profile.png',width: 25,color: Theme.of(context).colorScheme.onSurface,),
                title: const Text('My Profile',style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.w400),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeProfilePage(userId: userId),));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: Image.asset('lib/icons/add_person.png',width: 25,color: Theme.of(context).colorScheme.onSurface),
                title: const Text('Add Employee',style: TextStyle(fontWeight: FontWeight.w400)),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEmployeePage(isAdd: true, userId: '',)));
                },
              ),
            ),
            const Padding(padding:  EdgeInsets.symmetric(horizontal: 8.0), child: Divider()),
            const Padding(padding: EdgeInsets.only(left: 12), child: Text('Company',style: TextStyle(fontSize: 12,color: Colors.grey,fontFamily: 'Ubuntu'))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: Image.asset('lib/icons/edit_company.png',width: 25,color: Theme.of(context).colorScheme.onSurface,),
                title: const Text('Add Company',style: TextStyle(fontWeight: FontWeight.w400),),
                onTap: () async{
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCompanyPage(isAdd: true)));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: Image.asset('lib/icons/add_company.png',width: 25,color: Colors.deepOrange,),
                title: const Text('Edit Company',style: TextStyle(fontWeight: FontWeight.w400),),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCompanyPage(isAdd: false),));
                },
              ),
            ),
            const Padding(padding:  EdgeInsets.symmetric(horizontal: 8.0), child: Divider(),
            ),
            const Padding(padding: EdgeInsets.only(left: 12), child: Text('Department',style: TextStyle(fontSize: 12,color: Colors.grey,fontFamily: 'Ubuntu'),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: Image.asset('lib/icons/add_dept.png',width: 25,color: Theme.of(context).colorScheme.onSurface,),
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
            const Padding(padding: EdgeInsets.only(left: 12), child: Text('Position',style: TextStyle(fontSize: 12,color: Colors.grey,fontFamily: 'Ubuntu'))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: Image.asset('lib/icons/add_chair.png',width: 25,color: Theme.of(context).colorScheme.onSurface,),
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
                leading:  Image.asset('lib/icons/categories.png',width: 25,color: Theme.of(context).colorScheme.onSurface),
                title: const Text('Add Category',style: TextStyle(fontWeight: FontWeight.w400),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCategoryPage(isAdd: true,),));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading:  Image.asset('lib/icons/categories.png',width: 25,color: Colors.orange,),
                title: const Text('Edit Category',style: TextStyle(fontWeight: FontWeight.w400)),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCategoryPage(isAdd: false,),));
                },
              ),
            ),
            ///Facility
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading:  Image.asset('lib/icons/facility_icon.png',width: 25,color: Theme.of(context).colorScheme.onSurface),
                title: const Text('Add Facility',style: TextStyle(fontWeight: FontWeight.w400)),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFacilityPage(isAdd: true,)));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading:  Image.asset('lib/icons/facility_icon.png',width: 25,color: Colors.orange),
                title: const Text('Edit Facility',style: TextStyle(fontWeight: FontWeight.w400)),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFacilityPage(isAdd: false,),));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password',style: TextStyle(fontWeight: FontWeight.w400),),
                onTap: (){
                  showChangePasswordDialog(context);
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
