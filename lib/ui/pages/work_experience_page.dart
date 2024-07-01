import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pahg_group/data/vos/request_body/add_work_request.dart';
import 'package:pahg_group/data/vos/work_vo.dart';
import 'package:pahg_group/ui/components/work_exp_card.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class WorkExperiencePage extends StatefulWidget {
  const WorkExperiencePage({super.key, required this.empId, required this.userRole});
  final String empId;
  final int userRole;
  @override
  State<WorkExperiencePage> createState() => _WorkExperiencePageState();
}

class _WorkExperiencePageState extends State<WorkExperiencePage> {
  String _token = "";
  List<WorkVo> workList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _initializeData());
  }

  void _onUpdate(AddWorkRequest updatedWork){

  }

  void _onDelete(String name,int id){

  }
  Future<void> _initializeData() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    _token = authModel.token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Work Experience"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            (widget.userRole == 1)
                ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                  onPressed: (){

                  },
                  child: const Text("Add Work Exp")
              ),
            )
                : const SizedBox(height: 1),
            (workList.isNotEmpty)
                ? Column(
                    children: workList.map((work) {
                      return WorkExpCard(work: work, token: _token, userRole: widget.userRole, onUpdate: _onUpdate, onDelete: _onDelete);
                    }).toList(),
                  )
                : isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "Empty",
                          style: TextStyle(fontFamily: 'Ubuntu'),
                        ),
                      ),
          ],
        ),
      ),
    );
  }

}
