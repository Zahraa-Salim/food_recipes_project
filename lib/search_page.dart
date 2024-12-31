import 'package:flutter/material.dart';
import 'package:food_recipes_project/detail_page.dart';
import 'package:food_recipes_project/recipe.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List recipes = [];
  List<int> favoriteIds = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  void loadFavorites() {
    Box box = Hive.box('favorites');
    setState(() {
      favoriteIds = box.values.toList().cast<int>();
    });
  }

  void toggleFavorite(int recipeId) {
    Box box = Hive.box('favorites');
    setState(() {
      if (favoriteIds.contains(recipeId)) {
        box.delete(recipeId);
        favoriteIds.remove(recipeId);
      } else {
        box.put(recipeId, recipeId);
        favoriteIds.add(recipeId);
      }
    });
  }

  void searchRecipes(String name) async {
    String url = 'http://localhost/recipes_app/searchRecipes.php?name=$name';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        recipes = data.map((obj) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Container(
                width: double.infinity,
                height: 55,
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 185, 185, 185),
                      offset: Offset(1, 1),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (name) {
                    searchRecipes(name);
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search your recipe',
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            Expanded(
              child: recipes.isEmpty
                  ? const Center(
                child: Text('No recipes found.'),
              )
                  : ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  final isFavorite = favoriteIds.contains(recipe.id);
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(recipe: recipe,initNav: 1,),
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
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
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
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: const Color(0xFFFD6A00),
                              ),
                              onPressed: () => toggleFavorite(recipe.id),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
