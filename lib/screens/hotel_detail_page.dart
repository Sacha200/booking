import 'package:flutter/material.dart';

class HotelDetailPage extends StatelessWidget {
  final String title;
  final String address;
  final double price;
  final double rating;
  final List<String> galleryAssets;

  const HotelDetailPage({
    super.key,
    required this.title,
    required this.address,
    required this.price,
    required this.rating,
    required this.galleryAssets,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            // Image principale
            Image.asset(galleryAssets[1], height: 220, width: double.infinity, fit: BoxFit.cover),
            // Galerie horizontale
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: galleryAssets.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(galleryAssets[index], width: 80, height: 80, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            // Infos principales
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('20% Off', style: TextStyle(color: Colors.blue)),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      Text('$rating (365 reviews)', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text(address, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  // Tabs (About, Gallery, Review)
                  DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        TabBar(
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.black,
                          tabs: const [
                            Tab(text: 'About'),
                            Tab(text: 'Gallery'),
                            Tab(text: 'Review'),
                          ],
                        ),
                        SizedBox(
                          height: 200,
                          child: TabBarView(
                            children: [
                              // About
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Description de l\'hôtel...'),
                              ),
                              // Gallery
                              GridView.count(
                                crossAxisCount: 2,
                                children: galleryAssets
                                    .map((asset) => Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Image.asset(asset, fit: BoxFit.cover),
                                        ))
                                    .toList(),
                              ),
                              // Review
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Avis des clients...'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Price', style: TextStyle(color: Colors.grey)),
                      Text(' 24${price.toStringAsFixed(0)} /night', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Book Now'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 