import 'package:flutter/material.dart';
import 'package:food_recipes_project/detail_page.dart';
import 'package:food_recipes_project/recipe.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Recipe> favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  void loadFavorites() async {
    Box box = Hive.box('favorites'); // Open your Hive box here
    List<int> favoriteIds = box.values.toList().cast<int>();
    if (favoriteIds.isEmpty) {
      setState(() => favoriteRecipes = []);
      return;
    }

    String favoriteIdsString = favoriteIds.join(',');
    String url =
        'http://localhost/recipes_app/getFavoriteRecipes.php?ids=$favoriteIdsString';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        favoriteRecipes = data.map<Recipe>((obj) {
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

  void removeFromFavorites(int recipeId) {
    Box box = Hive.box('favorites');
    box.delete(recipeId);

    // Update the local favoriteRecipes list
    setState(() {
      favoriteRecipes.removeWhere((recipe) => recipe.id == recipeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorite Recipes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00796B), // Deep Teal
          ),
        ),
        centerTitle: true,
      ),
      body: favoriteRecipes.isEmpty
          ? const Center(
        child: Text('No favorite recipes found.'),
      )
          : ListView.builder(
        itemCount: favoriteRecipes.length,
        itemBuilder: (context, index) {
          final recipe = favoriteRecipes[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(recipe: recipe,initNav: 2,),
                ),
              );
            },
            child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        Icons.favorite,
                        color: Color(0xFFFD6A00),
                      ),
                      onPressed: () => removeFromFavorites(recipe.id),
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
