import 'package:auth/model/userId.dart';
import 'package:auth/screens/wrapper.dart';
import 'package:auth/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:auth/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Userid?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
