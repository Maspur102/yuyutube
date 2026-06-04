import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';
import 'video_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _api = ApiService();
  late Future<List<dynamic>> _videosFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _videosFuture = _api.getTrending();
  }

  void _search(String query) {
    if (query.isNotEmpty) {
      setState(() {
        _videosFuture = _api.searchVideos(query);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Modern Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onSubmitted: _search,
                decoration: InputDecoration(
                  hintText: 'Cari di YuyuTube...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Constants.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ).animate().fade(duration: 500.ms).slideY(begin: -0.2),
            ),
            
            // Daftar Video
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _videosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Constants.primaryColor));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final videos = snapshot.data?.where((v) => v['type'] == 'video' || v['type'] == null).toList() ?? [];

                  if (videos.isEmpty) {
                    return const Center(child: Text('Tidak ada video ditemukan.'));
                  }

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      final video = videos[index];
                      final videoId = video['videoId'];
                      final thumbUrl = video['videoThumbnails'][0]['url'];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (_) => VideoDetailScreen(videoId: videoId, thumbUrl: thumbUrl),
                          ));
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Constants.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Animasi Hero untuk Gambar Thumbnail
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                child: Hero(
                                  tag: videoId,
                                  child: CachedNetworkImage(
                                    imageUrl: thumbUrl,
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(height: 200, color: Colors.grey[900]),
                                    errorWidget: (context, url, error) => Container(height: 200, color: Colors.grey[900], child: const Icon(Icons.error)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      video['title'] ?? 'Tanpa Judul',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      video['author'] ?? 'Tidak diketahui',
                                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fade(delay: (100 * index).ms).slideY(begin: 0.1); 
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}