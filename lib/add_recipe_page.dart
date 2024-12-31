
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_recipes_project/ingredient.dart';
import 'package:food_recipes_project/main.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  final List<Ingredient> _ingredients = [
    Ingredient(name: '', quantity: ''),
  ];

  String? _selectedPurpose;

  String? _fileName;

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name; // Original file name
        _fileName = '../images/$_fileName';
      });

    }
  }

  Future<void> addRecipe() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_fileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an image"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {

      var response = await http.post(
        Uri.parse("http://localhost/recipes_app/addRecipe.php"),
        body: {
          'title': _titleController.text,
          'description': _descriptionController.text,
          'duration': _durationController.text,
          'calories': _caloriesController.text,
          'instructions': _instructionsController.text,
          'purpose': _selectedPurpose ?? '',
          'imageName': _fileName,
          'user_id': (user?.id ?? '').toString(),
          'ingredients': _ingredients
              .map((ingredient) => '${ingredient.name}:${ingredient.quantity}')
              .join(','),
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "Recipe added successfully!"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else {
          throw Exception(jsonResponse['message']);
        }
      } else {
        throw Exception("Failed with status code ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

    void addIngredientRow() {
      setState(() {
        _ingredients.add(Ingredient(name: '', quantity: ''));
      });
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.teal,
      title: const Text('Add Recipe'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Recipe Title',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title, color: Colors.teal),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter a title' : null,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _fileName == null
                    ? const Center(
                      child: Text(
                        'Tap to select an image',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                    : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        _fileName!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description, color: Colors.teal),
                  ),
                  validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a description' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Purpose',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Breakfast', child: Text('Breakfast')),
                    DropdownMenuItem(value: 'Lunch', child: Text('Lunch')),
                    DropdownMenuItem(value: 'Dinner', child: Text('Dinner')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedPurpose = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Duration (in minutes)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.timer, color: Colors.teal),
                  ),
                  validator: (value) => value == null || value.isEmpty
                  ? 'Please enter the duration' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _caloriesController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Calories',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.local_fire_department, color: Colors.teal),
                  ),
                  validator: (value) => value == null || value.isEmpty
                  ? 'Please enter the calories' : null,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ingredients',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _ingredients.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                      child:Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Ingredient',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) => _ingredients[index].name = value,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Quantity',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) => _ingredients[index].quantity = value,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.add_circle, color: Colors.teal),
                            onPressed: addIngredientRow,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _instructionsController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Instructions',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.notes, color: Colors.teal),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please provide cooking instructions'
                      : null,
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: addRecipe,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: const Text(
                      'Save Recipe',
                      style: TextStyle(fontSize: 16,color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
