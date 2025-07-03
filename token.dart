import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> fetchAmadeusToken() async {
  final url = Uri.parse("https://test.api.amadeus.com/v1/security/oauth2/token");

  final headers = {
    "Content-Type": "application/x-www-form-urlencoded"
  };

  final body = {
    "grant_type": "client_credentials",
    // "client_id": dotenv.env['AMADEUS_CLIENT_ID'] ?? '',
    // "client_secret": dotenv.env['AMADEUS_CLIENT_SECRET'] ?? ''
    "client_id":'Azf3sM3HBbCPxaq3f3rPu8T1EBSRq3Ru',
    "client_secret": 'xRDMPXEfniiKNhnm'
  };

  final response = await http.post(
    url,
    headers: headers,
    body: body,
  );

  print('Status code: ${response.statusCode}');

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    print('Token: ${jsonResponse['access_token']}');
  } else {
    print('Erreur: ${response.body}');
  }
}
void main() {
  fetchAmadeusToken();
}
