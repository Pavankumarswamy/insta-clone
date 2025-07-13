
# Instagram Clone

A Flutter application that replicates core functionalities of Instagram, built with Firebase for real-time data management and authentication.

## Overview

This project is a fully functional Instagram clone developed using Flutter and Dart, integrated with Firebase Authentication and Realtime Database. It includes features such as user authentication, real-time messaging, story and post management, a searchable post grid, and follow/unfollow functionality, designed to mimic Instagram’s user experience.

## Features

- **Authentication**:
  - Login and signup with email and password.
  - User profile creation with name and profile image URL.
- **Home Screen**:
  - Displays a hero section with user stories and a scrollable feed of posts.
  - Floating Action Button (FAB) for adding new stories.
- **Search Screen**:
  - Interactive 3x3 grid of all posts with tap animations and message buttons to initiate chats with post owners.
- **Inbox Page**:
  - Lists all users who have messaged the current user, showing the latest message preview and timestamp.
  - Real-time conversation updates with tappable list items to access chats.
- **Chat Screen**:
  - Real-time user-to-user messaging with sent/received message styling.
- **Profile Screen**:
  - Displays user details and their posts in a 3x3 grid.
  - Allows post creation/deletion (own profile) and follow/unfollow other users.
- **Real-Time Data**:
  - Uses Firebase Realtime Database for live updates of stories, posts, messages, and follow status.

## Getting Started

### Prerequisites

- **Flutter SDK**: Install Flutter (version 3.0.0 or higher recommended) following the [official guide](https://docs.flutter.dev/get-started/install).
- **Firebase Account**: Create a project in the [Firebase Console](https://console.firebase.google.com/).
- **IDE**: Use Visual Studio Code, Android Studio, or any IDE with Flutter support.
- **Emulator/Device**: Set up an Android/iOS emulator or physical device for testing.

### Setup Instructions

1. **Clone the Repository**:
   ```bash
   git clone <repository-url>
   cd instagram_clone
   ```

2. **Install Dependencies**:
   Update `pubspec.yaml` with the required dependencies:
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     firebase_core: ^3.6.0
     firebase_auth: ^5.3.1
     firebase_database: ^11.1.4
     cached_network_image: ^3.4.1
   ```
   Run:
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**:
   - Create a Firebase project and enable **Email/Password Authentication**.
   - Set up **Realtime Database** with the following rules:
     ```json
     {
       "rules": {
         ".read": "auth != null",
         ".write": "auth != null"
       }
     }
     ```
   - Download `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) and place them in the appropriate directories (`android/app` or `ios/Runner`).
   - Initialize Firebase in `main.dart` (already included in the provided code).

4. **Run the App**:
   ```bash
   flutter run
   ```
   Launch the app on an emulator or device to test features like signup, story posting, messaging, and profile management.

## Project Structure

- **lib/screens/**:
  - `main.dart`: Entry point initializing Firebase and the app.
  - `splash_screen.dart`: Displays a logo for 3 seconds before navigating to the wrapper.
  - `wrapper.dart`: Routes to login or home based on authentication state.
  - `login_screen.dart`: Handles user login with email and password.
  - `signup_screen.dart`: Registers users with name, profile URL, email, and password.
  - `home_screen.dart`: Shows stories, posts, and navigation to other screens.
  - `search_screen.dart`: Displays a 3x3 grid of posts with message buttons.
  - `inbox_page.dart`: Lists conversations with latest message previews.
  - `chat_screen.dart`: Supports real-time messaging between users.
  - `profile_screen.dart`: Manages user posts and follow/unfollow actions.
  - `add_story_screen.dart`: Allows users to post stories with image URLs.

## Database Structure

- **/users/{uid}**:
  ```json
  {
    "name": "User Name",
    "profileUrl": "https://example.com/image.jpg",
    "email": "user@example.com"
  }
  ```
- **/posts/{postId}**:
  ```json
  {
    "userId": "uid",
    "imageUrl": "https://example.com/post.jpg",
    "caption": "Post caption",
    "timestamp": 1625097600000
  }
  ```
- **/stories/{storyId}**:
  ```json
  {
    "userId": "uid",
    "imageUrl": "https://example.com/story.jpg",
    "timestamp": 1625097600000
  }
  ```
- **/chats/{chatId}/{messageId}**:
  ```json
  {
    "senderId": "uid1",
    "receiverId": "uid2",
    "text": "Hello!",
    "timestamp": 1625097600000
  }
  ```
- **/following/{userId}/{followedUserId}**:
  ```json
  true
  ```

## Usage

1. **Sign Up/Login**: Create an account or log in using email and password.
2. **Home Screen**: View stories in the hero section and posts in the feed. Use the FAB to add a story.
3. **Search Screen**: Browse posts in a 3x3 grid and tap the message button to chat with the post owner.
4. **Inbox Page**: See all users who have messaged you, with the latest message and timestamp, and tap to continue the conversation.
5. **Profile Screen**: Manage your posts or view others’ profiles, with options to follow/unfollow.
6. **Chat Screen**: Send and receive messages in real-time.

## Resources

- [Flutter Documentation](https://docs.flutter.dev/): Tutorials and API reference.
- [Firebase Documentation](https://firebase.google.com/docs): Guides for authentication and Realtime Database.
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab): Beginner-friendly codelab.
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook): Practical examples for Flutter development.

## Contributing

Contributions are welcome! Please fork the repository, create a feature branch, and submit a pull request with your changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
