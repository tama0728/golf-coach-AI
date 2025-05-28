import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:archive/archive.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ResultPage extends StatefulWidget {
  final String _videoPath;
  const ResultPage(this._videoPath);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String? _resultData;
  Map<String, dynamic>? _resultJsonData;
  bool _isLoading = true;
  String? _errorMessage;
  VideoPlayerController? _controller;
  File? _videoFile;
  String? fileId;
  List<File> _imageFiles = [];
  bool _isZipLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchResultData();
  }

  Future<void> _downloadAndPlay() async {
    final url = _resultJsonData?['download_url'] ?? '';
    if (url.isEmpty) {
      setState(() {
        _errorMessage = '다운로드 URL이 없습니다.';
        _isLoading = false;
      });
      return;
    }
    try {
      final response = await http.get(Uri.parse('http://${dotenv.get('ANALYTICS_HOST')}:5005/$url'));
      final tempDir = await getTemporaryDirectory();
      final videoPath = '${tempDir.path}/processed_video.mp4';
      _videoFile = File(videoPath);
      await _videoFile?.writeAsBytes(response.bodyBytes);

      final controller = VideoPlayerController.file(_videoFile!);
      // 영상 초기화 및 실패 대응
      await controller.initialize().catchError((e) {
        if (mounted) {
          setState(() {
            _errorMessage = '영상 로딩 실패: $e';
            _isLoading = false;
          });
        }
        throw e; // 필요시 주석 처리
      });
      if (!mounted) return;

      setState(() {
        _controller = controller
          ..play()
          ..setLooping(true);
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = '영상 다운로드 실패: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _downloadAndExtractZip() async {
    final zipUrl = _resultJsonData?['zip_url'];
    if (zipUrl == null || zipUrl.isEmpty) {
      setState(() => _errorMessage = 'ZIP URL이 없습니다');
      return;
    }
    try {
      setState(() => _isZipLoading = true);
      final response = await http.get(Uri.parse('http://${dotenv.get('ANALYTICS_HOST')}:5005/$zipUrl'));
      final archive = ZipDecoder().decodeBytes(response.bodyBytes);
      final tempDir = await getTemporaryDirectory();
      final imageFiles = <File>[];
      for (final file in archive) {
        if (file.isFile && (file.name.endsWith('.png') || file.name.endsWith('.jpg'))) {
          final filename = '${tempDir.path}/${file.name}';
          final outputFile = File(filename);
          await outputFile.create(recursive: true);
          await outputFile.writeAsBytes(file.content);
          imageFiles.add(outputFile);
        }
      }
      setState(() => _imageFiles = imageFiles.take(3).toList());
    } catch (e) {
      setState(() => _errorMessage = 'ZIP 처리 오류: $e');
    } finally {
      setState(() => _isZipLoading = false);
    }
  }

  Future<void> _fetchResultData() async {
    try {
      print('Fetching result data for video: ${widget._videoPath}');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://${dotenv.get('ANALYTICS_HOST')}:5005/upload'),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'video',
          widget._videoPath,
          contentType: MediaType('video', 'mp4'),
        ),
      );

      var response = await request.send();
      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseData) as Map<String, dynamic>;
        setState(() {
          _resultJsonData = jsonData;
          _resultData = responseData;
        });
        await _downloadAndPlay();
        await _downloadAndExtractZip();
      } else {
        setState(() {
          _errorMessage = '결과 데이터를 받아오지 못했습니다.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '오류 발생: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _buildVideoPlayer() {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const SizedBox();
    }
    return Container(
      height: 300,
      child: AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: VideoPlayer(_controller!),
      ),
    );
  }

  Widget _buildImageGrid() {
    if (_imageFiles.isEmpty) return const SizedBox();
    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _imageFiles.length,
        itemBuilder: (ctx, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.file(_imageFiles[index], width: 150, fit: BoxFit.cover),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('처리 결과')),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : _buildVideoPlayer(),

          ),
          if (_isZipLoading)
            const LinearProgressIndicator()
          else
            _buildImageGrid(),
        ],
      ),
    );
  }
}
