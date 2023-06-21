
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/nextscreen.dart';

import 'model.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
//print(appDocumentsDir.path);

    await Hive.initFlutter();
    Hive.registerAdapter(DataAdapter());
  
  await Hive.openBox<Data>('data_box');


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:ReadScreen(),
    );
  }
}
