import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pahg_group/data/vos/education_school_vo.dart';
import 'package:pahg_group/data/vos/request_body/add_school_request.dart';
import 'package:pahg_group/utils/helper_functions.dart';
import 'package:pahg_group/ui/components/school_card.dart';
import 'package:pahg_group/dialog/update_school_dialog.dart';
import 'package:provider/provider.dart';

import '../../data/models/pahg_model.dart';
import '../../data/vos/request_body/path_user_request.dart';
import '../../utils/image_compress.dart';
import '../../utils/utils.dart';
import '../components/empty_data_widget.dart';
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
  int _schoolIdForImage = 0;
  bool isLoading = true;
  File? _image;

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
      showSuccessScaffold(context, onValue?.message ?? "Successfully added");
    }).catchError((onError){
      showErrorDialog(context, onError.toString());
    });
  }

  void _onUpdate(AddSchoolRequest updatedSchool){
    _model.updateSchool(_token, updatedSchool.id!, updatedSchool).then((onValue){
      _onRefresh();
      showSuccessScaffold(context, onValue?.message ?? "Successfully updated");
    }).catchError((onError){
      showErrorDialog(context, onError.toString());
    });
  }

  Future<void> uploadImage() async{
    _model.uploadImage(_token, _image!).then((response){
      PathUserRequest request = PathUserRequest("ImageUrl", "replace", response?.file);
      _model.patchSchool(_token, _schoolIdForImage, request).then((onValue){
        setState(() {
          _onRefresh();
        });
      }).catchError((onError){

      });
    }).catchError((error){
      Navigator.of(context).pop();                                            //dismiss loading
      showErrorDialog(context, 'Image : ${error.toString()}');
    });
  }

  Future<void> _selectImage(ImageSource source) async{
    // Create an instance of ImagePicker
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      File? compressFile = await compressAndGetFile(File(file.path), file.path,48);
      if (compressFile != null) {
        setState(() {
          _image = compressFile;
          uploadImage();
        });
      }
    }
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

  void selectPicker(int schoolId){
    _schoolIdForImage = schoolId;
    Utils.showPickerDialog(context, (ImageSource source){
      _selectImage(source);
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
                  return SchoolCard(school: school,token: _token,userRole: _userRole,updateImage: selectPicker,onDelete: _onDelete,onUpdate: _onUpdate,);
                }).toList(),
              )
              : isLoading
                ? const SizedBox(
                    height : 250,
                    child: Center(child: CircularProgressIndicator())
                )
                : const SizedBox(
                  height: 250,
                  child: Center(child: EmptyDataWidget()),
                ),
          ],
        ),
      ),
    );
  }
}
