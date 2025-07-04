import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
import 'services/hotel_service.dart';
import 'services/auth_service.dart';
import 'screens/hotel_detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController(text: 'Paris, FRA');
  List<Hotel> _hotels = [];
  bool _isLoading = false;
  String _errorMessage = '';
  // String _selectedCity = 'New York, USA'; // Variable non utilisée, supprimée
  DateTime _checkInDate = DateTime.now().add(Duration(days: 1));
  DateTime _checkOutDate = DateTime.now().add(Duration(days: 2));

  @override
  void initState() {
    super.initState();
    _searchHotelsByCity();
  }

  Future<void> _searchHotelsByCity() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
   // try {
      final cityName = _searchController.text.split(',')[0].trim();
    final cityCode = "PAR" ; //await HotelService.getCityCode(cityName);

      print(_searchController.text);
      print(cityName);
      print(cityCode);
      if (cityCode == null) {
        setState(() {
          _errorMessage = 'Ville non trouvée. Veuillez essayer une autre ville.';
          _isLoading = false;
        });
        return;
      }
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
      /*
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors de la recherche: $e';
        _isLoading = false;
      });
    }
    */
  }

  Future<void> _searchHotelsByLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
       /*LocationPermission permission = await Geolocator.checkPermission();
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
      }*/
      // final Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final checkInStr = _formatDate(_checkInDate);
      final checkOutStr = _formatDate(_checkOutDate);

      final hotels = await HotelService.searchHotelsByLocation(

        latitude: 48.847370147828514,
        longitude: 2.312304048947736,
        checkInDate: checkInStr,
        checkOutDate: checkOutStr,
        adults: 1,
        roomQuantity: 1,
        radius: 10.0,
      );
      setState(() {
        _hotels = hotels;
        _isLoading = false;
        _searchController.text = 'Votre position actuelle';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors de la recherche: $e';
        _isLoading = false;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

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
      _searchHotelsByCity();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F8FA),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // Localisation et notification
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: Color(0xFF1D6EFD)),
                    const SizedBox(width: 4),
                    Text(
                      _searchController.text,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                ),
                PopupMenuButton<String>(
                  icon: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.black),
                  ),
                  onSelected: (value) {
                    if (value == 'logout') {
                      _handleLogout();
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Déconnexion'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Barre de recherche dynamique
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.my_location, color: Color(0xFF1D6EFD)),
                        onPressed: _searchHotelsByLocation,
                      ),
                    ),
                    onSubmitted: (value) {
                      _searchHotelsByCity();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF1D6EFD),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.tune, color: Colors.white),
                    onPressed: _selectDates,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Section Recommended Hotel dynamique
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recommended Hotel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                TextButton(
                  onPressed: _searchHotelsByCity,
                  child: Text('Refresh', style: TextStyle(color: Color(0xFF1D6EFD))),
                ),
              ],
            ),
            SizedBox(
              height: 280,
              child: _isLoading
                  ? Center(child: CircularProgressIndicator(color: Color(0xFF1D6EFD)))
                  : _errorMessage.isNotEmpty
                      ? Center(child: Text(_errorMessage, style: TextStyle(color: Colors.red)))
                      : _hotels.isEmpty
                          ? Center(child: Text('Aucun hôtel trouvé'))
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _hotels.length,
                              itemBuilder: (context, index) {
                                final hotel = _hotels[index];
                                return _buildHotelCard(hotel);
                              },
                            ),
            ),
            const SizedBox(height: 24),
            // Section Nearby Hotel (statique ou à adapter)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nearby Hotel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                TextButton(
                  onPressed: () {},
                  child: Text('See all', style: TextStyle(color: Color(0xFF1D6EFD))),
                ),
              ],
            ),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildHotelCardSmall(
                    image: 'assets/hotel.jpg',
                    title: 'GoldenValley',
                    location: 'New York, USA',
                    price: 150,
                    discount: '10% Off',
                    rating: 4.9,
                  ),
                  _buildHotelCardSmall(
                    image: 'assets/hotel.jpg',
                    title: 'CityNest',
                    location: 'New York, USA',
                    price: 120,
                    discount: '10% Off',
                    rating: 4.7,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Color(0xFF1D6EFD),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHotelCard(Hotel hotel) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: hotel.imageAsset != null
                    ? Image.asset(
                        hotel.imageAsset!,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 100,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Icon(Icons.hotel, size: 32, color: Colors.grey),
                      ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 16,
                  child: Icon(
                    Icons.favorite_border,
                    color: Color(0xFF1D6EFD),
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Color(0xFF1D6EFD).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Disponible',
                        style: TextStyle(
                          color: Color(0xFF1D6EFD),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 2),
                        Text(
                          hotel.rating?.toStringAsFixed(1) ?? '-',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  hotel.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey),
                    SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        '${hotel.city ?? 'Ville inconnue'}${hotel.country != null ? ', ${hotel.country}' : ''}',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  hotel.lowestPrice != null ? '${hotel.lowestPrice!.toStringAsFixed(0)} ${hotel.currency}' : 'Prix ?',
                  style: TextStyle(
                    color: Color(0xFF1D6EFD),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HotelDetailPage(
                          title: hotel.name,
                          address: hotel.address ?? '',
                          price: hotel.lowestPrice ?? 0.0,
                          rating: hotel.rating ?? 0.0,
                          galleryAssets: hotel.imageAsset != null ? [hotel.imageAsset!] : [],
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        'Voir détails',
                        style: TextStyle(
                          color: Color(0xFF1D6EFD),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFF1D6EFD),
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHotelCardSmall({
    required String image,
    required String title,
    required String location,
    required int price,
    required String discount,
    required double rating,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotelDetailPage(
              title: title,
              address: location,
              price: price.toDouble(),
              rating: rating,
              galleryAssets: [
                image,
                'assets/hotel1.jpg', // Ajoute d'autres images assets ici
              ],
            ),
          ),
        );
      },
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(image, height: 60, width: 60, fit: BoxFit.cover),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Color(0xFF1D6EFD).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(discount, style: TextStyle(color: Color(0xFF1D6EFD), fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      const Spacer(),
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(rating.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey),
                      const SizedBox(width: 2),
                      Text(location, style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text('\$ $price /night', style: TextStyle(color: Color(0xFF1D6EFD), fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour gérer la déconnexion
  Future<void> _handleLogout() async {
    try {
      await AuthService.signOut();
      // La navigation se fait automatiquement via AuthWrapper
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la déconnexion: ${e.toString()}')),
        );
      }
    }
  }
} 