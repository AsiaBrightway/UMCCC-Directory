import 'package:flutter/material.dart';
import 'package:pahg_group/bloc/facility_assign_bloc.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AddFacilityAssignPage extends StatefulWidget {
  final String empId;

  const AddFacilityAssignPage({super.key, required this.empId});

  @override
  State<AddFacilityAssignPage> createState() => _AddFacilityAssignPageState();
}

class _AddFacilityAssignPageState extends State<AddFacilityAssignPage> {

  String _token = '';

  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  Future<void> _initializeData() async{
    final authModel = context.read<AuthProvider>();
    _token = authModel.token;
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context) => FacilityAssignBloc(_token, ''),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Facility Assign',style: TextStyle(fontFamily: 'Ubuntu',color: Colors.white),),
          backgroundColor: Colors.blue.shade800,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,color: Colors.white),
              onPressed: _onBackPressed
          ),
        ),
      ),
    );
  }
}
