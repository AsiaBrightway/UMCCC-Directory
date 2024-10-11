import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

import '../../data/models/pahg_model.dart';
import '../../data/vos/language_vo.dart';
import '../../data/vos/request_body/add_language_request.dart';
import '../../data/vos/request_body/path_user_request.dart';
import '../../dialog/language_dialog.dart';
import '../../utils/helper_functions.dart';
import '../../utils/image_compress.dart';
import '../../utils/utils.dart';
import '../components/language_card.dart';
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
  int _languageIdForImage = 0;
  int _userRole = 0;
  File? _image;

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
      showSuccessScaffold(context, onValue?.message ?? "Successfully Added");
      _onRefresh();
    }).catchError((onError){
      showErrorDialog(context, onError.toString());
    });
  }

  Future<void> uploadImage() async{
    _model.uploadImage(_token, _image!).then((response){
      PathUserRequest request = PathUserRequest("ImageUrl", "replace", response?.file);
        _model.patchLanguage(_token, _languageIdForImage, request).then((onValue){
          _initializeData();
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

  void _selectImagePicker(int languageId){
    _languageIdForImage = languageId;
    Utils.showPickerDialog(context, (ImageSource source){
      _selectImage(source);
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
      showSuccessScaffold(context, onValue?.message ?? "Language Update is successful");
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
                        onPressed: () {
                          showLanguageDialog(context,
                              language: null, onSave: _onAdd);
                        },
                        child: const Text("Add Language")),
                  )
                : const SizedBox(height: 1),
            (languageList.isNotEmpty)
                ? Column(
                    children: languageList.map((language) {
                      return LanguageCard(
                          token: _token,
                          userRole: _userRole,
                          updateImage: _selectImagePicker,
                          onDelete: _onDelete,
                          onUpdate: _onUpdate,
                          language: language);
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
