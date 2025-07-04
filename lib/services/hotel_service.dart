import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'package:flutter_dotenv/flutter_dotenv.dart';

class HotelService {
  static String? _accessToken;
  static DateTime? _tokenExpiry;
  
  // Token fourni par l'utilisateur
  static const String _userToken = 'hdRt7WKzcph23iZcTeYCFmApuAB6';

  // Données JSON statiques pour les hôtels avec images
  static const String _hotelsJson = '''
  {
    "data": [
      {
        "chainCode": "HN",
        "iataCode": "PAR",
        "dupeId": 502345064,
        "name": "HN TEST PROPERTY1 FOR E2E TESTING",
        "hotelId": "HNPARKGU",
        "geoCode": {
          "latitude": 48.85315,
          "longitude": 2.34513
        },
        "address": {
          "countryCode": "FR",
          "postalCode": "28027",
          "cityName": "Paris",
          "lines": ["NICE, FRANCE"]
        },
        "distance": {
          "value": 0.12,
          "unit": "KM"
        },
        "lastUpdate": "2025-07-03T09:00:05",
        "retailing": {
          "sponsorship": {
            "isSponsored": true
          }
        },
        "imageAsset": "assets/hotel1.jpg"
      },
      {
        "chainCode": "AC",
        "iataCode": "PAR",
        "dupeId": 502345065,
        "name": "Hôtel Champs Élysées",
        "hotelId": "ACPARIS01",
        "geoCode": {
          "latitude": 48.8698,
          "longitude": 2.3077
        },
        "address": {
          "countryCode": "FR",
          "postalCode": "75008",
          "cityName": "Paris",
          "lines": ["123 Avenue des Champs-Élysées"]
        },
        "distance": {
          "value": 0.25,
          "unit": "KM"
        },
        "lastUpdate": "2025-07-03T09:00:05",
        "retailing": {
          "sponsorship": {
            "isSponsored": false
          }
        },
        "imageAsset": "assets/hotel2.jpg"
      },
      {
        "chainCode": "IB",
        "iataCode": "PAR",
        "dupeId": 502345066,
        "name": "Ibis Paris Centre",
        "hotelId": "IBPARIS02",
        "geoCode": {
          "latitude": 48.8566,
          "longitude": 2.3522
        },
        "address": {
          "countryCode": "FR",
          "postalCode": "75001",
          "cityName": "Paris",
          "lines": ["15 Rue de Rivoli"]
        },
        "distance": {
          "value": 0.18,
          "unit": "KM"
        },
        "lastUpdate": "2025-07-03T09:00:05",
        "retailing": {
          "sponsorship": {
            "isSponsored": true
          }
        },
        "imageAsset": "assets/hotel3.jpg"
      },
      {
        "chainCode": "NH",
        "iataCode": "PAR",
        "dupeId": 502345067,
        "name": "NH Paris Eiffel Tower",
        "hotelId": "NHPARIS03",
        "geoCode": {
          "latitude": 48.8584,
          "longitude": 2.2945
        },
        "address": {
          "countryCode": "FR",
          "postalCode": "75007",
          "cityName": "Paris",
          "lines": ["7 Avenue de Suffren"]
        },
        "distance": {
          "value": 0.32,
          "unit": "KM"
        },
        "lastUpdate": "2025-07-03T09:00:05",
        "retailing": {
          "sponsorship": {
            "isSponsored": false
          }
        },
        "imageAsset": "assets/hotel4.jpg"
      },
      {
        "chainCode": "MG",
        "iataCode": "PAR",
        "dupeId": 502345068,
        "name": "Mercure Paris Montmartre",
        "hotelId": "MGPARIS04",
        "geoCode": {
          "latitude": 48.8867,
          "longitude": 2.3431
        },
        "address": {
          "countryCode": "FR",
          "postalCode": "75018",
          "cityName": "Paris",
          "lines": ["20 Rue de la Fontaine du But"]
        },
        "distance": {
          "value": 0.45,
          "unit": "KM"
        },
        "lastUpdate": "2025-07-03T09:00:05",
        "retailing": {
          "sponsorship": {
            "isSponsored": true
          }
        },
        "imageAsset": "assets/hotel5.jpg"
      }
    ]
  }
  ''';

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
       "client_id":'Azf3sM3HBbCPxaq3f3rPu8T1EBSRq3Ru',
    "client_secret": 'xRDMPXEfniiKNhnm'
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

  // Rechercher des hôtels par ville (utilise maintenant les données JSON statiques)
  static Future<List<Hotel>> searchHotelsByCity({
    required String cityCode,
    required String checkInDate,
    required String checkOutDate,
    int adults = 1,
    int roomQuantity = 1,
  }) async {
    // Utiliser les données JSON statiques au lieu d'appeler l'API
    try {
      final jsonResponse = jsonDecode(_hotelsJson);
      print('Données JSON statiques utilisées');
      return _parseHotels(jsonResponse);
    } catch (e) {
      print('Erreur lors du parsing des données JSON: $e');
      return [];
    }
  }

  // Rechercher des hôtels par géolocalisation (utilise maintenant les données JSON statiques)
  static Future<List<Hotel>> searchHotelsByLocation({
    required double latitude,
    required double longitude,
    required String checkInDate,
    required String checkOutDate,
    int adults = 1,
    int roomQuantity = 1,
    double radius = 5.0, // Rayon en km
  }) async {
    // Utiliser les données JSON statiques au lieu d'appeler l'API
    try {
      final jsonResponse = jsonDecode(_hotelsJson);
      print('Données JSON statiques utilisées pour la géolocalisation');
      return _parseHotels(jsonResponse);
    } catch (e) {
      print('Erreur lors du parsing des données JSON: $e');
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
  final String? imageAsset;

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
    this.imageAsset,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    final address = json['address'] ?? {};
    return Hotel(
      id: json['hotelId'] ?? '',
      name: json['name'] ?? 'Hôtel sans nom',
      description: null,
      rating: null,
      address: address['lines']?.join(', '),
      city: address['cityName'],
      country: address['countryCode'],
      latitude: json['geoCode']?['latitude']?.toDouble(),
      longitude: json['geoCode']?['longitude']?.toDouble(),
      amenities: [],
      offers: [],
      imageUrl: null,
      imageAsset: json['imageAsset'],
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