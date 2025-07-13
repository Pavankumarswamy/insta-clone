import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'inbox_page.dart'; // Updated to InboxPage
import 'search_screen.dart';
import 'profile_screen.dart';
import 'add_story_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final database = FirebaseDatabase.instance.ref();
    final currentUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram Clone'),
        actions: [
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InboxPage()), // Updated to InboxPage
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stories Hero Section
          SizedBox(
            height: 100,
            child: StreamBuilder(
              stream: database.child('stories').onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                  return const Center(child: Text('No stories available'));
                }
                final stories = Map<dynamic, dynamic>.from(
                    snapshot.data!.snapshot.value as Map<dynamic, dynamic>);
                final storyList = stories.entries
                    .map((entry) => {
                          'id': entry.key,
                          ...Map<String, dynamic>.from(entry.value),
                        })
                    .toList();

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: storyList.length,
                  itemBuilder: (context, index) {
                    final story = storyList[index];
                    return FutureBuilder(
                      future: database
                          .child('users')
                          .child(story['userId'])
                          .get()
                          .then((snapshot) => snapshot.value as Map<dynamic, dynamic>?),
                      builder: (context, AsyncSnapshot<Map<dynamic, dynamic>?> userSnapshot) {
                        final userName = userSnapshot.data?['name'] ?? 'Unknown';
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: CachedNetworkImageProvider(story['imageUrl']),
                              ),
                              Text(userName, style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          // Posts Section
          Expanded(
            child: StreamBuilder(
              stream: database.child('posts').onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                  return const Center(child: Text('No posts found'));
                }
                final posts = Map<dynamic, dynamic>.from(
                    snapshot.data!.snapshot.value as Map<dynamic, dynamic>);
                final postList = posts.entries
                    .map((entry) => {
                          'id': entry.key,
                          ...Map<String, dynamic>.from(entry.value),
                        })
                    .toList()
                  ..sort((a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));

                return ListView.builder(
                  itemCount: postList.length,
                  itemBuilder: (context, index) {
                    final post = postList[index];
                    return FutureBuilder(
                      future: database
                          .child('users')
                          .child(post['userId'])
                          .get()
                          .then((snapshot) => snapshot.value as Map<dynamic, dynamic>?),
                      builder: (context, AsyncSnapshot<Map<dynamic, dynamic>?> userSnapshot) {
                        final userName = userSnapshot.data?['name'] ?? 'Unknown';
                        final profileUrl = userSnapshot.data?['profileUrl'] ?? '';
                        return Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(profileUrl),
                                ),
                                title: Text(userName),
                              ),
                              CachedNetworkImage(
                                imageUrl: post['imageUrl'],
                                height: 300,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(post['caption'] ?? ''),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddStoryScreen()),
        ),
        child: const Icon(Icons.add_a_photo),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(userId: currentUser.uid),
              ),
            );
          }
        },
      ),
    );
  }
}