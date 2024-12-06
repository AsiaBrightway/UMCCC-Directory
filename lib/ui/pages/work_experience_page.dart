
import 'package:flutter/material.dart';
import 'package:pahg_group/ui/components/empty_data_widget.dart';
import 'package:provider/provider.dart';

import '../../data/models/pahg_model.dart';
import '../../data/vos/request_body/add_work_request.dart';
import '../../data/vos/work_vo.dart';
import '../../dialog/work_dialog.dart';
import '../../utils/helper_functions.dart';
import '../components/work_exp_card.dart';
import '../providers/auth_provider.dart';

class WorkExperiencePage extends StatefulWidget {
  const WorkExperiencePage({super.key, required this.empId, required this.userRole});
  final String empId;
  final int userRole;
  @override
  State<WorkExperiencePage> createState() => _WorkExperiencePageState();
}

class _WorkExperiencePageState extends State<WorkExperiencePage> {
  final PahgModel _model = PahgModel();
  String _token = "";
  List<WorkVo> workList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _initializeData());
  }

  void _onSave(AddWorkRequest work){
    work.id = 0;
    work.employeeId = widget.empId;
    _model.addWorkExperience(_token, work).then((onValue){
      showSuccessScaffold(context, onValue?.message ?? 'Created');
      _onRefresh();
    }).catchError((onError){
      showErrorDialog(context, onError.toString());
    });
  }

  void _onUpdate(AddWorkRequest updatedWork){
    _model.updateWorkExperience(_token, updatedWork.id!, updatedWork).then((onValue){
      showSuccessScaffold(context, onValue?.message ?? 'Updated');
      _onRefresh();
    }).catchError((onError){
      showErrorDialog(context, onError.toString());
    });
  }

  void _onDelete(String name,int id){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          icon: Text(name ,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
          content: const Text('Are you sure to delete?',style: TextStyle(fontSize: 16),),
          actions: [
            TextButton(
              child: const Text("cancel"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () {
                _model.deleteWorkExperience(_token, id).then((onValue){
                  showScaffoldMessage(context, onValue?.message ?? "Successfully deleted");
                  _onRefresh();
                  Navigator.of(context).pop();
                }).catchError((onError){
                  showErrorDialog(context, onError.toString());
                  Navigator.of(context).pop();
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onRefresh() async{
    _model.getWorkList(_token,"employeeId", widget.empId).then((onValue){
      setState(() {
        if(onValue.isNotEmpty){
          workList = onValue;
        }else{
          workList = [];
          isLoading = false;
        }
      });
    }).catchError((onError){
      setState(() {
        isLoading = false;
      });
      showErrorDialog(context, onError.toString());
    });
  }

  Future<void> _initializeData() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    _token = authModel.token;
    _model.getWorkList(_token,"employeeId", widget.empId).then((onValue){
      setState(() {
        if(onValue.isNotEmpty){
          workList = onValue;
        }else{
          isLoading = false;
        }
      });
    }).catchError((onError){
      setState(() {
        isLoading = false;
      });
      showErrorRefreshDialog(context, onError.toString(), _initializeData);
    });
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
        centerTitle: true,
        title: const Text("Work Experience",style: TextStyle(color: Colors.white,fontFamily: 'Ubuntu'),),
      ),
      floatingActionButton: (widget.userRole == 1)
          ? FloatingActionButton.extended(
              onPressed: () {
                showWorkDialog(context,work: null, onUpdate: _onSave);
              },
              backgroundColor: Colors.orangeAccent,
              icon: const Icon(Icons.add),
              label: const Text('Add Work Exp'),
            )
          : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               const Row(
                 mainAxisAlignment: MainAxisAlignment.center,
               ),
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
                          child: EmptyDataWidget()
                          )
            ],
          ),
        ),
      ),
    );
  }
}
