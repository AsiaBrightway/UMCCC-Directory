import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/pahg_model.dart';
import '../../data/vos/token_vo.dart';
import '../../data/vos/user_vo.dart';
import '../../utils/helper_functions.dart';
import '../../widgets/loading_widget.dart';
import '../providers/auth_provider.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool isSuccess = false;
  final PahgModel _pahgModel = PahgModel();

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  ///used delay await because shared preferences read and write need time.
  Future<void> userLogin() async{
      try {
        showDialog(context: context, barrierDismissible: false,builder: (context) => const LoadingWidget());
        TokenVo tokenVo = await _pahgModel.userLogin(_emailController.text.toString(),_passwordController.text.toString());
        try{
          String bearerToken = 'Bearer ${tokenVo.accessToken!}';
          UserVo? userVo = await _pahgModel.getUserById(bearerToken, tokenVo.userId!);
          saveToken(bearerToken, userVo!.userRolesId!, tokenVo.userId!);
          await Future.delayed(const Duration(milliseconds: 1000));
          subscribeToTopic();
          Navigator.of(context).pop();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
        } catch (e) {
          Navigator.of(context).pop();
          showErrorDialog(context,e.toString());
        }
      }catch(e) {
        Navigator.of(context).pop();
        if(e.toString()=='Connection') {
          showConnectionErrorDialog(context, 'Check internet connection',userLogin);
        }else {
          showErrorDialog(context,e.toString());
        }
      }
  }

  ///subscribe to topic
  Future<void> subscribeToTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic('all');
  }

  void saveToken(String token,int userRole,String userId) async{
    AuthProvider authProvider = Provider.of<AuthProvider>(context,listen: false);
    await authProvider.clearTokenAndRoleAndId();
    await authProvider.setTokenAndRoleAndUserId(token, userRole, userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                color: Colors.blue[800],
                child: Column(
                  children: [
                    ///logo and text
                    Padding(
                      padding: const EdgeInsets.only(top: 40,bottom: 5),
                      child: Image.asset(
                        'assets/pahg_logo.png', // Replace with your logo asset
                        height: 100,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Log in', style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(50))
                      ),
                    ),
                  ],
                ),
              ),
              ///email text field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onSubmitted: (_) {
                    // Move focus to the password field
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                ),
              ),
              ///Password text field
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: TextField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure ? Icons.visibility: Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure; // Toggle the visibility
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ///sign in button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: InkWell(
                  onTap: () {
                    if(_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty){
                      userLogin();
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill Email and Password'),
                        ),
                      );
                    }
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                        color: Colors.blue[700],
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16),bottomRight: Radius.circular(16))
                    ),
                    padding: const EdgeInsets.all(18),
                    child: const Center(
                      child: Text(
                        'Log in',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              //not a member register now
            ],
          ),
        ),
      ),
    );
  }
}
