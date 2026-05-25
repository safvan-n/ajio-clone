import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/store_provider.dart';
import 'theme/ajio_theme.dart';
import 'screens/main_navigation.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoreProvider()),
      ],
      child: const AjioCloneApp(),
    ),
  );
}

class AjioCloneApp extends StatelessWidget {
  const AjioCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AJIO Clone',
      debugShowCheckedModeBanner: false,
      theme: AjioTheme.lightTheme,
      home: const MainNavigation(),
    );
  }
}
