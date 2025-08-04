import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

// 추천 영상 URL 목록
final List<String> recommendedVideoUrls = [
  'https://youtu.be/WICoTVgv1CM?si=nTYtdD91R5hfk5rr',
  'https://youtu.be/oQeS4TPiC7Q?si=vD-dzLi1PoBAgmV9',
  'https://youtu.be/bSXL5O773O4?si=xfSaxEZ9L8IAK_dI',
];

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

// 영상 섹션 위젯
Widget buildRecommendedVideosSection(List<VideoModel> recommendedVideos,
    ScrollController videoScrollController) {
  return Container(
    margin: const EdgeInsets.only(top: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '추천 영상',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            controller: videoScrollController,
            itemCount: recommendedVideos.length,
            itemBuilder: (context, index) {
              final video = recommendedVideos[index];
              return GestureDetector(
                onTap: () => launchVideo(video.videoUrl),
                child: Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: video.thumbnailUrl.isNotEmpty
                              ? Image.network(
                                  video.thumbnailUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey.shade300,
                                      child: const Icon(
                                        Icons.video_library,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  color: Colors.grey.shade300,
                                  child: const Icon(
                                    Icons.video_library,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                video.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                video.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

// 영상 클릭 핸들러
Future<void> launchVideo(String videoUrl) async {
  final Uri url = Uri.parse(videoUrl);
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw Exception('Could not launch $videoUrl');
  }
}
