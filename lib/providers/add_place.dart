import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'dart:io';

class AddPlacesNotifier extends StateNotifier<List<Place>> {
  AddPlacesNotifier() : super([]);

  void addPlace(String title, File image) {
    final place = Place(title: title, image: image);
    state = [...state, place];
  }
}

final addPlacesProvider = StateNotifierProvider<AddPlacesNotifier, List<Place>>((ref) => AddPlacesNotifier());
