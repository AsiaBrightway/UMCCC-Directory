
import 'package:flutter/cupertino.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Education'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'School'),
            Tab(text: 'Graduate'),
            Tab(text: 'Training'),
            Tab(text: 'Language',)
          ],
        ),
      ),
      body: TabBarView(
      controller: _tabController,
      children: [
        SchoolFragment(userId: widget.empId,role: widget.userRole),
        GraduateFragment(),
        TrainingFragment(),
        LanguageFragment()
      ],
    ),
    );
  }
}
