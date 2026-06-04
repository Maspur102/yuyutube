import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _trendingVideos;

  @override
  void initState() {
    super.initState();
    _trendingVideos = _apiService.fetchTrendingVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YuyuTube Trending', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red[800],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _trendingVideos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.red));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada video.'));
          }

          final videos = snapshot.data!;
          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return ListTile(
                contentPadding: const EdgeInsets.all(8.0),
                leading: Image.network(
                  video['videoThumbnails'][0]['url'],
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                ),
                title: Text(
                  video['title'] ?? 'Tanpa Judul',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(video['author'] ?? 'Tidak diketahui'),
                onTap: () {
                  // Nanti Anda bisa arahkan ke halaman detail video di sini
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Memutar: ${video['title']}')),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}