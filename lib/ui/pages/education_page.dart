
import 'package:flutter/material.dart';
import 'package:pahg_group/ui/fragment/graduate_fragment.dart';
import 'package:pahg_group/ui/fragment/language_fragment.dart';
import 'package:pahg_group/ui/fragment/school_fragment.dart';
import 'package:pahg_group/ui/fragment/training_fragment.dart';

class EducationPage extends StatefulWidget {
  const EducationPage({super.key, required this.empId, required this.userRole});
  final String empId;
  final int userRole;
  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Number of tabs
  }

  void _onBackPressed(){
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: _onBackPressed,
        ),
        title: const Text('Education',style: TextStyle(fontFamily: 'Ubuntu',color: Colors.white),),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          tabs: const [
            Tab(text: 'School'),

            Tab(text: 'Graduate'),
            Tab(text: 'Training'),
            Tab(text: 'Language')
          ],
        ),
      ),
      body: TabBarView(
      controller: _tabController,
      children: [
        SchoolFragment(userId: widget.empId,role: widget.userRole),
        GraduateFragment(userId: widget.empId,role: widget.userRole),
        TrainingFragment(userId: widget.empId,role: widget.userRole),
        LanguageFragment(userId: widget.empId,role: widget.userRole)
      ],
    ),
    );
  }
}
