import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pahg_group/data/models/pahg_model.dart';
import 'package:pahg_group/data/vos/language_vo.dart';
import 'package:pahg_group/data/vos/request_body/add_language_request.dart';
import 'package:pahg_group/dialog/language_dialog.dart';
import 'package:pahg_group/ui/components/language_card.dart';
import 'package:provider/provider.dart';

import '../../exception/helper_functions.dart';
import '../providers/auth_provider.dart';

class LanguageFragment extends StatefulWidget {
  const LanguageFragment({super.key, required this.userId, required this.role});
  final String userId;
  final int role;
  @override
  State<LanguageFragment> createState() => _LanguageFragmentState();
}

class _LanguageFragmentState extends State<LanguageFragment> {
  final PahgModel _model = PahgModel();
  List<LanguageVo> languageList = [];
  String _token = "";
  bool isLoading = true;
  int _userRole = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _initializeData());
  }

  ///edit id and employeeId cause they are null
  void _onAdd(AddLanguageRequest language){
    language.id = 0;
    language.employeeId = widget.userId;
    _model.addLanguage(_token, language).then((onValue){
      showScaffoldMessage(context, onValue?.message ?? "Successfully Added");
      _onRefresh();
    }).catchError((onError){
      showErrorDialog(context, onError.toString());
    });
  }

  void _onRefresh(){
    _model.getLanguageList(_token, 'employeeId', widget.userId).then((onValue){
      setState(() {
        if(onValue.isNotEmpty){
          languageList = onValue;
        }else{
          languageList = [];
          isLoading = false;
        }
      });
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
                _model.deleteLanguage(_token, id).then((onValue){
                  showScaffoldMessage(context, onValue?.message ?? "");
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

  void _onUpdate(AddLanguageRequest updatedLanguage){
    _model.updateLanguage(_token,updatedLanguage.id!, updatedLanguage).then((onValue){
      showScaffoldMessage(context, onValue?.message ?? "Language Update is successful");
      _onRefresh();
    }).catchError((onError){
      showErrorDialog(context, onError.toString());
    });
  }

  Future<void> _initializeData() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    _token = authModel.token;
    _userRole = authModel.role;
    _model.getLanguageList(_token, 'employeeId', widget.userId).then((onValue){
      setState(() {
        if(onValue.isNotEmpty){
          languageList = onValue;
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
                    showLanguageDialog(context,language: null, onSave: _onAdd);
                  },
                  child: const Text("Add Language")
              ),
            )
                : const SizedBox(height: 1),
            (languageList.isNotEmpty)
                ? Column(
              children: languageList.map((language){
                return LanguageCard(token: _token, userRole: _userRole, onDelete: _onDelete, onUpdate: _onUpdate, language: language);
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
