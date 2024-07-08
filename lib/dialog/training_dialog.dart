import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pahg_group/data/vos/request_body/add_training_request.dart';
import 'package:pahg_group/data/vos/training_vo.dart';
import 'package:pahg_group/ui/themes/colors.dart';

class TrainingDialog extends StatefulWidget {
  const TrainingDialog({super.key, this.training, required this.onSave});
  final TrainingVo? training;
  final Function(AddTrainingRequest) onSave;
  @override
  State<TrainingDialog> createState() => _TrainingDialogState();
}

class _TrainingDialogState extends State<TrainingDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _courseNameController;
  late TextEditingController _trainingProvidedByController;
  late TextEditingController _placeController;
  late TextEditingController _trainingTimeController;
  late TextEditingController _trainingNote;
  bool isCertificate = false;
  String? startDate;
  String? endDate;
  int? trainingType;
  int? trainingResult;

  @override
  void initState() {
    super.initState();
    _courseNameController = TextEditingController(text: widget.training?.courseName ?? '');
    _trainingProvidedByController = TextEditingController(text: widget.training?.trainingProvidedBy ?? '');
    _placeController = TextEditingController(text: widget.training?.place ?? '');
    _trainingTimeController = TextEditingController(text: widget.training?.totalTrainingTime ?? '');
    _trainingNote = TextEditingController(text: widget.training?.note ?? '');

    isCertificate = widget.training?.certificate ?? true;
    if(widget.training != null){
      startDate = widget.training!.startDate;
      endDate = widget.training!.endDate;
      trainingResult = widget.training?.trainingResult ;
      trainingType = widget.training?.trainingType;
    }else{
      startDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      endDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    }
  }

  void _handleTrainingType(int? value) {
    setState(() {
      trainingType = value!;
    });
  }

  void _handleTrainingResult(int? value){
    setState(() {
      trainingResult = value;
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        startDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        endDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.training == null ? 'Add Training' : 'Update Training'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: _formKey,
            child: ListBody(
              children: <Widget>[
                const SizedBox(height: 4),
                ///course name text field
                TextFormField(
                  controller: _courseNameController,
                  decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: colorAccent),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13),
                      labelText: 'Course Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a course';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Internal'),
                    Radio(
                      value: 1,
                      groupValue: trainingType,
                      activeColor: colorAccent,
                      onChanged: _handleTrainingType,
                    ),
                    const Text('External'),
                    Radio(
                      value: 2,
                      groupValue: trainingType,
                      activeColor: colorAccent,
                      onChanged: _handleTrainingType,
                    ),
                  ],
                ),
                ///training provided by
                TextFormField(
                  controller: _trainingProvidedByController,
                  decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: colorAccent),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13),
                      labelText: 'provided by',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _placeController,
                  decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: colorAccent),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13),
                      labelText: 'Place',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text("Start :$startDate",style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13)),
                    const SizedBox(width: 6),
                    GestureDetector(
                        onTap: (){ _selectStartDate(context); },
                        child: const Icon(Icons.edit_calendar,color: colorAccent,)
                    )
                  ],
                ),
                Row(
                  children: [
                    Text("End :$endDate",style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13)),
                    const SizedBox(width: 8),
                    GestureDetector(
                        onTap: (){ _selectEndDate(context); },
                        child: const Icon(Icons.edit_calendar,color: colorAccent,)
                    )
                  ],
                ),
                const SizedBox(height: 12),
                ///total training time text field
                TextFormField(
                  controller: _trainingTimeController,
                  decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: colorAccent),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13),
                      labelText: 'Training time',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )
                  ),
                ),
                Row(
                  children: [
                    const Text('Pass',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 12),),
                    Expanded(
                      child: Radio(
                        value: 1,
                        groupValue: trainingResult,
                        activeColor: colorAccent,
                        onChanged: _handleTrainingResult,
                      ),
                    ),
                    const Text('Not Pass',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 12)),
                    Expanded(
                      child: Radio(
                        value: 2,
                        groupValue: trainingResult,
                        activeColor: colorAccent,
                        onChanged: _handleTrainingResult,
                      ),
                    ),
                    const Text('No Exam',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 12)),
                    Expanded(
                      child: Radio(
                          value: 3,
                          groupValue: trainingResult,
                          onChanged: _handleTrainingResult),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Text("Certificate",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 12),),
                    Checkbox(
                      value: isCertificate,
                      activeColor: Colors.green,
                      onChanged: (value){
                        setState(() {
                          isCertificate = value!;
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _trainingNote,
                  decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: colorAccent),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13),
                      labelText: 'Note',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text(widget.training == null ? 'Add' : 'Update'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              ///data should be null if user doesn't add date.the exception can found when the date is empty string
              ///employeeId is null if add school
              AddTrainingRequest updatedTraining = AddTrainingRequest(
                  widget.training?.id!,
                  widget.training?.employeeId,
                  _courseNameController.text,
                  trainingType,
                  _trainingProvidedByController.text,
                  _placeController.text,
                  startDate,
                  endDate,
                  _trainingTimeController.text,
                  trainingResult,
                  isCertificate,
                  _trainingNote.text

              );
              // Pass the updated school to the onUpdate callback
              widget.onSave(updatedTraining);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

///first trigger dialog and then implement ui
Future<void> showTrainingDialog(
    BuildContext context, {
      TrainingVo? training,
      required Function(AddTrainingRequest) onUpdate,
    }) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return TrainingDialog(
        training: training,
        onSave: onUpdate,
      );
    },
  );
}

