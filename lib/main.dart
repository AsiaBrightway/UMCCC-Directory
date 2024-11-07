import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:pahg_group/fcm/fcm_service.dart';

import 'package:provider/provider.dart' as provider;
import 'firebase_options.dart';
import 'ui/pages/splash_page.dart';
import 'ui/providers/auth_provider.dart';
import 'ui/themes/dark_mode.dart';
import 'ui/themes/light_mode.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FCMService().listenForMessages();
  runApp(
    riverpod.ProviderScope(
      child: provider.MultiProvider(
        providers: [
          provider.ChangeNotifierProvider(create: (context) => AuthProvider()),
        ],
        child: const MyApp(),
      ),
    )
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: ThemeMode.system,
      home: const SplashPage(),
    );
  }
}

