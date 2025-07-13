import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final _imageUrlController = TextEditingController();
  final _database = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;
  String? _errorMessage;

  Future<void> _addStory() async {
    if (_imageUrlController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter an image URL';
      });
      return;
    }
    try {
      final story = {
        'userId': _auth.currentUser!.uid,
        'imageUrl': _imageUrlController.text.trim(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      await _database.child('stories').push().set(story);
      Navigator.pop(context); // Return to home screen after posting
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Story')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'Story Image URL',
                hintText: 'Enter image URL for your story',
              ),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addStory,
              child: const Text('Post Story'),
            ),
          ],
        ),
      ),
    );
  }
}
