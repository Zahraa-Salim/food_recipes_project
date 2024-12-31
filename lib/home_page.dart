import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:food_recipes_project/recipe.dart';
import 'package:food_recipes_project/detail_page.dart';
import 'package:food_recipes_project/account_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> category = ['All', 'Breakfast', 'Lunch', 'Dinner'];
  List<Recipe> displayedRecipes = [];
  List<Recipe> allRecipes = [];
  int categoryIndex = 0;

  @override
  void initState() {
    super.initState();
    loadAllRecipes();
  }

  void loadAllRecipes() async {
    const url = 'http://localhost/recipes_app/getRecipes.php';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        allRecipes = data.map<Recipe>((obj) {
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
        getDisplayedRecipes();
      });
    }
  }

  void getDisplayedRecipes() {
    switch (categoryIndex) {
      case 0:
        setState(() => displayedRecipes = allRecipes);
        break;
      case 1:
        setState(() => displayedRecipes = allRecipes
            .where((recipe) => recipe.purpose == 'Breakfast')
            .toList());
        break;
      case 2:
        setState(() => displayedRecipes = allRecipes
            .where((recipe) => recipe.purpose == 'Lunch')
            .toList());
        break;
      case 3:
        setState(() => displayedRecipes = allRecipes
            .where((recipe) => recipe.purpose == 'Dinner')
            .toList());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30), // Increased vertical padding
                decoration: BoxDecoration(
                  color: const Color(0xFFB2DFDB), // Light Teal
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Ensure the column wraps its content
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.restaurant_menu,
                          color: Color(0xFF00796B), // Deep Teal
                          size: 40,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Explore the Best Recipes',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00796B), // Deep Teal
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15), // Added space between rows
                    const Text(
                      'Discover a variety of recipes tailored to your taste. Whether you’re looking for breakfast, lunch, or dinner ideas!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF3C444C), // Dark Gray
                      ),
                    ),

                    const SizedBox(height: 20), // Space before the button
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00796B), // Deep Teal
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20 ), // Adjusted button padding
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccountPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Add Recipe',
                          style: TextStyle(
                            color: Colors.white, // White text color
                            fontSize: 14, // Slightly smaller font size
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(15, 30, 15, 10),
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF3C444C), // Dark Gray
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: category.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            categoryIndex = index;
                            getDisplayedRecipes();
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            left: index == 0 ? 15 : 10,
                            right: index == category.length - 1 ? 15 : 0,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: categoryIndex == index
                                ? const Color(0xFFFF9800) // Bright Orange
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              category[index],
                              style: TextStyle(
                                fontSize: 16,
                                color: categoryIndex == index
                                    ? Colors.white
                                    : const Color(0xFF3C444C), // Dark Gray
                              ),
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
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Text(
                'Browse Recipes',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF3C444C), // Dark Gray
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: Hive.box('favorites').listenable(),
            builder: (context, box, child) {
              return SliverPadding(
                padding: const EdgeInsets.only(left: 15, right: 5),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.78,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final recipe = displayedRecipes[index];
                      final isFavorite = box.get(recipe.id) != null;
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context, MaterialPageRoute(
                                  builder: (context) =>DetailPage(recipe: recipe,initNav: 0,),
                                  ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 230,
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              recipe.imageUrl,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        recipe.title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.local_fire_department,
                                            size: 16,
                                            color: Color(0xFFFF9800),
                                          ),
                                          Text(
                                            "${recipe.calories} Cal",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const Text(" · ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const Icon(
                                            Icons.access_time,
                                            size: 16,
                                            color: Color(0xFF00796B),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            "${recipe.duration} Min",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // for favorite button
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.white,
                                      child: InkWell(
                                        onTap: () async {
                                          ScaffoldMessenger.of(context).clearSnackBars();
                                          if (isFavorite) {
                                            await box.delete(recipe.id);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "${recipe.title} removed from favorites!",
                                                  style: const TextStyle(color: Colors.white),
                                                ),
                                                duration: Duration(seconds: 1),
                                                backgroundColor: const Color(0xFFD32F2F), // Red
                                              ),
                                            );
                                          } else {
                                            await box.put(recipe.id, recipe.id);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "${recipe.title} added to favorites!",
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                                duration: Duration(seconds: 1),
                                                backgroundColor: Color(0xFF43BD49), // Green
                                              ),
                                            );
                                          }
                                        },
                                        child: Icon(
                                          isFavorite ? Icons.favorite : Icons.favorite_border,
                                          color: const Color(0xFFFD6A00), // Darker red color
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    childCount: displayedRecipes.length,
                  ),
                ),
              );
            }
          ),
        ]
      ),
    );
  }
}
