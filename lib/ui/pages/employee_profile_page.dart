
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pahg_group/ui/pages/discipline_page.dart';
import 'package:pahg_group/ui/pages/facility_assign_page.dart';
import 'package:pahg_group/ui/shimmer/employee_profile_shimmer.dart';
import 'package:pahg_group/widgets/error_employee_widget.dart';
import 'package:provider/provider.dart';
import '../../data/vos/employee_vo.dart';
import '../../bloc/employee_notifier.dart';
import '../../utils/image_compress.dart';
import '../components/business_card.dart';
import '../providers/auth_provider.dart';
import '../themes/colors.dart';
import 'education_page.dart';
import 'personal_info_page.dart';
import 'work_experience_page.dart';

class EmployeeProfilePage extends StatefulWidget {
  final String userId;
  const EmployeeProfilePage({super.key, required this.userId});

  @override
  State<EmployeeProfilePage> createState() => _EmployeeProfilePageState();
}

class _EmployeeProfilePageState extends State<EmployeeProfilePage> {
  int _userRole = 0;
  String _token = "";
  String _currentUserId = "";

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async{
    final authModel = context.read<AuthProvider>();
    _currentUserId = authModel.userId;
    _token = authModel.token;
    _userRole = authModel.role;
  }

  void showEditEmployeeDialog({
    required BuildContext context,
    required String initialChinese,
    required String initialMyanmar,
    required String initialEnglish,
    required void Function(String zh, String mm, String en) onSave,
  }) {
    final TextEditingController zhController = TextEditingController(text: initialChinese);
    final TextEditingController mmController = TextEditingController(text: initialMyanmar);
    final TextEditingController enController = TextEditingController(text: initialEnglish);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Name',style: TextStyle(fontFamily: 'DMSans')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: zhController,
                decoration: const InputDecoration(labelText: 'Chinese Name',labelStyle: TextStyle(fontFamily: 'Ubuntu')),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: mmController,
                decoration: const InputDecoration(labelText: 'Myanmar Name',labelStyle: TextStyle(fontFamily: 'Ubuntu')),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: enController,
                decoration: const InputDecoration(labelText: 'English Name',labelStyle: TextStyle(fontFamily: 'Ubuntu')),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                onSave(
                  zhController.text.trim(),
                  mmController.text.trim(),
                  enController.text.trim(),
                );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Future<void> _navigateToEditPage(String employeeId) async {
  //   final result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => AddEmployeePage(isAdd: false,userId: employeeId)),
  //   );
  //   if (result == true) {
  //     // Data has been updated, refresh the data
  //     // employeeNotifier?.getEmployee(widget.userId);
  //   }
  // }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider(
      create: (context) => EmployeeNotifier(_token,widget.userId),
      child: Consumer<EmployeeNotifier>(
        builder: (BuildContext context, EmployeeNotifier value, Widget? child) {
          var bloc = context.read<EmployeeNotifier>();
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue.shade800,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios,color: Colors.white),
                  onPressed: _onBackPressed,
                ),
                title: const Text(
                    'Profile',
                    style: TextStyle(color: Colors.white,fontFamily: 'Ubuntu')
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    tooltip: 'Edit Profile',
                    onPressed: () {
                      showEditEmployeeDialog(
                        context: context,
                        initialChinese: bloc.employee?.employeeName ?? '',
                        initialMyanmar: bloc.employee?.employeeName ?? '',
                        initialEnglish: bloc.employee?.employeeName ?? '',
                        onSave: (zh, mm, en) {
                          bloc.updateProfileName(mm, zh, en);
                        },
                      );
                    },
                  ),
                ],
              ),
              backgroundColor: Colors.grey.shade100,
              // employee state
              body: Selector<EmployeeNotifier,EmployeeState>(
                  selector: (context,bloc) => bloc.state,
                  builder: (context,state,_){
                    var bloc = context.read<EmployeeNotifier>();
                    if (state == EmployeeState.error) {
                      return Center(
                          child: ErrorEmployeeWidget(
                            errorEmployee: 'Error',
                            tryAgain: () {
                              bloc.getEmployee();
                            },
                          )
                      );
                    }
                    else if (state == EmployeeState.success) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          bloc.getEmployee();
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SafeArea(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12)),
                                    margin: screenWidth >= 600
                                        ? const EdgeInsets.symmetric(horizontal: 20, vertical: 16)
                                        : const EdgeInsets.all(8),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      clipBehavior: Clip.none,
                                      children: [
                                        // The main profile circle
                                        Container(
                                          width: 128,
                                          height: 128,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.15),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                            border: Border.all(color: Colors.white, width: 4),
                                          ),
                                          child: ClipOval(
                                            child: bloc.employee!.imageUrl != null
                                                ? Image.network(
                                                  bloc.employee!.getImageWithBaseUrl(),
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) => Icon(
                                                    Icons.person,
                                                    size: 64,
                                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                                  ),
                                                )
                                                : Icon(
                                                  Icons.person,
                                                  size: 64,
                                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                                ),
                                          ),
                                        ),

                                        if (_currentUserId == widget.userId)
                                          Positioned(
                                            bottom: -6,
                                            right: 6,
                                            child: GestureDetector(
                                              onTap: () async {
                                                final imagePicker = ImagePicker();
                                                XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
                                                if (file != null) {
                                                  final compressed = await compressAndGetFile(File(file.path), file.path, 70);
                                                  if (compressed != null) {
                                                    bloc.uploadProfile(compressed);
                                                  }
                                                }
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white.withOpacity(0.9),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      blurRadius: 6,
                                                      color: Colors.black12,
                                                      offset: Offset(0, 3),
                                                    )
                                                  ],
                                                ),
                                                child: const Icon(Icons.camera_alt, size: 20, color: Colors.black54),
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                    '李祖阳',
                                      style: TextStyle(fontFamily: 'NotoSansSC',fontWeight: FontWeight.w700,fontSize: 16),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: AutoSizeText(
                                            bloc.employee!.employeeName ?? '',
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              fontFamily: 'NotoSansSC',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15,
                                            ),
                                            maxLines: 1,
                                            minFontSize: 10,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 6),
                                        width: 1,
                                        height: 20,
                                        color: Colors.grey,
                                      ),
                                      const Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: AutoSizeText(
                                            'အေးခင်ခင်ချိုလင်းမူ',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontFamily: 'NotoSansSC',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15,
                                            ),
                                            maxLines: 1,
                                            minFontSize: 10,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // const Row(
                                  //   children: [
                                  //     Padding(
                                  //       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  //       child: Text(
                                  //         'Businesses',
                                  //         style: TextStyle(
                                  //             fontFamily: 'DMSans',
                                  //             fontSize: 16,
                                  //             fontWeight: FontWeight.w500),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  SizedBox(
                                    height: 250,
                                    child: ListView.builder(
                                      itemCount: 2,
                                      padding: const EdgeInsets.only(left: 8),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context,index){
                                        return  BusinessCard(
                                          imageUrl: bloc.employee!.getImageWithBaseUrl(),
                                          mmName: bloc.employee!.employeeName ?? '',
                                          zhName: '云味',
                                          enName: 'Xing Yi',
                                          onTap: () {
                                            // navigate to detail page
                                          },
                                          onLocate: () {
                                            // open map or show location
                                          },
                                          location: '25st 90st Mandalay ddf dfk jkdjf dkjfk',
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if(_userRole == 1 || widget.userId == _currentUserId)
                                    Column(
                                      children: [
                                        dashboardCard(
                                            title: 'Personal Info', imagePath: 'lib/icons/personal_info.png',
                                            onTap: () => navigateToPersonal(context,bloc.employee!)),
                                        dashboardCard(
                                            title: 'Education', imagePath: 'lib/icons/user_education.png',
                                            onTap: () => navigateToEducation(context,bloc.employee!)),
                                        dashboardCard(
                                            title: 'Work Experience', imagePath: 'lib/icons/work_exp.png',
                                            onTap: () => navigateToWorkExperience(context,bloc.employee!)),
                                        dashboardCard(
                                            title: 'Facility', imagePath: 'lib/icons/facility.png',
                                            onTap: () => navigateToFacilityPage(context,bloc.employee!)),
                                        dashboardCard(
                                            title: 'Discipline', imagePath: 'lib/icons/discipline.png',
                                            onTap: () => navigateToDisciplinePage(context,bloc.employee!)),
                                      ],
                                    ),
                                  const SizedBox(height: 4)
                                ],
                              )),
                        ),
                      );
                    } else {
                      return const EmployeeProfileShimmer();
                    }
                  }
              )
          );
        },
      )
    );
  }

  Widget disciplineCard(EmployeeVo employee){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ///Discipline
          GestureDetector(
            onTap: (){
              navigateToDisciplinePage(context, employee);
            },
            child: Card(
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

  void navigateToDisciplinePage(BuildContext context,EmployeeVo employee) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => DisciplinePage(empId: employee.id ?? '', userRole: _userRole,),
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

  // Widget _buildRow(BuildContext context, String label, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 6),
  //     child: Row(
  //       children: [
  //         // optional: add a small icon or flag here
  //         Text(
  //           '$label:',
  //           style: TextStyle(
  //             fontWeight: FontWeight.w600,
  //             color: Theme.of(context).textTheme.bodyMedium?.color,
  //           ),
  //         ),
  //         const SizedBox(width: 8),
  //         Expanded(
  //           child: Text(
  //             value,
  //             overflow: TextOverflow.ellipsis,
  //             style: Theme.of(context).textTheme.bodyMedium,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget dashboardCard({
    required String title,
    required String imagePath,
    required VoidCallback onTap,
    Color backgroundColor = const Color(0xFFF5F5F5),
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Image.asset(imagePath, width: 32, height: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

}


