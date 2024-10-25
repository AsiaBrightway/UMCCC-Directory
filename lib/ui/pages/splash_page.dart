import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../data/models/pahg_model.dart';
import '../../data/vos/user_vo.dart';
import '../../fcm/fcm_service.dart';
import '../../utils/helper_functions.dart';
import '../providers/auth_provider.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'news_feed_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final PahgModel _pahgModel = PahgModel();
  bool _isNotificationLaunch = false;
  String? _postId;

  @override
  void initState() {
    super.initState();
    FCMService().setUpInteractMessage(onMessageOpenedApp: _handleNotificationRouting);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus();
    });
  }

  /// Handle routing if the app is launched from a notification click
  void _handleNotificationRouting(RemoteMessage message) {
    setState(() {
      _isNotificationLaunch = true;  // Mark that we are handling a notification
      _postId = message.data['post_id'];  // Capture post ID from the notification
    });
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

            // Check if the app was launched via a notification and navigate accordingly
            if (_isNotificationLaunch && _postId != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => NewsFeedPage(categoryId: int.parse(_postId!), categoryName: 'Name')),
              );
            } else {
              // Regular launch, go to home page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            }
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
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