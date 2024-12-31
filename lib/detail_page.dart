import 'package:flutter/material.dart';
import 'package:food_recipes_project/ingredient.dart';
import 'package:food_recipes_project/navigation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:food_recipes_project/recipe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailPage extends StatefulWidget {
  final Recipe recipe;
  final int initNav;

  const DetailPage({super.key, required this.recipe, required this.initNav});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List ingredients = [];

  @override
  void initState() {
    super.initState();
    loadIngredients();
  }

  void loadIngredients() async {
    String url =
        'http://localhost/recipes_app/getIngredients.php?id=${widget.recipe.id}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        ingredients = data.map<Ingredient>((obj) {
          return Ingredient(
            name: obj['ingredient'].toString(),
            quantity: obj['quantity'].toString(),
          );
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritesBox = Hive.box('favorites');
    final isFavorite = favoritesBox.get(widget.recipe.id) != null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background image
          Container(
            height: MediaQuery.of(context).size.height / 2.1,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.recipe.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Back button
          Positioned(
            top: 40,
            left: 10,
            child: CircleAvatar(
              radius: 23,
              backgroundColor: Colors.white,
              child:IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.teal,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Navigation(initialIndex: widget.initNav),
                    ),
                  );
                },
              ),
            ),
          ),
          // DraggableScrollableSheet
          DraggableScrollableSheet(
            initialChildSize: 0.6, // Starting height
            minChildSize: 0.5, // Minimum height
            maxChildSize: 0.8, // Maximum height
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Title and Favorite Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.recipe.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: const Color(0xFFFD6A00), // Darker red color
                            ),
                            onPressed: () {
                              setState(() {
                                if (isFavorite) {
                                  favoritesBox.delete(widget.recipe.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "${widget.recipe.title} removed from favorites!",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      duration: const Duration(seconds: 1),
                                      backgroundColor: const Color(0xFFD32F2F),
                                    ),
                                  );
                                } else {
                                  favoritesBox.put(widget.recipe.id,
                                      widget.recipe.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "${widget.recipe.title} added to favorites!",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      duration: const Duration(seconds: 1),
                                      backgroundColor: const Color(0xFF388E3C),
                                    ),
                                  );
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Description
                      Text(
                        widget.recipe.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Calories and Duration
                      Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            size: 20,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "${widget.recipe.calories} Cal",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const Text(
                            " · ",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.grey,
                            ),
                          ),
                          const Icon(
                            Icons.access_time,
                            size: 20,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "${widget.recipe.duration} Min",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Ingredients
                      const Text(
                        "Ingredients",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: ingredients.length,
                          itemBuilder: (context, index) {
                            final ingredient = ingredients[index];
                            return Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ingredient.name,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    ingredient.quantity,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Instructions
                      const Text(
                        "Instructions",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.recipe.instructions,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
