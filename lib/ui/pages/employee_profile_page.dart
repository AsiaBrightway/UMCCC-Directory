import 'package:flutter/material.dart';
import 'package:pahg_group/data/vos/employee_vo.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class EmployeeProfilePage extends StatefulWidget {
  final String userId;
  const EmployeeProfilePage({super.key, required this.userId});

  @override
  State<EmployeeProfilePage> createState() => _EmployeeProfilePageState();
}

class _EmployeeProfilePageState extends State<EmployeeProfilePage> {
  String _token = '';
  String _userId = '';
  late EmployeeVo employeeVo;

  @override
  void didChangeDependencies() {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    _token = authProvider.token;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              profileCard(),

            ],
          ),
        ),
      ),
    );
  }

  Widget profileCard(){
    return Row(
      children: [
          ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Image.network(
            ,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
              return Image.asset('lib/icons/profile.png',width: 80,height: 90); // Show error image
            },
          ),
        )
      ],
    );
  }
}
