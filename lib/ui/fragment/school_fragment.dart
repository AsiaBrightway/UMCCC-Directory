import 'package:flutter/material.dart';
import 'package:pahg_group/data/vos/education_school_vo.dart';
import 'package:pahg_group/data/vos/request_body/add_school_request.dart';
import 'package:pahg_group/exception/helper_functions.dart';
import 'package:pahg_group/ui/components/school_card.dart';
import 'package:pahg_group/dialog/update_school_dialog.dart';
import 'package:provider/provider.dart';

import '../../data/models/pahg_model.dart';
import '../providers/auth_provider.dart';

class SchoolFragment extends StatefulWidget {
  const SchoolFragment({super.key, required this.userId, required this.role});
  final String userId;
  final int role;

  @override
  State<SchoolFragment> createState() => _SchoolFragmentState();
}

class _SchoolFragmentState extends State<SchoolFragment> {
  final PahgModel _model = PahgModel();
  List<EducationSchoolVo> schoolList = [];
  String _token = '';
  int _userRole = 0;
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
    _model.getSchoolList(_token, 'employeeId', widget.userId).then((onValue){
      setState(() {
        if(onValue.isNotEmpty){
          schoolList = onValue;
        }else{
          isLoading = false;
        }
      });
    }).catchError((onError){
      showErrorRefreshDialog(context, onError.toString(), _initializeData);
    });
  }

  ///change userId and id because they are coming back as null
  void _onAdd(AddSchoolRequest request) {
    var addRequest = request;
    addRequest.id = 0;
    addRequest.employeeId = widget.userId;
    _model.addSchool(_token, addRequest).then((onValue){
      _onRefresh();
      showScaffoldMessage(context, onValue?.message ?? "Successfully added");
    }).catchError((onError){
      showErrorDialog(context, onError.toString());
    });
  }

  void _onUpdate(AddSchoolRequest updatedSchool){
    _model.updateSchool(_token, updatedSchool.id!, updatedSchool).then((onValue){
      _onRefresh();
      showScaffoldMessage(context, onValue?.message ?? "Successfully updated");
    }).catchError((onError){
      showErrorDialog(context, onError.toString());
    });
  }

  void _onDelete(String name,int schoolId) {
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
                  _model.deleteSchool(_token, schoolId).then((onValue){
                    showScaffoldMessage(context, onValue?.message ?? "Successfully deleted");
                    _onRefresh();
                    Navigator.of(context).pop();
                  }).catchError((onError){
                    showErrorDialog(context, onError.toString());
                  });
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
  }

  Future<void> _onRefresh() async {
    _model.getSchoolList(_token, 'employeeId', widget.userId).then((onValue){
      setState(() {
        if(onValue.isNotEmpty){
          schoolList = onValue;
        }else{
          schoolList = [];
          isLoading = false;
        }
      });
    }).catchError((onError){
      showErrorDialog(context, onError.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      ///list view is not working in this tab view
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
        ),
        child: Column(
          children : [
          (widget.role == 1)
              ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                    onPressed: (){
                      showSchoolDialog(context,school: null,onSave: _onAdd);
                    },
                    child: const Text("Add School")
                ),
              )
              : const SizedBox(height: 1),
          (schoolList.isNotEmpty)
              ? Column(
                children: schoolList.map((school){
                  return SchoolCard(school: school,token: _token,userRole: _userRole,onDelete: _onDelete,onUpdate: _onUpdate,);
                }).toList(),
              )
              : isLoading
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
              )
              : const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Empty",style: TextStyle(fontFamily: 'Ubuntu'),),
              ),
          ],
        ),
      ),
    );
  }

  
}
