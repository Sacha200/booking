import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/hotel_service.dart';

class HotelSearchScreen extends StatefulWidget {
  @override
  _HotelSearchScreenState createState() => _HotelSearchScreenState();
}

class _HotelSearchScreenState extends State<HotelSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  
  List<Hotel> _hotels = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedCity = 'New York, USA';
  
  // Dates par défaut (demain et après-demain)
  DateTime _checkInDate = DateTime.now().add(Duration(days: 1));
  DateTime _checkOutDate = DateTime.now().add(Duration(days: 2));

  @override
  void initState() {
    super.initState();
    _cityController.text = _selectedCity;
    // Recherche initiale
    _searchHotelsByCity();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  // Rechercher des hôtels par ville
  Future<void> _searchHotelsByCity() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Extraire le nom de la ville (avant la virgule)
      final cityName = _selectedCity.split(',')[0].trim();
      
      // Obtenir le code de ville
      final cityCode = await HotelService.getCityCode(cityName);
      
      if (cityCode == null) {
        setState(() {
          _errorMessage = 'Ville non trouvée. Veuillez essayer une autre ville.';
          _isLoading = false;
        });
        return;
      }

      // Formater les dates
      final checkInStr = _formatDate(_checkInDate);
      final checkOutStr = _formatDate(_checkOutDate);

      final hotels = await HotelService.searchHotelsByCity(
        cityCode: cityCode,
        checkInDate: checkInStr,
        checkOutDate: checkOutStr,
        adults: 1,
        roomQuantity: 1,
      );

      setState(() {
        _hotels = hotels;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors de la recherche: $e';
        _isLoading = false;
      });
    }
  }

  // Rechercher des hôtels par géolocalisation
  Future<void> _searchHotelsByLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Vérifier les permissions de localisation
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'Permission de localisation refusée';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = 'Les permissions de localisation sont définitivement refusées';
          _isLoading = false;
        });
        return;
      }

      // Obtenir la position actuelle
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Formater les dates
      final checkInStr = _formatDate(_checkInDate);
      final checkOutStr = _formatDate(_checkOutDate);

      final hotels = await HotelService.searchHotelsByLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        checkInDate: checkInStr,
        checkOutDate: checkOutStr,
        adults: 1,
        roomQuantity: 1,
        radius: 10.0, // 10 km de rayon
      );

      setState(() {
        _hotels = hotels;
        _isLoading = false;
        _selectedCity = 'Votre position actuelle';
        _cityController.text = _selectedCity;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors de la recherche: $e';
        _isLoading = false;
      });
    }
  }

  // Formater une date en format YYYY-MM-DD
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Sélectionner des dates
  Future<void> _selectDates() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: _checkInDate,
        end: _checkOutDate,
      ),
    );

    if (picked != null) {
      setState(() {
        _checkInDate = picked.start;
        _checkOutDate = picked.end;
      });
      // Relancer la recherche avec les nouvelles dates
      _searchHotelsByCity();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Text('Recherche d\'hôtels'),
        backgroundColor: Color(0xFF1D6EFD),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Section de recherche
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Barre de recherche de ville
                TextField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    hintText: 'Entrez une ville...',
                    prefixIcon: Icon(Icons.location_on, color: Color(0xFF1D6EFD)),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.my_location, color: Color(0xFF1D6EFD)),
                      onPressed: _searchHotelsByLocation,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      _selectedCity = value;
                    });
                    _searchHotelsByCity();
                  },
                ),
                SizedBox(height: 12),
                
                // Sélection de dates
                InkWell(
                  onTap: _selectDates,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Color(0xFF1D6EFD)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${_formatDate(_checkInDate)} - ${_formatDate(_checkOutDate)}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12),
                
                // Bouton de recherche
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _searchHotelsByCity,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1D6EFD),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Rechercher', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
          
          // Affichage des résultats
          Expanded(
            child: _buildResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF1D6EFD)),
            SizedBox(height: 16),
            Text('Recherche en cours...'),
          ],
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchHotelsByCity,
              child: Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (_hotels.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hotel, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Aucun hôtel trouvé',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Essayez de modifier vos critères de recherche',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _hotels.length,
      itemBuilder: (context, index) {
        final hotel = _hotels[index];
        return _buildHotelCard(hotel);
      },
    );
  }

  Widget _buildHotelCard(Hotel hotel) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image de l'hôtel (placeholder pour l'instant)
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: Colors.grey[300],
            ),
            child: hotel.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.network(
                      hotel.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.hotel, size: 64, color: Colors.grey);
                      },
                    ),
                  )
                : Icon(Icons.hotel, size: 64, color: Colors.grey),
          ),
          
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom de l'hôtel
                Text(
                  hotel.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                SizedBox(height: 8),
                
                // Ville et pays
                Row(
                  children: [
                    Icon(Icons.location_city, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${hotel.city ?? 'Ville inconnue'}${hotel.country != null ? ', ${hotel.country}' : ''}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 12),
                
                // Prix
                if (hotel.lowestPrice != null)
                  Row(
                    children: [
                      Text(
                        'À partir de ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        '${hotel.lowestPrice!.toStringAsFixed(0)} ${hotel.currency}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D6EFD),
                        ),
                      ),
                      Text(
                        ' / nuit',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                
                SizedBox(height: 12),
                
                // Bouton de réservation
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Naviguer vers l'écran de détails de l'hôtel
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Fonctionnalité de réservation à venir')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1D6EFD),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Voir les détails'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 