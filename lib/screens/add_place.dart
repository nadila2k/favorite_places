import 'package:favorite_places/providers/add_place.dart';
import 'package:favorite_places/widgets/Location_input.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:io';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _selectImage(File pickedImage) {
    _selectedImage = pickedImage;
  }

  void _savePlace() {
    final enteredTitle = _titleController.text;

    if (enteredTitle.isEmpty || _selectedImage == null) {
      return;
    }

    ref
        .read(addPlacesProvider.notifier)
        .addPlace(enteredTitle, _selectedImage!);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Place')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Place Name'),
              controller: _titleController,
            ),
            const SizedBox(height: 10),
            ImageInput(onPickImage: _selectImage),
            const SizedBox(height: 10),
            LocationInput(),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _savePlace();
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Place'),
            ),
          ],
        ),
      ),
    );
  }
}
