Instagram Clone
A Flutter-based Instagram clone application that replicates core Instagram features, including user authentication, real-time messaging, story and post management, and follow/unfollow functionality, powered by Firebase.
Features

Splash Screen: Displays a branded logo for 3 seconds before navigating to the main app.
Authentication: 
Login and signup with email/password using Firebase Authentication.
User data (name, profile image URL, email) stored in Firebase Realtime Database.


Home Screen: 
Hero section with a horizontal list of user stories.
Vertical list of posts from all users, sorted by timestamp.
Floating Action Button (FAB) to add new stories.


Search Screen: 
Displays all posts in a 3x3 grid layout.
Interactive post cards with a message button to initiate chats with the post owner.


Inbox Page: 
Lists all users who have messaged the current user, showing the latest message and timestamp.
Real-time conversation previews with user avatars and names.


Profile Screen: 
Displays user details and their posts in a 3x3 grid.
Allows users to add or delete their own posts and follow/unfollow other users.


Chat Screen: 
Real-time user-to-user messaging with Firebase Realtime Database.


Story Creation: 
Users can add stories via an image URL, displayed in the home screen’s hero section.



Getting Started
Prerequisites

Flutter: Install Flutter (version 3.0.0 or higher) following the official guide.
Firebase Account: Create a project in the Firebase Console.
IDE: Use Visual Studio Code, Android Studio, or another IDE with Flutter support.

Setup Instructions

Clone the Repository:
git clone <repository-url>
cd instagram_clone


Install Dependencies:Ensure the following dependencies are in pubspec.yaml:
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  firebase_database: ^11.1.4
  cached_network_image: ^3.4.1

Run:
flutter pub get


Configure Firebase:

In the Firebase Console, create a new project and enable Email/Password Authentication.
Enable Realtime Database and set rules:{
  "rules": {
    ".read": "auth != null",
    ".write": "auth != null"
  }
}


Download google-services.json (Android) or GoogleService-Info.plist (iOS) and place them in the appropriate project directories (android/app/ or ios/Runner/).
Initialize Firebase in main.dart (already included in the provided code).


Run the App:
flutter run

Ensure a device or emulator is connected.


Project Structure
lib/
├── screens/
│   ├── splash_screen.dart      # Splash screen with logo
│   ├── wrapper.dart           # Routes based on auth state
│   ├── login_screen.dart      # Email/password login
│   ├── signup_screen.dart     # User registration
│   ├── home_screen.dart       # Stories, posts, and FAB
│   ├── search_screen.dart     # 3x3 post grid with message buttons
│   ├── inbox_page.dart        # Conversation list with latest messages
│   ├── chat_screen.dart       # Real-time messaging
│   ├── profile_screen.dart    # User profile and post management
│   ├── add_story_screen.dart  # Story creation
├── main.dart                  # App entry point

Firebase Database Structure

/users/{uid}: Stores user data (name, profileUrl, email).
/posts/{postId}: Stores post data (userId, imageUrl, caption, timestamp).
/stories/{storyId}: Stores story data (userId, imageUrl, timestamp).
/chats/{chatId}/{messageId}: Stores messages (senderId, receiverId, text, timestamp).
/following/{userId}/{followedUserId}: Tracks follow relationships (boolean).

Usage

Sign Up/Login: Create an account or log in using email and password.
Home Screen: View stories and posts, use the FAB to add a story.
Search Screen: Browse posts in a 3x3 grid, tap the message button to chat with a post’s owner.
Inbox Page: See all conversations with the latest message and timestamp, tap to continue chatting.
Profile Screen: Manage your posts or follow/unfollow other users.

Contributing
Contributions are welcome! Please submit a pull request or open an issue for bugs, features, or improvements.
Resources

Flutter Documentation: Tutorials and API reference.
Firebase Documentation: Guides for Authentication and Realtime Database.
Lab: Write your first Flutter app: Beginner tutorial.
Cookbook: Useful Flutter samples: Practical examples.

License
This project is licensed under the MIT License.
