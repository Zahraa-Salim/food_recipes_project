import 'package:flutter/material.dart';
import 'package:food_recipes_project/splash_page.dart';
import 'package:food_recipes_project/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

bool isSignedIn = false;
User? user;

Future <void> main() async{
  await Hive.initFlutter();
  final box = await Hive.openBox('favorites');
  List favoriteIds = box.values.toList();
  List<int> Ids = favoriteIds.cast<int>();

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Food Recipes App',
      home:SplashPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}