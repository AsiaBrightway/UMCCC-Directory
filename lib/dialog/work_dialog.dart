import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pahg_group/data/vos/request_body/add_work_request.dart';
import 'package:pahg_group/data/vos/work_vo.dart';
import 'package:pahg_group/ui/themes/colors.dart';
import 'package:pahg_group/utils/utils.dart';

class WorkDialog extends StatefulWidget {
  const WorkDialog({super.key, required this.onSave, this.work});
  final WorkVo? work;
  final Function(AddWorkRequest) onSave;
  @override
  State<WorkDialog> createState() => _WorkDialogState();
}

class _WorkDialogState extends State<WorkDialog> {

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _companyNameController;
  late TextEditingController _rankController;
  late TextEditingController _salaryAllowanceController;
  late TextEditingController _responsibilityController;
  String? startDate;
  String? endDate;

  @override
  void initState() {
    super.initState();
    _companyNameController = TextEditingController(text: widget.work?.companyName ?? '');
    _rankController = TextEditingController(text: widget.work?.rank ?? '');
    _salaryAllowanceController = TextEditingController(text: widget.work?.salaryAndAllowance ?? '');
    _responsibilityController = TextEditingController(text: widget.work?.detailResponsibilities ?? '');
    if(widget.work != null){
      startDate = Utils.getFormattedDate(widget.work!.fromDate);
      endDate = Utils.getFormattedDate(widget.work!.toDate);
    }else{
      startDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      endDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    }
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
      title: Text(widget.work == null ? 'Add Work' : 'Update Work'),
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
                  controller: _companyNameController,
                  decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: colorAccent),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13),
                      labelText: 'Company Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                ///training provided by
                TextFormField(
                  controller: _rankController,
                  decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: colorAccent),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13),
                      labelText: 'Rank',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _salaryAllowanceController,
                  decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: colorAccent),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13),
                      labelText: 'Salary and Allowance',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text("Start : $startDate",style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13)),
                    const SizedBox(width: 6),
                    GestureDetector(
                        onTap: (){ _selectStartDate(context); },
                        child: const Icon(Icons.edit_calendar,color: colorAccent,)
                    )
                  ],
                ),
                Row(
                  children: [
                    Text("End : $endDate",style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13)),
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
                  controller: _responsibilityController,
                  decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: colorAccent),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13),
                      labelText: 'Responsibilities',
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
          child: Text(widget.work == null ? 'Add' : 'Update'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              ///data should be null if user doesn't add date.the exception can found when the date is empty string
              ///employeeId is null if add school
              AddWorkRequest updatedWork = AddWorkRequest(
                  widget.work?.id!,
                  widget.work?.employeeId,
                  _companyNameController.text,
                  _rankController.text,
                  startDate,
                  endDate,
                  _salaryAllowanceController.text,
                  _responsibilityController.text
              );
              // Pass the updated school to the onUpdate callback
              widget.onSave(updatedWork);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

///first trigger dialog and then implement ui
Future<void> showWorkDialog(
    BuildContext context, {
      WorkVo? work,
      required Function(AddWorkRequest) onUpdate,
    }) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WorkDialog(
        work: work,
        onSave: onUpdate,
      );
    },
  );
}

