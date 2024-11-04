
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../data/models/pahg_model.dart';
import '../../data/vos/family_vo.dart';
import '../../data/vos/request_body/add_family_request.dart';
import '../../dialog/family_dialog.dart';
import '../../utils/helper_functions.dart';
import '../components/family_card.dart';
import '../providers/auth_provider.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key, required this.empId, required this.userRole});

  final String empId;
  final int userRole;
  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  List<FamilyVo> familyList = [];
  bool isLoading = true;
  String _token = "";
  final PahgModel _model = PahgModel();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _initializeData());
  }

  void _onAdd(AddFamilyRequest request){
    request.id = 0;
    request.employeeId = widget.empId;
    _model.addFamily(_token, request).then((onValue){
      _onRefresh();
      showSuccessScaffold(context, onValue?.message ?? "Success");
    }).catchError((onError){
      showErrorDialog(context, onError.toString());
    });
  }

  void _onUpdate(AddFamilyRequest family){
    _model.updateFamily(_token, family.id!, family).then((onValue){
      _onRefresh();
      showSuccessScaffold(context, onValue?.message ?? '');
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
                _model.deleteFamily(_token, id).then((onValue){
                  _onRefresh();
                  Navigator.of(context).pop();
                  showSuccessScaffold(context, onValue?.message ?? "Success");
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

  Future<void> _onRefresh() async{
    _model.getFamilyList(_token, "employeeId", widget.empId).then((onValue){
      setState(() {
        if(onValue.isNotEmpty){
          familyList = onValue;
        }else{
          familyList = [];
          isLoading = false;
        }
      });
    }).catchError((onError){
      showErrorDialog(context, onError.toString());
    });
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  Future<void> _initializeData() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    _token = authModel.token;
    _model.getFamilyList(_token, "employeeId", widget.empId).then((onValue){
      setState(() {
        if(onValue.isNotEmpty){
          familyList = onValue;
        }else{
          familyList = [];
          isLoading = false;
        }
      });
    }).catchError((onError){
      showErrorDialog(context, onError.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        title: const Text("Family Member",style: TextStyle(color: Colors.white),),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white
          ),
          onPressed: _onBackPressed,
        ),
      ),
      floatingActionButton: (widget.userRole == 1)
          ? FloatingActionButton.extended(
              onPressed: () {
                showFamilyDialog(context, family: null, onUpdate: _onAdd);
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
              ///we need this guy to get the center to family card xD
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              (familyList.isNotEmpty)
                  ? Column(
                      children: familyList.map((family) {
                      return FamilyCard(
                          token: _token,
                          userRole: widget.userRole,
                          onUpdate: _onUpdate,
                          onDelete: _onDelete,
                          family: family);}).toList())
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
      ),
    );
  }
}
