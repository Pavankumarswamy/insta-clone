import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final database = FirebaseDatabase.instance.ref();

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: StreamBuilder(
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

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 1, // Ensures square tiles for 3x3 layout
            ),
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
                  return GestureDetector(
                    onTap: () {
                      // Scale animation on tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            receiverId: post['userId'],
                            receiverName: userName,
                          ),
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      transform: Matrix4.identity()..scale(1.0), // Default scale
                      child: Card(
                        elevation: 4,
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: post['imageUrl'],
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: IconButton(
                                icon: const Icon(Icons.message, color: Colors.white),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                        receiverId: post['userId'],
                                        receiverName: userName,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}