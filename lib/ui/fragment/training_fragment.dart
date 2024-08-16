import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pahg_group/data/models/pahg_model.dart';
import 'package:pahg_group/data/vos/request_body/add_training_request.dart';
import 'package:pahg_group/data/vos/training_vo.dart';
import 'package:pahg_group/dialog/training_dialog.dart';
import 'package:pahg_group/exception/helper_functions.dart';
import 'package:pahg_group/ui/components/training_card.dart';
import 'package:pahg_group/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../utils/image_compress.dart';
import '../providers/auth_provider.dart';

class TrainingFragment extends StatefulWidget {
  const TrainingFragment({super.key, required this.userId, required this.role});
  final String userId;
  final int role;
  @override
  State<TrainingFragment> createState() => _TrainingFragmentState();
}

class _TrainingFragmentState extends State<TrainingFragment> {
  List<TrainingVo> trainingList = [];
  final PahgModel _model = PahgModel();
  String _token = '';
  int _userRole = 0;
  File? _image;
  int _trainingIdForImage = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _initializeData());
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

  void selectPicker(int trainingId){
    _trainingIdForImage = trainingId;
    Utils.showPickerDialog(context, (ImageSource source){
      _selectImage(source);
    });
  }

  Future<void> uploadImage() async{
    _model.uploadImage(_token, _image!).then((response){
      setState(() {

      });
    }).catchError((error){
      Navigator.of(context).pop();                                            //dismiss loading
      showErrorDialog(context, 'Image : ${error.toString()}');
    });
  }

  void _onDelete(String name,int trainingId){
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
                _model.deleteTraining(_token, trainingId).then((onValue){
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

  void _onUpdate(AddTrainingRequest updatedTraining){
    _model.updateTraining(_token, updatedTraining.id!, updatedTraining).then((onValue){
      showSuccessScaffold(context, onValue?.message ?? 'Update');
      _onRefresh();
    }).catchError((onError){
      showErrorDialog(context, onError.toString());
    });
  }

  Future<void> _initializeData() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    _token = authModel.token;
    _userRole = authModel.role;
    _model.getTrainingList(_token, "employeeId", widget.userId).then((onValue){
      setState(() {
        if(onValue.isNotEmpty){
          trainingList = onValue;
        }else{
          isLoading = false;
        }
      });
    }).catchError((onError){
      showErrorRefreshDialog(context, onError.toString(), _initializeData);
    });
  }

  void _onRefresh(){
    _model.getTrainingList(_token, "employeeId", widget.userId).then((onValue){
      setState(() {
        if(onValue.isNotEmpty){
          trainingList = onValue;
        }else{
          trainingList = [];
          isLoading = false;
        }
      });
    }).catchError((onError){
      showErrorDialog(context, onError.toString());
    });
  }

  void _onSave(AddTrainingRequest request){
    request.id = 0;
    request.employeeId = widget.userId;
    _model.addTraining(_token, request).then((onValue){
      _onRefresh();
      showSuccessScaffold(context, onValue?.message ?? "Successful");
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
                    showTrainingDialog(context, onUpdate: _onSave);
                  },
                  child: const Text("Add Training")
              ),
            )
                : const SizedBox(height: 1),
            (trainingList.isNotEmpty)
                ? Column(
              children: trainingList.map((training){
                ///training card
                return TrainingCard(token: _token, userRole: _userRole, onDelete: _onDelete,updateImage: selectPicker,onUpdate: _onUpdate, training: training);
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
