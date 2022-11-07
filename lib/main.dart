
import 'package:ban_name/services/socket.dart';
import 'package:flutter/material.dart';

import 'package:ban_name/pages/home.dart';
import 'package:ban_name/pages/status.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
       ChangeNotifierProvider(create: (_) => Socket())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'home': ((_) => HomePage()),
          'status': ((_) => StatusPage())
        },
      ),
    );
  }
}