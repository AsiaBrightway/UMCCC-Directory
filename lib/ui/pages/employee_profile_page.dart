
import 'package:flutter/material.dart';
import 'package:pahg_group/data/models/pahg_model.dart';
import 'package:pahg_group/data/vos/employee_vo.dart';
import 'package:pahg_group/ui/pages/add_employee_page.dart';
import 'package:pahg_group/ui/pages/education_page.dart';
import 'package:pahg_group/ui/pages/personal_info_page.dart';
import 'package:pahg_group/ui/pages/work_experience_page.dart';
import 'package:pahg_group/ui/themes/colors.dart';
import 'package:provider/provider.dart';
import '../../exception/helper_functions.dart';
import '../providers/auth_provider.dart';

class EmployeeProfilePage extends StatefulWidget {
  final String userId;
  const EmployeeProfilePage({super.key, required this.userId});

  @override
  State<EmployeeProfilePage> createState() => _EmployeeProfilePageState();
}

class _EmployeeProfilePageState extends State<EmployeeProfilePage> {
  int _userRole = 0;
  String _token = "";
  EmployeeVo? employee;
  final PahgModel _model = PahgModel();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _initializeData());
  }

  Future<void> _initializeData() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    _token = authModel.token;
    _userRole = authModel.role;
    _model.getEmployeeById(_token,widget.userId).then((response){
      setState(() {
        employee = response;
      });
    }).catchError((error){
      showErrorRefreshDialog(context, error.toString(), _initializeData);
    });
  }

  Future<void> _refresh() async {
    _model.getEmployeeById(_token,widget.userId).then((response){
      setState(() {
        employee = response;
        showSuccessScaffold(context, "complete");
      });
    }).catchError((error){
      showErrorRefreshDialog(context, error.toString(), _initializeData);
    });
  }

  Future<void> _navigateToEditPage(String employeeId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEmployeePage(isAdd: false,userId: employeeId)),
    );

    if (result == true) {
      // Data has been updated, refresh the data
      _refresh();
    }
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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
      body: RefreshIndicator(
        onRefresh: _refresh,
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
                        profileCard(),
                        (_userRole == 1)
                            ? Positioned(
                            bottom: 6,
                            right: 6,
                            child: FloatingActionButton(
                              onPressed: () {
                                _navigateToEditPage(employee!.id ?? "null");
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
                            navigateToPersonal(context);
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
                        ///Education
                        GestureDetector(
                          onTap: (){
                            navigateToEducation(context);
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
                            navigateToWorkExperience(context);
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
                        Container(
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
                      ],
                    ),
                  ),
                  disciplineCard()
                ],
              )
          ),
        ),
      )
    );
  }

  Widget disciplineCard(){
    double screenWidth = MediaQuery.of(context).size.width;
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    double paddingWidth = isPortrait ? 24 : screenWidth * 0.07;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingWidth,vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ///Discipline
          Container(
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
        ],
      ),
    );
  }

  Widget profileCard(){
    double screenWidth = MediaQuery.of(context).size.width;
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    double imageWidth = isPortrait ? screenWidth * 0.3 : screenWidth * 0.2;
    double imageHeight = 140;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 8),
            child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              employee?.getImageWithBaseUrl() ?? "",
              width: imageWidth,
              height: imageHeight,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return Image.asset('assets/placeholder_image.png',width: 130,height: 160,); // Show error image
              },
            ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(employee?.employeeName! ?? "loading..",style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 18,
                  color: Colors.white
                ),),
                const SizedBox(height: 6),
                ///department text
                Row(
                  children: [
                    Image.asset('lib/icons/apartment_department.png',width: 20,color: Colors.white,),
                    const SizedBox(width: 4),
                    Text(employee?.departmentName! ?? "loading..",style: const TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w300),)
                  ],
                ),
                const SizedBox(height: 6),
                ///job position
                Row(
                  children: [
                    Image.asset('lib/icons/add_chair.png',width: 20,color: Colors.white,),
                    const SizedBox(width: 4),
                    Text(employee?.position! ?? "loading..",style: const TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w300),)
                  ],
                ),
                const SizedBox(height: 6),
                ///employee number
                Row(
                  children: [
                    Image.asset('lib/icons/employee_no.png',width: 20,color: Colors.white,),
                    const SizedBox(width: 4),
                    Text(employee?.employeeNumber ?? 'loading..',style: const TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w300),)
                  ],
                ),
                const SizedBox(height: 6),
                ///jd code text
                Row(
                  children: [
                    Image.asset('lib/icons/employee_jd.png',width: 20,color: Colors.white,),
                    const SizedBox(width: 4),
                    Text(employee?.jdCode ?? 'loading..',style: const TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w300),)
                  ],
                ),
              ],
            ),
          )
      ],
    );
  }

  void navigateToPersonal(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => PersonalInfoPage(
            name: employee!.employeeName ?? 'name null',
            role: _userRole,
            userId: employee!.id!
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

  void navigateToEducation(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => EducationPage(
          empId: employee!.id ?? 'null',
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

  void navigateToWorkExperience(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => WorkExperiencePage(
          empId: employee!.id ?? 'null',
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
}
