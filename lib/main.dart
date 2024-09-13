import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

import 'package:provider/provider.dart' as provider;
import 'ui/pages/splash_page.dart';
import 'ui/providers/auth_provider.dart';
import 'ui/themes/dark_mode.dart';
import 'ui/themes/light_mode.dart';

void main() async{
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  const SplashPage(),
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: ThemeMode.system,
    );
  }
}

