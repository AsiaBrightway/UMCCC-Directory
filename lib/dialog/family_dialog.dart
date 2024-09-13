import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pahg_group/data/vos/request_body/add_family_request.dart';
import 'package:pahg_group/ui/themes/colors.dart';

import '../data/vos/family_vo.dart';

class FamilyDialog extends StatefulWidget {
  const FamilyDialog({super.key, required this.onSave, this.family});

  final FamilyVo? family;
  final Function(AddFamilyRequest) onSave;

  @override
  State<FamilyDialog> createState() => _FamilyDialogState();
}

class _FamilyDialogState extends State<FamilyDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _raceController;
  late TextEditingController _identityNumberController;
  late TextEditingController _employmentController;
  late TextEditingController _rankController;
  late TextEditingController _ministryController;
  late TextEditingController _relationShipController;
  String? birthDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.family?.name ?? '');
    _rankController = TextEditingController(text: widget.family?.rank ?? '');
    _raceController = TextEditingController(text: widget.family?.race ?? '');
    _identityNumberController =
        TextEditingController(text: widget.family?.identityNumber ?? '');
    _employmentController =
        TextEditingController(text: widget.family?.employment ?? '');
    _ministryController =
        TextEditingController(text: widget.family?.ministryAndCompany ?? '');
    _relationShipController =
        TextEditingController(text: widget.family?.relationship ?? '');
    if (widget.family != null) {
      birthDate = widget.family!.dateOfBirth;
    } else {
      birthDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    }
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        birthDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.family == null ? 'Add Family' : 'Update Family'),
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
                  controller: _nameController,
                  decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: colorAccent),
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 13),
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )),
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
                  controller: _relationShipController,
                  decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: colorAccent),
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 13),
                      labelText: 'Relationship',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _identityNumberController,
                  decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: colorAccent),
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 13),
                      labelText: 'Identity number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text("Birth Date :$birthDate",
                        style: const TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 13)),
                    const SizedBox(width: 6),
                    GestureDetector(
                        onTap: () {
                          _selectBirthDate(context);
                        },
                        child: const Icon(
                          Icons.edit_calendar,
                          color: colorAccent,
                        ))
                  ],
                ),
                const SizedBox(height: 12),

                ///race time text field
                TextFormField(
                  controller: _raceController,
                  decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: colorAccent),
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 13),
                      labelText: 'Race',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _rankController,
                  decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: colorAccent),
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 13),
                      labelText: 'Rank',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _employmentController,
                  decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: colorAccent),
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 13),
                      labelText: 'Employment',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _ministryController,
                  decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: colorAccent),
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 13),
                      labelText: 'Ministry',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )),
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
          child: Text(widget.family == null ? 'Add' : 'Update'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              ///data should be null if user doesn't add date.the exception can found when the date is empty string
              ///employeeId is null if add
              AddFamilyRequest updatedFamily = AddFamilyRequest(
                  widget.family?.id!,
                  widget.family?.employeeId!,
                  _nameController.text,
                  birthDate,
                  _raceController.text,
                  _identityNumberController.text,
                  _employmentController.text,
                  _rankController.text,
                  _ministryController.text,
                  _relationShipController.text);
              // Pass the updated school to the onUpdate callback
              widget.onSave(updatedFamily);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

///first trigger dialog and then implement ui
Future<void> showFamilyDialog(
  BuildContext context, {
  FamilyVo? family,
  required Function(AddFamilyRequest) onUpdate,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return FamilyDialog(
        family: family,
        onSave: onUpdate,
      );
    },
  );
}
