import 'package:flutter/material.dart';
import 'package:food_recipes_project/detail_page.dart';
import 'package:food_recipes_project/main.dart';
import 'package:food_recipes_project/recipe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyRecipesPage extends StatefulWidget {
  const MyRecipesPage({super.key});

  @override
  State<MyRecipesPage> createState() => _MyRecipesPageState();
}

class _MyRecipesPageState extends State<MyRecipesPage> {
  List myRecipes = [];

  @override
  void initState() {
    super.initState();
    loadMyRecipes();
  }

  void loadMyRecipes() async {
    String url =
        'http://localhost/recipes_app/getMyRecipes.php?id=${user?.id}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        myRecipes = data.map<Recipe>((obj) {
          return Recipe(
            id: int.parse(obj['recipe_id'].toString()),
            title: obj['title'].toString(),
            duration: int.parse(obj['duration'].toString()),
            calories: int.parse(obj['calories'].toString()),
            description: obj['description'].toString(),
            instructions: obj['instructions'].toString(),
            purpose: obj['purpose'].toString(),
            imageUrl: obj['image'].toString(),
          );
        }).toList();
      });
    }
  }

  void deleteRecipe(Recipe recipe) async {
    String url =
        'http://localhost/recipes_app/deleteRecipe.php?id=${recipe.id}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${recipe.title} has been deleted.",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFFD32F2F),
          duration: const Duration(seconds: 2),
        ),
      );
      setState(() {
        myRecipes.removeWhere((r) => r.id == recipe.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Recipes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00796B), // Deep Teal
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF00796B)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: myRecipes.isEmpty
          ? const Center(
        child: Text('No recipes found.'),
      )
          : ListView.builder(
        itemCount: myRecipes.length,
        itemBuilder: (context, index) {
          final recipe = myRecipes[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(recipe: recipe,initNav: 3,),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      child: Image.network(
                        recipe.imageUrl,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipe.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              recipe.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Color(0xFF00796B), // Updated color
                      ),
                      onPressed: () => deleteRecipe(recipe),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
