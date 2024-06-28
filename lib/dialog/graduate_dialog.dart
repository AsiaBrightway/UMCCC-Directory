
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pahg_group/data/vos/graduate_vo.dart';
import 'package:pahg_group/data/vos/request_body/add_graduate_request.dart';
import 'package:pahg_group/ui/themes/colors.dart';

class GraduateDialog extends StatefulWidget {
  const GraduateDialog({super.key, this.graduate, required this.onSave});
  final GraduateVo? graduate;
  final Function(AddGraduateRequest) onSave;
  @override
  State<GraduateDialog> createState() => _GraduateDialogState();
}

class _GraduateDialogState extends State<GraduateDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _degreeTypeController;
  String? receivedYear;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.graduate?.university ?? '');
    if(widget.graduate != null){
      receivedYear = widget.graduate?.receivedYear ?? '';
    }else{
      receivedYear = DateFormat("yyyy-MM-dd").format(DateTime.now());

    }
    _degreeTypeController = TextEditingController(text: widget.graduate?.degreeType ?? '');
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
        receivedYear = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.graduate == null ? 'Add Graduate' : 'Update Graduate'),
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
                      labelText: 'university',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a university';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _degreeTypeController,
                  decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: colorAccent),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13),
                      labelText: 'degree type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text("From :$receivedYear",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13)),
                    const SizedBox(width: 4),
                    GestureDetector(
                        onTap: (){ _selectStartDate(context); },
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
          child: Text(widget.graduate == null ? 'Add' : 'Update'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              ///data should be null if user doesn't add date.the exception can found when the date is empty string
              ///employeeId is null if add school
              AddGraduateRequest updatedGraduate = AddGraduateRequest(
                  widget.graduate?.id!,
                  widget.graduate?.employeeId,
                  _nameController.text,
                  _degreeTypeController.text,
                  receivedYear
              );
              // Pass the updated school to the onUpdate callback
              widget.onSave(updatedGraduate);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

///first trigger dialog and then implement ui
Future<void> showGraduateDialog(
    BuildContext context, {
      GraduateVo? graduate,
      required Function(AddGraduateRequest) onSave,
    }) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return GraduateDialog(
        graduate: graduate,
        onSave: onSave,
      );
    },
  );
}

