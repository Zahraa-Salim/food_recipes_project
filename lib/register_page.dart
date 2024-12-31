import 'package:flutter/material.dart';
import 'package:food_recipes_project/account_page.dart';
import 'package:food_recipes_project/main.dart';
import 'package:food_recipes_project/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  Future register() async {
    var url = "http://localhost/recipes_app/register.php";
    var response = await http.post(Uri.parse(url), body: {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "cpassword": confirmPasswordController.text.trim()
    });
    emailController.text = "";
    passwordController.text = "";
    nameController.text = "";
    confirmPasswordController.text = "";
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      if(data==0){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registration Failed",style: TextStyle(color: Colors.white),),
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
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountPage(),),);
      }
    } else {
      emailController.text = "";
      passwordController.text = "";
      nameController.text = "";
      confirmPasswordController.text = "";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registration Failed",style: TextStyle(color: Colors.white),),
          backgroundColor: const Color(0xFFD32F2F),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40,),
            Icon(
              Icons.lock_outline,
              size: 80,
              color: Colors.teal,
            ),
            SizedBox(height: 20),
            Text(
              'Create a New Account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Name',
                prefixIcon: Icon(Icons.person, color: Colors.teal),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                register();
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
                'Sign Up',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "You already has an account? ",
                  style: TextStyle(color: Colors.teal[700]),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Login',
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
