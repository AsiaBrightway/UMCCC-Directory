
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pahg_group/data/vos/education_school_vo.dart';
import 'package:pahg_group/data/vos/request_body/add_school_request.dart';
import 'package:pahg_group/ui/themes/colors.dart';
import 'package:pahg_group/utils/utils.dart';

class SchoolDialog extends StatefulWidget {
  const SchoolDialog({super.key, this.school, required this.onSave});
  final EducationSchoolVo? school;
  final Function(AddSchoolRequest) onSave;
  @override
  State<SchoolDialog> createState() => _SchoolDialogState();
}

class _SchoolDialogState extends State<SchoolDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _maximumAchievementController;
  late TextEditingController _secondaryController;
  late TextEditingController _subjectController;
  String? startDate;
  String? endDate;

  @override
  void initState() {
    super.initState();
     _nameController = TextEditingController(text: widget.school?.name ?? '');
     if(widget.school != null){
       startDate = Utils.getFormattedDate(widget.school?.fromDate);
       endDate = Utils.getFormattedDate(widget.school?.toDate);
     }else{
       startDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
       endDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
     }
     _secondaryController = TextEditingController(text: widget.school?.secondary ?? '');
     _maximumAchievementController = TextEditingController(text: widget.school?.maximumAchievement ?? '');
     _subjectController = TextEditingController(text: widget.school?.subjects ?? '');
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
      title: Text(widget.school == null ? 'Add School' : 'Update School'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: _formKey,
            child: ListBody(
              children: <Widget>[
                const SizedBox(height: 4),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: colorAccent),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13),
                      labelText: 'School',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a school';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _secondaryController,
                  decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: colorAccent),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13),
                      labelText: 'Secondary',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _maximumAchievementController,
                  decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: colorAccent),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13),
                      labelText: 'Maximum Achievements',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _subjectController,
                  decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: colorAccent),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13),
                      labelText: 'Subjects',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text("From : $startDate",style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13)),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: (){ _selectStartDate(context); },
                        child: const Icon(Icons.edit_calendar,color: colorAccent,)
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text("To : $endDate",style: const TextStyle(fontWeight: FontWeight.w300)),
                    const SizedBox(width: 4),
                    GestureDetector(
                        onTap: () async{
                          _selectEndDate(context);
                        },
                        child: const Icon(Icons.edit_calendar,color: colorAccent,)
                    )
                  ],
                ),
                const SizedBox(height: 12),
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
          child: Text(widget.school == null ? 'Add' : 'Update'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              ///data should be null if user doesn't add date.the exception can found when the date is empty string
              ///employeeId is null if add school and then change in fragment because null can lead to exception
              AddSchoolRequest updatedSchool = AddSchoolRequest(
                  widget.school?.id, // Use existing ID for update, null for add
                  widget.school?.employeeId,
                  _nameController.text,
                  startDate,
                  endDate,
                  _secondaryController.text,
                  _maximumAchievementController.text,
                  _subjectController.text
              );
              // Pass the updated school to the onUpdate callback
              widget.onSave(updatedSchool);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

Future<void> showSchoolDialog(
    BuildContext context, {
      EducationSchoolVo? school,
      required Function(AddSchoolRequest) onSave,
    }) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return SchoolDialog(
        school: school,
        onSave: onSave,
      );
    },
  );
}

