import 'package:flutter/material.dart';
import 'package:pahg_group/ui/pages/splash_page.dart';
import 'package:pahg_group/ui/providers/auth_provider.dart';
import 'package:pahg_group/ui/themes/dark_mode.dart';
import 'package:pahg_group/ui/themes/light_mode.dart';
import 'package:provider/provider.dart';

void main() async{
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: const MyApp(),
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
