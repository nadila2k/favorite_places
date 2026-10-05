import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  LocationData? _pickedLocation;

  var _isGettingLocation = false;
Future<void> _getCurrentUserLocation() async {
  final location = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;

  serviceEnabled = await location.serviceEnabled();

  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();

    if (!serviceEnabled) {
      return;
    }
  }

  permissionGranted = await location.hasPermission();

  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();

    if (permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  setState(() {
    _isGettingLocation = true;
  });

  try {
    final locationData = await location.getLocation();

    final latitude = locationData.latitude;
    final longitude = locationData.longitude;

    if (latitude == null || longitude == null) {
      throw Exception('Could not get latitude or longitude.');
    }

    // OpenStreetMap Nominatim reverse geocoding
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse'
      '?lat=$latitude'
      '&lon=$longitude'
      '&format=json',
    );

    final response = await http.get(
      url,
      headers: {
        'User-Agent': 'FavoritePlacesFlutterApp/1.0',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to get address. Status code: ${response.statusCode}',
      );
    }

    final data = json.decode(response.body);



    final address = data['display_name'];

    setState(() {
      _pickedLocation = locationData;
    });

    print(
      'Latitude: $latitude, '
      'Longitude: $longitude, '
      'Address: $address',
    );
  } catch (error) {
    print('Error getting location: $error');
  } finally {
    if (mounted) {
      setState(() {
        _isGettingLocation = false;
      });
    }
  }
}
  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No Location Chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onSurface),
    );

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    } else if (_pickedLocation != null) {
      previewContent = Text(
        'Latitude: ${_pickedLocation!.latitude}, Longitude: ${_pickedLocation!.longitude}',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge!
            .copyWith(color: Theme.of(context).colorScheme.onSurface),
      );
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: Center(
            child: Text(
              'No Location Chosen',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentUserLocation,
              label: Text('Get Current Location'),
              icon: Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: () {},
              label: Text('Select on Map'),
              icon: Icon(Icons.map),
            ),
          ],
        ),
      ],
    );
  }
}
