import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

class VideoDetailScreen extends StatelessWidget {
  final String videoId;
  final String thumbUrl;

  const VideoDetailScreen({super.key, required this.videoId, required this.thumbUrl});

  @override
  Widget build(BuildContext context) {
    final ApiService api = ApiService();

    return Scaffold(
      backgroundColor: Constants.bgColor,
      body: CustomScrollView(
        slivers: [
          // Gambar Header yang terhubung dengan animasi Hero
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: Constants.bgColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: videoId,
                child: CachedNetworkImage(
                  imageUrl: thumbUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          // Konten Detail Video
          SliverToBoxAdapter(
            child: FutureBuilder<Map<String, dynamic>>(
              future: api.getVideoDetail(videoId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(50.0),
                    child: Center(child: CircularProgressIndicator(color: Constants.primaryColor)),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final data = snapshot.data!;
                final description = data['description'] ?? 'Tidak ada deskripsi.';
                
                // Mendapatkan URL streaming mentah (MP4)
                final streams = data['formatStreams'] as List<dynamic>?;
                final mp4Stream = streams?.firstWhere((s) => s['container'] == 'mp4', orElse: () => null);

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['title'],
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ).animate().fadeIn().slideX(),
                      const SizedBox(height: 10),
                      
                      Row(
                        children: [
                          const Icon(Icons.person, color: Colors.grey, size: 20),
                          const SizedBox(width: 8),
                          Text(data['author'], style: const TextStyle(color: Colors.grey, fontSize: 16)),
                        ],
                      ).animate().fadeIn(delay: 200.ms).slideX(),
                      
                      const SizedBox(height: 20),
                      
                      // Tombol Aksi Putar Video
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.play_arrow, color: Colors.white),
                          label: const Text('Putar Video', style: TextStyle(color: Colors.white, fontSize: 16)),
                          onPressed: () {
                            if (mp4Stream != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('URL Stream ditemukan: ${mp4Stream['qualityLabel']}'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Format MP4 tidak tersedia untuk video ini')),
                              );
                            }
                          },
                        ),
                      ).animate().scale(delay: 400.ms, duration: 300.ms),
                      
                      const SizedBox(height: 20),
                      const Divider(color: Colors.white24),
                      const SizedBox(height: 10),
                      
                      // Deskripsi
                      Text(
                        description,
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ).animate().fadeIn(delay: 600.ms),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}