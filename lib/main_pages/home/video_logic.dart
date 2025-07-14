import 'dart:convert';
import 'package:http/http.dart' as http;

class VideoModel {
  final String title;
  final String thumbnailUrl;
  final String videoUrl;
  final String description;

  VideoModel({
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.description,
  });
}

Future<List<VideoModel>> fetchRecommendedVideos(
    List<String> recommendedVideoUrls) async {
  List<VideoModel> videos = [];
  for (final url in recommendedVideoUrls) {
    try {
      final oembedUrl = 'https://www.youtube.com/oembed?url=$url&format=json';
      final response = await http.get(Uri.parse(oembedUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        videos.add(VideoModel(
          title: data['title'] ?? '',
          thumbnailUrl: data['thumbnail_url'] ?? '',
          videoUrl: url,
          description: data['author_name'] ?? '',
        ));
      } else {
        videos.add(VideoModel(
          title: '제목을 불러올 수 없음',
          thumbnailUrl: '',
          videoUrl: url,
          description: '',
        ));
      }
    } catch (e) {
      videos.add(VideoModel(
        title: '제목을 불러올 수 없음',
        thumbnailUrl: '',
        videoUrl: url,
        description: '',
      ));
    }
  }
  return videos;
}
