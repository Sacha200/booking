import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HotelService {
  static String? _accessToken;
  static DateTime? _tokenExpiry;

  // Obtenir un token d'accès
  static Future<String?> _getAccessToken() async {
    // Vérifier si le token existe et n'est pas expiré
    if (_accessToken != null && _tokenExpiry != null && DateTime.now().isBefore(_tokenExpiry!)) {
      return _accessToken;
    }

    final url = Uri.parse("https://test.api.amadeus.com/v1/security/oauth2/token");
    
    final headers = {
      "Content-Type": "application/x-www-form-urlencoded"
    };

    final body = {
      "grant_type": "client_credentials",
      "client_id": dotenv.env['AMADEUS_CLIENT_ID'] ?? '',
      "client_secret": dotenv.env['AMADEUS_CLIENT_SECRET'] ?? ''
    };

    try {
      final response = await http.post(url, headers: headers, body: body);
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        _accessToken = jsonResponse['access_token'];
        // Le token expire dans 30 minutes
        _tokenExpiry = DateTime.now().add(Duration(minutes: 25));
        return _accessToken;
      } else {
        print('Erreur lors de l\'obtention du token: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      return null;
    }
  }

  // Rechercher des hôtels par ville
  static Future<List<Hotel>> searchHotelsByCity({
    required String cityCode,
    required String checkInDate,
    required String checkOutDate,
    int adults = 1,
    int roomQuantity = 1,
  }) async {
    final token = await _getAccessToken();
    if (token == null) {
      throw Exception('Impossible d\'obtenir le token d\'accès');
    }

    final url = Uri.parse(
      'https://test.api.amadeus.com/v2/shopping/hotel-offers'
      '?cityCode=$cityCode'
      '&checkInDate=$checkInDate'
      '&checkOutDate=$checkOutDate'
      '&adults=$adults'
      '&roomQuantity=$roomQuantity'
      '&bestRateOnly=true'
      '&currency=EUR'
    );

    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return _parseHotels(jsonResponse);
      } else {
        print('Erreur lors de la recherche d\'hôtels: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      return [];
    }
  }

  // Rechercher des hôtels par géolocalisation
  static Future<List<Hotel>> searchHotelsByLocation({
    required double latitude,
    required double longitude,
    required String checkInDate,
    required String checkOutDate,
    int adults = 1,
    int roomQuantity = 1,
    double radius = 5.0, // Rayon en km
  }) async {
    final token = await _getAccessToken();
    if (token == null) {
      throw Exception('Impossible d\'obtenir le token d\'accès');
    }

    final url = Uri.parse(
      'https://test.api.amadeus.com/v2/shopping/hotel-offers'
      '?latitude=$latitude'
      '&longitude=$longitude'
      '&radius=$radius'
      '&radiusUnit=KM'
      '&checkInDate=$checkInDate'
      '&checkOutDate=$checkOutDate'
      '&adults=$adults'
      '&roomQuantity=$roomQuantity'
      '&bestRateOnly=true'
      '&currency=EUR'
    );

    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return _parseHotels(jsonResponse);
      } else {
        print('Erreur lors de la recherche d\'hôtels: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      return [];
    }
  }

  // Parser la réponse JSON en objets Hotel
  static List<Hotel> _parseHotels(Map<String, dynamic> jsonResponse) {
    final List<Hotel> hotels = [];
    
    if (jsonResponse['data'] != null) {
      for (var hotelData in jsonResponse['data']) {
        try {
          final hotel = Hotel.fromJson(hotelData);
          hotels.add(hotel);
        } catch (e) {
          print('Erreur lors du parsing d\'un hôtel: $e');
        }
      }
    }
    
    return hotels;
  }

  // Rechercher le code de ville par nom
  static Future<String?> getCityCode(String cityName) async {
    final token = await _getAccessToken();
    if (token == null) {
      return null;
    }

    final url = Uri.parse(
      'https://test.api.amadeus.com/v1/reference-data/locations/cities'
      '?keyword=$cityName'
      '&subType=CITY'
    );

    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['data'] != null && jsonResponse['data'].isNotEmpty) {
          return jsonResponse['data'][0]['address']['cityCode'];
        }
      }
    } catch (e) {
      print('Erreur lors de la recherche du code de ville: $e');
    }
    
    return null;
  }
}

class Hotel {
  final String id;
  final String name;
  final String? description;
  final double? rating;
  final String? address;
  final String? city;
  final String? country;
  final double? latitude;
  final double? longitude;
  final List<String> amenities;
  final List<RoomOffer> offers;
  final String? imageUrl;

  Hotel({
    required this.id,
    required this.name,
    this.description,
    this.rating,
    this.address,
    this.city,
    this.country,
    this.latitude,
    this.longitude,
    required this.amenities,
    required this.offers,
    this.imageUrl,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    final hotel = json['hotel'] ?? {};
    final offers = json['offers'] ?? [];
    
    return Hotel(
      id: hotel['hotelId'] ?? '',
      name: hotel['name'] ?? 'Hôtel sans nom',
      description: hotel['description']?['text'],
      rating: hotel['rating']?.toDouble(),
      address: hotel['address']?['lines']?.join(', '),
      city: hotel['address']?['cityName'],
      country: hotel['address']?['countryCode'],
      latitude: hotel['geoCode']?['latitude']?.toDouble(),
      longitude: hotel['geoCode']?['longitude']?.toDouble(),
      amenities: _parseAmenities(hotel['amenities'] ?? []),
      offers: offers.map<RoomOffer>((offer) => RoomOffer.fromJson(offer)).toList(),
      imageUrl: _validateImageUrl(hotel['media']?.first?['uri']),
    );
  }

  static List<String> _parseAmenities(List amenities) {
    return amenities.map<String>((amenity) => amenity['description'] ?? '').toList();
  }

  static String? _validateImageUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    
    // Vérifier que l'URL commence par http ou https
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return null;
    }
    
    // Vérifier que l'URL n'est pas trop longue
    if (url.length > 500) return null;
    
    return url;
  }

  // Obtenir le prix le plus bas
  double? get lowestPrice {
    if (offers.isEmpty) return null;
    return offers.map((offer) => offer.totalPrice).reduce((a, b) => a < b ? a : b);
  }

  // Obtenir la devise
  String get currency {
    if (offers.isEmpty) return 'EUR';
    return offers.first.currency;
  }
}

class RoomOffer {
  final String id;
  final String roomType;
  final String boardType;
  final double totalPrice;
  final String currency;
  final String? cancellationPolicy;

  RoomOffer({
    required this.id,
    required this.roomType,
    required this.boardType,
    required this.totalPrice,
    required this.currency,
    this.cancellationPolicy,
  });

  factory RoomOffer.fromJson(Map<String, dynamic> json) {
    final price = json['price'] ?? {};
    
    return RoomOffer(
      id: json['id'] ?? '',
      roomType: json['room']?['type'] ?? 'Chambre standard',
      boardType: json['boardType'] ?? 'Room Only',
      totalPrice: (price['total'] ?? 0.0).toDouble(),
      currency: price['currency'] ?? 'EUR',
      cancellationPolicy: json['policies']?['cancellation']?['description'],
    );
  }
} 