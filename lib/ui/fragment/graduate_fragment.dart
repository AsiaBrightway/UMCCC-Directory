import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pahg_group/data/vos/request_body/path_user_request.dart';
import 'package:pahg_group/ui/components/empty_data_widget.dart';

import 'package:provider/provider.dart';

import '../../data/models/pahg_model.dart';
import '../../data/vos/graduate_vo.dart';
import '../../data/vos/request_body/add_graduate_request.dart';
import '../../dialog/graduate_dialog.dart';
import '../../utils/helper_functions.dart';
import '../../utils/image_compress.dart';
import '../../utils/utils.dart';
import '../components/graduate_card.dart';
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
  File? _image;
  int _graduateIdForImage = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _initializeData());
  }

  void selectPicker(int graduateId){
    _graduateIdForImage = graduateId;
    Utils.showPickerDialog(context, (ImageSource source){
      _selectImage(source);
    });
  }

  Future<void> uploadImage() async{
    _model.uploadImage(_token, _image!).then((response){
      PathUserRequest request = PathUserRequest("ImageUrl", "replace", response?.file);
      _model.patchEducationGraduates(_token, _graduateIdForImage, request).then((onValue){
        _onRefresh();
      }).catchError((onError){
        setState(() {
          showErrorDialog(context, onError.toString());
        });
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
      showSuccessScaffold(context, onValue?.message ?? "Successfully added");
      _onRefresh();
    }).catchError((onError){
      showErrorDialog(context, onError.toString());
    });
  }

  void _onUpdate(AddGraduateRequest updatedRequest){
    _model.updateGraduate(_token, updatedRequest.id!, updatedRequest).then((onValue){
      showSuccessScaffold(context, onValue?.message ?? "Successfully added");
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
      showErrorRefreshDialog(context, onError.toString(), _initializeData);
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
                    return GraduateCard(token: _token, userRole: _userRole, onDelete: _onDelete, onUpdateImage: selectPicker,onUpdate: _onUpdate, graduate: graduate);
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
