
import 'dart:io';

import 'package:flutter/cupertino.dart';
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
import 'add_employee_page.dart';
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

  Future<void> _navigateToEditPage(String employeeId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEmployeePage(isAdd: false,userId: employeeId)),
    );
    if (result == true) {
      // Data has been updated, refresh the data
      // employeeNotifier?.getEmployee(widget.userId);
    }
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider(
      create: (context) => EmployeeNotifier(_token,widget.userId),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade800,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,color: Colors.white),
            onPressed: _onBackPressed,
          ),
          title: const Text('Profile',style: TextStyle(color: Colors.white,fontFamily: 'Ubuntu')),
          centerTitle: true,
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
                                    children: [
                                      /// employee profile card
                                      newProfileCard(context,bloc.employee!),
                                    ],
                                  ),
                                ),
                                const Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      child: Text(
                                        'Businesses',
                                        style: TextStyle(
                                            fontFamily: 'DMSans',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 250,
                                  child: ListView.builder(
                                    itemCount: 2,
                                    padding: const EdgeInsets.only(left: 12),
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
                                DashboardCard(
                                    title: 'Personal Info', imagePath: 'lib/icons/personal_info.png',
                                    onTap: () => navigateToPersonal(context,bloc.employee!)),

                                DashboardCard(
                                    title: 'Education', imagePath: 'lib/icons/user_education.png',
                                    onTap: () => navigateToEducation(context,bloc.employee!)),
                                DashboardCard(
                                    title: 'Work Experience', imagePath: 'lib/icons/work_exp.png',
                                    onTap: () => navigateToWorkExperience(context,bloc.employee!)),
                                DashboardCard(
                                    title: 'Facility', imagePath: 'lib/icons/facility.png',
                                    onTap: () => navigateToFacilityPage(context,bloc.employee!)),
                                DashboardCard(
                                    title: 'Discipline', imagePath: 'lib/icons/discipline.png',
                                    onTap: () => navigateToDisciplinePage(context,bloc.employee!)),
                                const SizedBox(height: 4,)
                          ],
                        )),
                      ),
                    );
              } else {
                return const EmployeeProfileShimmer();
              }
            }
        )
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

  Widget newProfileCard(BuildContext context,EmployeeVo person){
    final bloc = context.read<EmployeeNotifier>();
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ─── Profile Image ───
          Stack(
            clipBehavior: Clip.none,
            children: [
              // The main profile circle
              Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: ClipOval(
                  child: person.imageUrl != null
                      ? Image.network(
                        person.getImageWithBaseUrl(),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.person,
                          size: 64,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      )
                      : Icon(
                        Icons.person,
                        size: 64,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                ),
              ),

              // Positioned edit button
              Positioned(
                bottom: 4,
                right: 4,
                child: Material(
                  shape: const CircleBorder(),
                  elevation: 2,
                  color: Colors.white,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () async{
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

                      if (file != null) {
                        // Compress the image
                        File? compressFile = await compressAndGetFile(File(file.path), file.path,70);

                        // Update the state with the compressed file
                        if (compressFile != null) {
                          bloc.uploadProfile(compressFile);
                        }
                      }
                    },
                    child: (_currentUserId == widget.userId)
                        ? const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.grey,
                          ),
                        )
                        : null,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          Container(
            padding: const EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Name',style: TextStyle(fontFamily: 'DMSans')),
                const SizedBox(height: 8),
                _buildRow(context, '中文', 'Chinese'),
                const Divider(color: Colors.grey,),
                _buildRow(context, 'မြန်မာ', 'ဝင်းကျော်အေး'),
                const Divider(color: Colors.grey,),
                _buildRow(context, 'English', 'Win Kyaw Aye'),
              ],
            ),
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

  Widget _buildRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // optional: add a small icon or flag here
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;
  final Color? borderColor;

  const DashboardCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 80,
        margin: const EdgeInsets.symmetric(vertical: 6,horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          border: Border.all(
            color: borderColor ?? Colors.black,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Icon or Image
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                imagePath,
                width: 40,
                height: 40,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 16),

            // Title and Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'more details >>',
                    style: TextStyle(
                      color: colorAccent,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: colorAccent),
          ],
        ),
      ),
    );
  }
}
