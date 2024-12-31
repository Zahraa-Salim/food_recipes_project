import 'package:flutter/material.dart';
import 'package:food_recipes_project/main.dart';
import 'package:food_recipes_project/navigation.dart';
import 'package:food_recipes_project/register_page.dart';
import 'package:food_recipes_project/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future login() async {
    var url = "http://localhost/recipes_app/signin.php";
    var response = await http.post(Uri.parse(url), body: {
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
    });
    emailController.text = "";
    passwordController.text = "";
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if(data==0){
        emailController.text = "";
        passwordController.text = "";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login Failed",style: TextStyle(color: Colors.white),),
            backgroundColor: const Color(0xFFD32F2F),
            duration: const Duration(seconds: 2),
          ),
        );
      }else {
        setState(() {
          isSignedIn = true;
          user = User(
            id: int.parse(data[0]['user_id'].toString()), // Access and parse correctly
            name: data[0]['name'].toString(), // Access name directly
          );
        });
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Navigation(initialIndex: 3,),),);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login Failed",style: TextStyle(color: Colors.white),),
          backgroundColor: const Color(0xFFD32F2F),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Logo or Title
            Icon(
              Icons.lock_outline,
              size: 80,
              color: Colors.teal,
            ),
            SizedBox(height: 20),
            Text(
              'Access Your Account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            SizedBox(height: 40),
            // Email TextField
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(Icons.email, color: Colors.teal),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            // Password TextField
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: Icon(Icons.lock, color: Colors.teal),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 30),
            // Login Button
            ElevatedButton(
              onPressed: () {
                login();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 80),
              ),
              child: Text(
                'Login',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            // Redirect to Register Page
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(color: Colors.teal[700]),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: const Color(0xFFFF9800),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
