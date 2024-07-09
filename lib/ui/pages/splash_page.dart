import 'package:flutter/material.dart';
import 'package:pahg_group/data/models/pahg_model.dart';
import 'package:pahg_group/data/vos/user_vo.dart';
import 'package:pahg_group/ui/pages/home_page.dart';
import 'package:pahg_group/ui/pages/login_page.dart';
import 'package:pahg_group/ui/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../exception/helper_functions.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final PahgModel _pahgModel = PahgModel();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _checkLoginStatus());
  }

  Future<void> _checkLoginStatus() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context,listen: false);
    await Provider.of<AuthProvider>(context,listen: false).loadTokenAndRoleAndId();
    String userId = authProvider.userId;
    String token = authProvider.token;

    ///token မရှိရင် login ,network call fail ရင် login
    if (token.isNotEmpty && userId.isNotEmpty) {
      String bearerToken = token;
        _pahgModel.getUserById(bearerToken, userId).then((response){
          if(response != null){
            UserVo userData = response ;
            authProvider.setTokenAndRoleAndUserId( bearerToken, userData.userRolesId ?? 0, userId);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  const HomePage()));
          }else {
            showErrorDialog(context, 'No record found!');
          }
        }).catchError((error){
          switch(error.toString()){
            case 'Unauthorized':
              showUnauthorizedDialog(context, 'Access Token Timeout.\nPlease login Again!');
              break;
            case 'Connection Error':
              showConnectionErrorDialog(context, 'Check your internet connection.',_checkLoginStatus);
              break;
            default :
              ///error ကို toString မပြောင်းရင် exception တက်
              showConnectionErrorDialog(context, error.toString(), _checkLoginStatus);
              break;
          }
        });
    } else {
      // Token does not exist, navigate to login page
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage(),));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/pahg_logo.png',width: 140,height: 140,),
            const SizedBox(height: 16,),
            const Text('P A H G',style: TextStyle(
             color: Colors.orange,
             fontSize: 26,
              fontWeight: FontWeight.w600
            ))
          ],
        ),
      ),
    );
  }
}