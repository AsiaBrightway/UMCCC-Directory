
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pahg_group/ui/pages/facility_assign_page.dart';
import 'package:pahg_group/ui/shimmer/employee_profile_shimmer.dart';
import 'package:pahg_group/widgets/error_employee_widget.dart';
import 'package:provider/provider.dart';
import '../../data/vos/employee_vo.dart';
import '../../state/employee_state/employee_notifier.dart';
import '../../state/employee_state/employee_state.dart';
import '../providers/auth_provider.dart';
import '../themes/colors.dart';
import 'add_employee_page.dart';
import 'education_page.dart';
import 'personal_info_page.dart';
import 'work_experience_page.dart';

class EmployeeProfilePage extends ConsumerStatefulWidget {
  final String userId;
  const EmployeeProfilePage({super.key, required this.userId});

  @override
  ConsumerState<EmployeeProfilePage> createState() => _EmployeeProfilePageState();
}

class _EmployeeProfilePageState extends ConsumerState<EmployeeProfilePage> {
  int _userRole = 0;
  String _token = "";
  EmployeeNotifier? employeeNotifier;

  final employeeNotifierProvider =
  NotifierProvider<EmployeeNotifier, EmployeeState>(() {
    return EmployeeNotifier();
  });

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _initializeData());
  }

  Future<void> _initializeData() async{
    final authModel = context.read<AuthProvider>();
    _token = authModel.token;
    _userRole = authModel.role;
    employeeNotifier?.getEmployee(_token, widget.userId);
  }

  Future<void> _navigateToEditPage(String employeeId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEmployeePage(isAdd: false,userId: employeeId)),
    );
    if (result == true) {
      // Data has been updated, refresh the data
      employeeNotifier?.getEmployee(_token, widget.userId);
    }
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    employeeNotifier = ref.read(employeeNotifierProvider.notifier);
    final employeeState = ref.watch(employeeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white),
          onPressed: _onBackPressed,
        ),
        title: const Text('Profile',style: TextStyle(color: Colors.white,fontFamily: 'Ubuntu'),),
        centerTitle: true,
      ),

      ///switch ui state with riverpod
      body: switch(employeeState){

        EmployeeStateLoading() => const EmployeeProfileShimmer(),

        EmployeeStateFailed(error : String error) => Center(
          child: ErrorEmployeeWidget(
            errorEmployee: error,
            tryAgain: () {
              employeeNotifier?.getEmployee(_token, widget.userId);
          },)
        ),

        EmployeeStateSuccess(employee : EmployeeVo employee) => RefreshIndicator(
          onRefresh: () async{
            employeeNotifier?.getEmployee(_token, widget.userId);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.2,1.0],
                              colors: [Color.fromRGBO(7, 119, 118, 1),Color.fromRGBO(42, 74, 97, 1)]
                          ),
                          borderRadius: BorderRadius.circular(12)
                      ),
                      margin: const EdgeInsets.all(12),
                      child: Stack(
                        children: [
                          profileCard(employee),
                          (_userRole == 1)
                              ? Positioned(
                              bottom: 6,
                              right: 6,
                              child: FloatingActionButton(
                                onPressed: () {
                                  _navigateToEditPage(employee.id ?? "null");
                                },
                                mini: true,
                                backgroundColor: Colors.white,
                                child: Image.asset('lib/icons/edit_user.png',width: 30,height: 30,),
                              )
                          )
                              : const SizedBox(width:1)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ///Personal Info
                          GestureDetector(
                            onTap: (){
                              navigateToPersonal(context,employee);
                              },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.42,
                              height: 140,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black,width: 1,),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context).colorScheme.secondaryContainer
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 20,),
                                  Image.asset('lib/icons/personal_info.png',width: 50,height: 50,color: Theme.of(context).colorScheme.onSurface,),
                                  const SizedBox(height: 10,),
                                  const Text('Personal Info',style: TextStyle(fontWeight: FontWeight.w500),),
                                  const Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 8.0, top: 8),
                                          child: Text('more details >>',
                                            style: TextStyle(color: colorAccent, fontSize: 12),
                                          ),
                                        )
                                      ]
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 18,),
                          ///Education
                          GestureDetector(
                            onTap: (){
                              navigateToEducation(context,employee);
                              },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.42,
                              height: 140,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black,width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context).colorScheme.secondaryContainer
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 20,),
                                  Image.asset('lib/icons/user_education.png',width: 50,height: 50,color: Theme.of(context).colorScheme.onSurface),
                                  const SizedBox(height: 10,),
                                  const Text('Education',style: TextStyle(fontWeight: FontWeight.w500),),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [ Padding(
                                      padding: EdgeInsets.only(right: 8.0,top: 8),
                                      child: Text('more details >>',style: TextStyle(color: colorAccent,fontSize: 12),),
                                    )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ///Work Experience
                          GestureDetector(
                            onTap: () {
                              navigateToWorkExperience(context,employee);
                              },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.42,
                              height: 140,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black,width: 1,),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context).colorScheme.secondaryContainer
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 20,),
                                  Image.asset('lib/icons/work_exp.png',width: 50,height: 50,color: Theme.of(context).colorScheme.onSurface,),
                                  const SizedBox(height: 10,),
                                  const Text('Work Experience',style: TextStyle(fontWeight: FontWeight.w500),),
                                  const Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [ Padding(
                                        padding: EdgeInsets.only(right: 8.0,top: 8),
                                        child: Text('more details >>',style: TextStyle(color: colorAccent,fontSize: 12),),
                                      )
                                      ]
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 18,),
                          ///Facility
                          GestureDetector(
                            onTap: (){
                              navigateToFacilityPage(context, employee);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.42,
                              height: 140,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black,width: 1,),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context).colorScheme.secondaryContainer
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 20,),
                                  Image.asset('lib/icons/facility.png',width: 50,height: 50,color: Theme.of(context).colorScheme.onSurface),
                                  const SizedBox(height: 10,),
                                  const Text('Facility',style: TextStyle(fontWeight: FontWeight.w500),),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [ Padding(
                                      padding: EdgeInsets.only(right: 8.0,top: 8),
                                      child: Text('more details >>',style: TextStyle(color: colorAccent,fontSize: 12),),
                                    )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    disciplineCard()
                  ],
                )
            ),
          ),
        ),
      }
    );
  }

  Widget disciplineCard(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ///Discipline
          Card(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.42,
              height: 140,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black,width: 1,),
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.secondaryContainer
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  Image.asset('lib/icons/discipline.png',width: 50,height: 50,color: Theme.of(context).colorScheme.onSurface,),
                  const SizedBox(height: 10,),
                  const Text('Discipline',style: TextStyle(fontWeight: FontWeight.w500),),
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [ Padding(
                        padding: EdgeInsets.only(right: 8.0,top: 8),
                        child: Text('more details >>',style: TextStyle(color: colorAccent,fontSize: 12),),
                      )
                      ]
                  )
                ],
              ),
            ),
          ),
          const SizedBox(width: 18),
          ///this is only use to adjust the container
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.42,
            height: 140,
          ),
        ],
      ),
    );
  }

  Widget profileCard(EmployeeVo employee){
    double screenWidth = MediaQuery.of(context).size.width;
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    double imageWidth = isPortrait ? screenWidth * 0.3 : screenWidth * 0.2;
    double imageHeight = MediaQuery.of(context).size.height * 0.2;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 8),
            child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Hero(
              tag: "image-hero",
              child: CachedNetworkImage(
                imageUrl: employee.getImageWithBaseUrl(),
                width: imageWidth,
                height: imageHeight,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.error)),
                ),
              ),
            )
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(employee.employeeName ?? '',style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Colors.white
                ),),
                const SizedBox(height: 6),
                ///department text
                Row(
                  children: [
                    Image.asset('lib/icons/apartment_department.png',width: 20,color: Colors.white,),
                    const SizedBox(width: 4),
                    Text(employee.departmentName ?? '',style: const TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w300),)
                  ],
                ),
                const SizedBox(height: 6),
                ///job position
                Row(
                  children: [
                    Image.asset('lib/icons/add_chair.png',width: 20,color: Colors.white,),
                    const SizedBox(width: 4),
                    Text(employee.position ?? '',style: const TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w300),)
                  ],
                ),
                const SizedBox(height: 6),
                ///employee number
                Row(
                  children: [
                    Image.asset('lib/icons/employee_no.png',width: 20,color: Colors.white,),
                    const SizedBox(width: 4),
                    Text(employee.employeeNumber ?? '',style: const TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w300),)
                  ],
                ),
                const SizedBox(height: 6),
                ///jd code text
                Row(
                  children: [
                    Image.asset('lib/icons/calendar3.png',width: 20,color: Colors.white,),
                    const SizedBox(width: 4),
                    Text(employee.appointmentDate ?? '',style: const TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w300),)
                  ],
                ),
              ],
            ),
          )
      ],
    );
  }

  void navigateToPersonal(BuildContext context,EmployeeVo employee) {
    Navigator.push(
      context,
        MaterialPageRoute(
          builder: (context) => PersonalInfoPage(
            name: employee.employeeName ?? 'null',
            userId: employee.id ?? '',
            role: _userRole,
          ),
        )
    );
  }

  void navigateToEducation(BuildContext context,EmployeeVo employee) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => EducationPage(
          empId: employee.id ?? 'null',
          userRole: _userRole,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  void navigateToWorkExperience(BuildContext context,EmployeeVo employee) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => WorkExperiencePage(
          empId: employee.id ?? 'null',
          userRole: _userRole,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  void navigateToFacilityPage(BuildContext context,EmployeeVo employee) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => FacilityAssignPage(empId: employee.id ?? '', userRole: _userRole,),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

}
