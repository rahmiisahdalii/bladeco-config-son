import 'package:bladeco/screens/MyHomePage.dart';
import 'package:bladeco/screens/routerPage.dart';
import 'package:bladeco/state/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          return auth.isLoggedIn ? RouterPage() : HomePage();
        },
      ),
    );
  }
}