import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _database = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;
  final _postImageController = TextEditingController();
  final _captionController = TextEditingController();

  Future<void> _addPost() async {
    if (_postImageController.text.trim().isEmpty) return;
    final post = {
      'userId': _auth.currentUser!.uid,
      'imageUrl': _postImageController.text.trim(),
      'caption': _captionController.text.trim(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await _database.child('posts').push().set(post);
    _postImageController.clear();
    _captionController.clear();
  }

  Future<void> _deletePost(String postId) async {
    await _database.child('posts').child(postId).remove();
  }

  Future<void> _toggleFollow(String targetUserId) async {
    final currentUserId = _auth.currentUser!.uid;
    final followingRef = _database.child('following').child(currentUserId).child(targetUserId);
    final snapshot = await followingRef.get();
    if (snapshot.exists) {
      await followingRef.remove();
    } else {
      await followingRef.set(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOwnProfile = widget.userId == _auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: isOwnProfile
            ? [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => _auth.signOut(),
                ),
              ]
            : [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            FutureBuilder(
              future: _database.child('users').child(widget.userId).get(),
              builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                if (!snapshot.hasData || snapshot.data!.value == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                final user = Map<String, dynamic>.from(snapshot.data!.value as Map<dynamic, dynamic>);
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: CachedNetworkImageProvider(user['profileUrl'] ?? ''),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user['name'] ?? 'Unknown', style: const TextStyle(fontSize: 20)),
                          if (!isOwnProfile)
                            StreamBuilder(
                              stream: _database
                                  .child('following')
                                  .child(_auth.currentUser!.uid)
                                  .child(widget.userId)
                                  .onValue,
                              builder: (context, AsyncSnapshot<DatabaseEvent> followSnapshot) {
                                final isFollowing = followSnapshot.data?.snapshot.value != null;
                                return ElevatedButton(
                                  onPressed: () => _toggleFollow(widget.userId),
                                  child: Text(isFollowing ? 'Unfollow' : 'Follow'),
                                );
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            // Post Creation (Own Profile Only)
            if (isOwnProfile)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _postImageController,
                      decoration: const InputDecoration(labelText: 'Post Image URL'),
                    ),
                    TextField(
                      controller: _captionController,
                      decoration: const InputDecoration(labelText: 'Caption'),
                    ),
                    ElevatedButton(
                      onPressed: _addPost,
                      child: const Text('Add Post'),
                    ),
                  ],
                ),
              ),
            // Posts Grid
            StreamBuilder(
              stream: _database.child('posts').orderByChild('userId').equalTo(widget.userId).onValue,
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
                    .toList();

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: postList.length,
                  itemBuilder: (context, index) {
                    final post = postList[index];
                    return GestureDetector(
                      onLongPress: isOwnProfile
                          ? () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Post'),
                                  content: const Text('Are you sure you want to delete this post?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _deletePost(post['id']);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              )
                          : null,
                      child: CachedNetworkImage(
                        imageUrl: post['imageUrl'],
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}