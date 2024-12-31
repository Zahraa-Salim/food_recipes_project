# Food Recipes Project

## Overview
The **Food Recipes Project** is a Flutter-based mobile application that allows users to browse, search, and manage food recipes conveniently. The app is designed with a user-friendly interface and includes features such as recipe categorization, favoriting, and user authentication. Logged-in users can add their own recipes, which will be displayed to other users in the app.

## Features

### 1. Browse Recipes
- View a variety of recipes categorized into **Breakfast**, **Lunch**, and **Dinner**.
- Each recipe includes details such as title, description, ingredients, and instructions.

### 2. Search Functionality
- Search for recipes by name or ingredients.
- Refine searches by selecting categories (e.g., Breakfast, Lunch, or Dinner).

### 3. Favorite Recipes
- Users can favorite recipes for quick access.
- Favorites are stored locally using **Flutter Hive**, allowing offline access to favorite recipes.

### 4. User Authentication
- **Sign Up**: New users can create an account with a username and password.
- **Log In**: Existing users can log in to manage their recipes and favorites.

### 5. Add Recipes
- Logged-in users can create and submit new recipes with the following details:
  - Title
  - Description
  - Ingredients
  - Cooking Instructions
  - Duration
  - Calories
  - Purpose (Breakfast, Lunch, Dinner)
  - Image
- Submitted recipes are displayed to other users in the app.

### 6. Manage My Recipes
- Logged-in users can view all the recipes they’ve added.
- Update or delete their recipes as needed.

## Technical Details

### Frontend
- **Framework**: Flutter (Dart)
- **Local Storage**: Hive (for offline storage of favorite recipes)

### Backend
- **API**: Built with PHP and MySQL
- **Database**:
  - `users` table: Manages user authentication.
  - `recipes` table: Stores recipe details (title, description, ingredients, etc.).
  - `ingredients` table: Stores ingredients with their associated recipe IDs.

### Features Summary
| Feature             | Logged-out User | Logged-in User |
|---------------------|-----------------|----------------|
| Browse Recipes      | ✓               | ✓              |
| Search Recipes      | ✓               | ✓              |
| Favorite Recipes    | ✓ (Local Only) | ✓              |
| Add Recipes         | ✗               | ✓              |
| View My Recipes     | ✗               | ✓              |

## Installation Guide

### Prerequisites
- Flutter SDK installed on your system
- Android Studio or Visual Studio Code for development
- PHP and MySQL server (e.g., XAMPP) for the backend

### Steps
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-repo/food_recipes_project.git
   ```

2. **Set Up the Backend**:
   - Place the backend PHP files in the server directory (e.g., XAMPP's `htdocs`).
   - Import the provided SQL file into your MySQL database.
   - Update API URLs in the Flutter app to point to your backend server.

3. **Run the Application**:
   - Open the project in your Flutter IDE.
   - Run the `pub get` command to fetch dependencies:
     ```bash
     flutter pub get
     ```
   - Start the app using:
     ```bash
     flutter run
     ```

## Future Enhancements
- Add user profiles and social login options.
- Enable image upload and handling on the backend.
- Implement advanced search filters (e.g., by ingredient, calorie range).
- Include dietary tags (e.g., Vegan, Gluten-Free) for recipes.

## License
This project is open-source and licensed under the MIT License.

## Acknowledgments
- **Flutter**: For enabling cross-platform mobile app development.
- **Hive**: For providing a lightweight and efficient local database solution.
- **PHP & MySQL**: For powering the backend of this application.
