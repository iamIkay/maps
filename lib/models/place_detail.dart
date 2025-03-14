import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PlaceDetails {
  final String placeId;

  final String address;

  PlaceDetails({required this.placeId, required this.address});

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    return PlaceDetails(
      placeId: json['place_id'],
      address: json['formatted_address'],
    );
  }
}

Future<PlaceDetails> getPlaceDetails(double lat, double lng) async {
  final url = Uri.parse(
    'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=${dotenv.get("API_KEY")}',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['status'] == 'OK') {
      final result = data['results'][0];
      return PlaceDetails.fromJson(result);
    } else {
      throw Exception('Failed to fetch place details: ${data['status']}');
    }
  } else {
    throw Exception('Failed to load place details');
  }
}
