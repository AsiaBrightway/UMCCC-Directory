import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pahg_group/data/models/pahg_model.dart';
import 'package:pahg_group/data/vos/request_body/add_graduate_request.dart';
import 'package:pahg_group/ui/components/graduate_card.dart';
import 'package:provider/provider.dart';

import '../../data/vos/graduate_vo.dart';
import '../../dialog/graduate_dialog.dart';
import '../../exception/helper_functions.dart';
import '../providers/auth_provider.dart';

class GraduateFragment extends StatefulWidget {
  const GraduateFragment({super.key, required this.userId, required this.role});
  final String userId;
  final int role;
  @override
  State<GraduateFragment> createState() => _GraduateFragmentState();
}

class _GraduateFragmentState extends State<GraduateFragment> {
  List<GraduateVo> graduateList = [];
  final PahgModel _model = PahgModel();
  String _token = '';
  int _userRole = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _initializeData());
  }

  void _onDelete(String name,int id){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          icon: const Text('Delete' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
          content: Text('Are you sure to delete $name?',style: const TextStyle(fontSize: 16),),
          actions: [
            TextButton(
              child: const Text("cancel"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () {
                _model.deleteGraduate(_token, id).then((onValue){
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

  void _onAdd(AddGraduateRequest request){
    var addRequest = request;
    addRequest.id = 0;
    addRequest.employeeId = widget.userId;
    _model.addGraduate(_token, request).then((onValue){
      showScaffoldMessage(context, onValue?.message ?? "Successfully added");
      _onRefresh();
    }).catchError((onError){
      showErrorDialog(context, onError.toString());
    });
  }

  void _onUpdate(AddGraduateRequest updatedRequest){
    _model.updateGraduate(_token, updatedRequest.id!, updatedRequest).then((onValue){
      showScaffoldMessage(context, onValue?.message ?? "Successfully added");
      _onRefresh();
    }).catchError((onError){
      showErrorDialog(context, onError.toString());
    });
  }

  Future<void> _onRefresh() async {
    _model.getGraduateList(_token, 'employeeId', widget.userId).then((onValue){
      setState(() {
        if(onValue.isNotEmpty){
          graduateList = onValue;
        }else{
          graduateList = [];
          isLoading = false;
        }
      });
    }).catchError((onError){
      showErrorDialog(context, onError.toString());
    });
  }

  Future<void> _initializeData() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    _token = authModel.token;
    _userRole = authModel.role;
    _model.getGraduateList(_token, 'employeeId', widget.userId).then((onValue){
      setState(() {
        if(onValue.isNotEmpty){
          graduateList = onValue;
        }else{
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
                    showGraduateDialog(context, graduate: null,onSave: _onAdd);
                  },
                  child: const Text("Add Graduate")
              ),
            )
                : const SizedBox(height: 1),
            (graduateList.isNotEmpty)
                ? Column(
              children: graduateList.map((graduate){
                return GraduateCard(token: _token, userRole: _userRole, onDelete: _onDelete, onUpdate: _onUpdate, graduate: graduate);
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
