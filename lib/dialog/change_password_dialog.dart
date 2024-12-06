
import 'package:flutter/material.dart';
import 'package:pahg_group/data/models/pahg_model.dart';
import 'package:pahg_group/data/vos/request_body/path_user_request.dart';
import 'package:pahg_group/utils/helper_functions.dart';
import 'package:pahg_group/ui/pages/login_page.dart';
import 'package:pahg_group/ui/themes/colors.dart';
import 'package:provider/provider.dart';

import '../ui/providers/auth_provider.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _confirmObscure = true;
  String _token = "";
  String _userId = "";
  final PahgModel model = PahgModel();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _initializeData());
  }

  Future<void> _initializeData() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    _token = authModel.token;
    _userId = authModel.userId;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter your new password',style: TextStyle(fontFamily: 'Ubuntu')),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 9.0),
                child: Text('Your new password should contain names and numbers.',style: TextStyle(fontWeight: FontWeight.w400),),
              ),
              Form(
                key: _formKey,
                child: ListBody(
                  children: <Widget>[
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                          floatingLabelStyle: const TextStyle(color: colorAccent),
                          labelStyle: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13),
                          labelText: 'new password',
                          suffixIcon: IconButton(
                            icon: Icon( _isObscure? Icons.visibility: Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure; // Toggle the visibility
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          )
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _confirmController,
                      obscureText: _confirmObscure,
                      decoration: InputDecoration(
                          floatingLabelStyle: const TextStyle(color: colorAccent),
                          labelStyle: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13),
                          labelText: 'confirm password',
                          suffixIcon: IconButton(
                            icon: Icon( _confirmObscure? Icons.visibility: Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _confirmObscure = !_confirmObscure; // Toggle the visibility
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          )
                      ),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'New password and confirm do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ],
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // <-- Radius
              ),
            ),
            onPressed: (){
              if(_formKey.currentState!.validate() && _passwordController.text == _confirmController.text){
                PathUserRequest request = PathUserRequest("/Password", "replace", _passwordController.text);
                model.changeUserInfo(_token,_userId, request).then((onValue){
                  AuthProvider authProvider = Provider.of<AuthProvider>(context,listen: false);
                  authProvider.clearTokenAndRoleAndId();
                  unsubscribeFromTopic();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                      (Route<dynamic> route) => false);
                }).catchError((onError){
                  showErrorDialog(context, onError.toString());
                });
              }
            },
            child: const Text('Ok',style: TextStyle(color: Colors.white),))
      ],
    );
  }
}

///first trigger dialog and then implement ui
Future<void> showChangePasswordDialog(
    BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return const ChangePasswordDialog();
    },
  );
}

