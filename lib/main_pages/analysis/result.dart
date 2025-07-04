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

class SwingAnalysis {
  final String swingPart;
  final String evaluation;

  SwingAnalysis({
    required this.swingPart,
    required this.evaluation,
  });

  // factory SwingAnalysis.fromJson(List<dynamic> json) {
  //   print('0, 1: ${json[0]}, ${json[1]}');
  //   return SwingAnalysis(
  //     swingPart: json[0] ?? 'Unknown Part',
  //     evaluation: json[1] ?? 'No Evaluation',
  //   );
  // }

  factory SwingAnalysis.fromJson(Map<String, dynamic> json) {
    // print('0, 1: ${json[0]}, ${json[1]}');
    return SwingAnalysis(
      swingPart: json['swing_part'] ?? 'Unknown Part',
      evaluation: json['evaluation'] ?? 'No Evaluation',
    );
  }
}

class _ResultPageState extends State<ResultPage> {
  String? _resultData;
  Map<String, dynamic>? _resultJsonData;
  bool _isLoaded = false;
  String? _errorMessage;
  VideoPlayerController? _controller;
  File? _videoFile;
  String? fileId;
  List<File> _imageFiles = [];
  bool _isZipLoading = false;
  bool _isSwingAnalysis = false;
  List<SwingAnalysis> _swingAnalysisList = [];

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
        _isLoaded = false;
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
            _isLoaded = false;
          });
        }
        throw e; // 필요시 주석 처리
      });
      if (!mounted) return;

      setState(() {
        _controller = controller
          ..play()
          ..setLooping(true);
        _isLoaded = true;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = '영상 다운로드 실패: $e';
          _isLoaded = false;
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
      // setState(() => _isZipLoading = true);
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
      setState(() => _isZipLoading = true);
    }
  }

  Future<void> _getSwingAnalysis() async {
    final swingData = _resultJsonData?['swing_analysis'];
    if (swingData == null || swingData.isEmpty) {
      setState(() => _errorMessage = '스윙 분석 데이터가 없습니다');
      return;
    }
    try {
      final response = await http.get(Uri.parse('http://${dotenv.get('ANALYTICS_HOST')}:5005/$swingData'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          print('Swing Analysis Data: $data');
          print(data.runtimeType);
          _swingAnalysisList = data
              .map<SwingAnalysis>((item) => SwingAnalysis.fromJson(item as Map<String, dynamic>))
              .toList();
          _errorMessage = null;
          _isSwingAnalysis = true;
        });
      } else {
        setState(() => _errorMessage = '서버 응답 오류: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _errorMessage = '스윙 분석 데이터 불러오기 오류: $e');
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
          _isLoaded = true;
        });
        await _downloadAndPlay();
        await _downloadAndExtractZip();
        await _getSwingAnalysis();
      } else {
        setState(() {
          _errorMessage = '결과 데이터를 받아오지 못했습니다.';
          _isLoaded = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '오류 발생: $e';
        _isLoaded = false;
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
      // height: MediaQuery.of(context).size.height / 2,
      width: double.infinity, // 너비를 꽉 채움
      child: AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: VideoPlayer(_controller!),
      ),
    );
  }

  Widget _buildImageGrid() {
    if (_imageFiles.isEmpty) return const SizedBox();
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _imageFiles.length,
        itemBuilder: (ctx, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.file(_imageFiles[index], width: MediaQuery.of(context).size.width * 8 / 10, fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildAnalysisList() {
    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!, style: TextStyle(color: Colors.red)));
    }

    if (_swingAnalysisList.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _swingAnalysisList.length,
        itemBuilder: (context, index) {
          final analysis = _swingAnalysisList[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(analysis.swingPart),
              subtitle: Text(analysis.evaluation),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 모든 데이터가 준비될 때까지 하나의 로딩 아이콘만 표시
    final isAllLoaded = _isLoaded && _isZipLoading && _isSwingAnalysis;
    return Scaffold(
      appBar: AppBar(title: const Text('처리 결과')),
      body: isAllLoaded
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_errorMessage != null)
                    Center(child: Text(_errorMessage!, style: TextStyle(color: Colors.red)))
                  else
                    Center(child: Text('결과 데이터가 성공적으로 로드되었습니다!')),
                  _buildVideoPlayer(),
                  _buildImageGrid(),
                  _buildAnalysisList(),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
