
import 'package:flutter/material.dart';
import 'package:pahg_group/data/vos/language_vo.dart';
import 'package:pahg_group/data/vos/request_body/add_language_request.dart';
import 'package:pahg_group/ui/themes/colors.dart';

class LanguageDialog extends StatefulWidget {
  const LanguageDialog({super.key, this.language, required this.onSave});
  final LanguageVo? language;
  final Function(AddLanguageRequest) onSave;
  @override
  State<LanguageDialog> createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  int? proficiency;
  bool canTeach = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.language?.name ?? '');
    if(widget.language != null){
      proficiency = widget.language!.proficiency;
      canTeach = widget.language!.teach!;
    }
  }

  _handleProficiency(int? value){
    setState(() {
      proficiency = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.language == null ? 'Add Language' : 'Update Language'),
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
                      labelText: 'language name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a language';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Text('Normal',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 12),),
                    Expanded(
                      child: Radio(
                        value: 1,
                        groupValue: proficiency,
                        activeColor: colorAccent,
                        onChanged: _handleProficiency,
                      ),
                    ),
                    const Text('Good',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 12)),
                    Expanded(
                      child: Radio(
                        value: 2,
                        groupValue: proficiency,
                        activeColor: colorAccent,
                        onChanged: _handleProficiency,
                      ),
                    ),
                    const Text('Advanced',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 12)),
                    Expanded(
                      child: Radio(
                          value: 3,
                          groupValue: proficiency,
                          onChanged: _handleProficiency),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Text("Can Teach and Share",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 12),),
                    Checkbox(
                      value: canTeach,
                      activeColor: Colors.green,
                      onChanged: (value){
                        setState(() {
                          canTeach = value!;
                        });
                      },
                    )
                  ],
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
          child: Text(widget.language == null ? 'Add' : 'Update'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              ///data should be null if user doesn't add date.the exception can found when the date is empty string
              ///employeeId is null if add school
              AddLanguageRequest updatedGraduate = AddLanguageRequest(
                  widget.language?.id!,
                  widget.language?.employeeId,
                  _nameController.text,
                  proficiency,
                  canTeach
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
Future<void> showLanguageDialog(
    BuildContext context, {
      LanguageVo? language,
      required Function(AddLanguageRequest) onSave,
    }) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return LanguageDialog(
        language: language,
        onSave: onSave,
      );
    },
  );
}

