import 'package:flutter/material.dart';
import 'package:food_recipes_project/add_recipe_page.dart';
import 'package:food_recipes_project/favorite_page.dart';
import 'package:food_recipes_project/login_page.dart';
import 'package:food_recipes_project/main.dart';
import 'package:food_recipes_project/my_recipes_page.dart';

class AccountPage extends StatefulWidget {
  AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isSignedIn
          ? _signedIn(context)
          : LoginPage(),
    );
  }

  Widget _signedIn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back Icon

        const SizedBox(height: 70),
        // Profile Section
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.teal,
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Welcome, ${user?.name}!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        // Options List
        Expanded(
          child: ListView(
            children: [
              // Add Recipe (Special Item)
              ListTile(
                leading: const Icon(Icons.add_circle_outline, color: Colors.orange),
                title: const Text(
                  "Add Recipe",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddRecipePage(),
                    ),
                  );
                },
              ),
              const Divider(),
              // My Recipes
              ListTile(
                leading: const Icon(Icons.book, color: Colors.grey),
                title: const Text("My Recipes"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyRecipesPage(),
                    ),
                  );
                },
              ),
              const Divider(),
              // Favorites
              ListTile(
                leading: const Icon(Icons.favorite_border, color: Colors.grey),
                title: const Text("Favorites"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoritePage(),
                    ),
                  );
                },
              ),
              const Divider(),
              // Settings
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.grey),
                title: const Text("Settings"),
                onTap: () {

                },
              ),
              const Divider(),
              // Logout
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text("Logout"),
                onTap: () {
                  setState(() {
                    isSignedIn = false;
                    user = null;
                  });
                  Navigator();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
