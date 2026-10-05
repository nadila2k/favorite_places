import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/legacy.dart';

class AddPlacesNotifier extends StateNotifier<List<Place>> {
  AddPlacesNotifier() : super([]);

  void addPlace(String title) {
    final place = Place(title: title);
    state = [...state, place];
  }
}

final addPlacesProvider = StateNotifierProvider<AddPlacesNotifier, List<Place>>((ref) => AddPlacesNotifier());
