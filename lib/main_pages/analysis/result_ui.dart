import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:golf_coach_app/main_pages/main_page.dart';

class ResultUIPage extends StatefulWidget {
  final String _fileId;
  final double _score;
  const ResultUIPage(this._fileId, this._score);

  @override
  _ResultUIPageState createState() => _ResultUIPageState(_fileId, _score);
}

class SwingAnalysis {
  final String swingPart;
  final String posture;
  final String evaluation;

  SwingAnalysis({
    required this.swingPart,
    required this.posture,
    required this.evaluation,
  });

  factory SwingAnalysis.fromJson(Map<String, dynamic> json) {
    return SwingAnalysis(
      swingPart: json['swing_part'] ?? 'Unknown Part',
      posture: json['posture'] ?? 'No Posture',
      evaluation: json['evaluation'] ?? 'No Evaluation',
    );
  }
}

class _ResultUIPageState extends State<ResultUIPage> {
  final String _fileId;
  final double _score;
  _ResultUIPageState(this._fileId, this._score);

  Map<String, dynamic>? _resultJsonData;
  bool _isLoaded = false;
  String? _errorMessage;
  VideoPlayerController? _controller;
  File? _videoFile;

  File _addressImageFile = File('');
  File _topImageFile = File('');
  File _contactImageFile = File('');

  bool _isAddressImageLoading = false;
  bool _isTopImageLoading = false;
  bool _isContactImageLoading = false;

  bool _isScoreLoading = false;
  bool _isSwingAnalysis = false;
  List<SwingAnalysis> _swingAnalysisList = [];
  Map<String, dynamic> _scoreData = {};

  // temp directory
  late final Directory _appDir;

  @override
  void initState() async {
    super.initState();
    _appDir = await getTemporaryDirectory();
    _fetchResultData();
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
    Widget player = AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: VideoPlayer(_controller!),
    );

    // 전면 카메라로 촬영한 영상만 좌우 반전
    // if (widget.isFrontCamera) {
    //   player = Transform(
    //     alignment: Alignment.center,
    //     transform: Matrix4.rotationY(math.pi),
    //     child: player,
    //   );
    // }

    return Container(
      width: double.infinity,
      child: player,
    );
  }

  Widget DiagnosisButtonSection() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            isScrollControlled: true,
            builder: (context) => DiagnosisBottomSheet()
        );
      },
      child: Container(
        color: const Color(0xFFE6F5E6),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: const [
            Icon(
              Icons.arrow_drop_up,
              color: Colors.black,
              size: 50,
            ),
            Text(
              '진단결과보기',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget DiagnosisBottomSheet() {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          color: Colors.white,
          child: ListView(
            controller: scrollController,
            children: [
              const ColoredBox(
                color: Color(0xFFE6F5E6),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      '진단 결과',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '스윙 점수 : ${_score}점',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    // height: 250,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: _buildVideoPlayer(),
                    // const Center(
                    //   child:
                    //   Text(
                    //     '동영상 자리',
                    //     style: TextStyle(color: Colors.black54),
                    //   ),
                    // ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _isLoaded = _isAddressImageLoading && _isTopImageLoading && _isContactImageLoading && _isScoreLoading && _isSwingAnalysis;
    if (!_isLoaded) {
      print('Loading state: Address: $_isAddressImageLoading, Top: $_isTopImageLoading, Contact: $_isContactImageLoading, Score: $_isScoreLoading, Swing Analysis: $_isSwingAnalysis');
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(),
        body: Center(
          child: _errorMessage != null
              ? Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 16))
              : const CircularProgressIndicator(),
        ),
      );
    } else {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(),
          body: Column(
            children: [
              Divider(height: 1, thickness: 1),
              CustomTabBar(),
              Divider(height: 1, thickness: 1),
              Expanded(
                child: TabBarView(
                  children: [
                    ResultTabPage( // Address
                      part: 'ADDRESS',
                      imageFile: _addressImageFile,
                      swingAnalysisList: _swingAnalysisList
                          .where((
                          analysis) => analysis.swingPart == 'ADDRESS')
                          .toList(),
                      score: _scoreData['ADDRESS_score']?.toDouble() ?? 0.0,
                    ),
                    ResultTabPage( // Top
                      part: 'TOP',
                      imageFile: _topImageFile,
                      swingAnalysisList: _swingAnalysisList.where((
                          analysis) => analysis.swingPart == 'TOP').toList(),
                      score: _scoreData['TOP_score']?.toDouble() ?? 0.0,
                    ),
                    ResultTabPage( // Contact
                      part: 'CONTACT',
                      imageFile: _contactImageFile,
                      swingAnalysisList: _swingAnalysisList
                          .where((
                          analysis) => analysis.swingPart == 'CONTACT')
                          .toList(),
                      score: _scoreData['CONTACT_score']?.toDouble() ?? 0.0,
                    ),
                  ],
                ),
              ),
              DiagnosisButtonSection(),
            ],
          ),
        ),
      );
    }
  }

  Future<String> _downloadVideo() async {
    final url = _resultJsonData?['download_url'] ?? '';
    if (url.isEmpty) {
      setState(() {
        _errorMessage = '다운로드 URL이 없습니다.';
        _isLoaded = false;
      });
      return '';
    }
    try {
      final response = await http.get(Uri.parse('http://${dotenv.get('ANALYTICS_HOST')}:5005/$url'));

      final String videoPath = '${_appDir.path}/${_fileId}/${_fileId}_output.mp4';
      _videoFile = await File(videoPath).create(recursive: true);
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
      if (!mounted) return '';

      setState(() {
        _controller = controller
          ..play()
          ..setLooping(true);
        _isLoaded = true;
      });
      return videoPath;
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = '영상 다운로드 실패: $e';
          _isLoaded = false;
        });
      }
      return '';
    }
  }

  Future<String> _downloadAddressImage() async {
    _isAddressImageLoading = false;
    final image_url = _resultJsonData?['image_address_url'];
    if (image_url == null || image_url.isEmpty) {
      setState(() => _errorMessage = 'image_address_url이 없습니다');
      return '';
    }

    try {
      http.Response response = await http.get(Uri.parse('http://${dotenv.get('ANALYTICS_HOST')}:5005/$image_url'));

      final String addressDir = '${_appDir.path}/${_fileId}/${_fileId}_output_frame_address.jpg';
      _addressImageFile = await File(addressDir).create(recursive: true);
      await _addressImageFile.writeAsBytes(response.bodyBytes);

      setState(() {
        _isAddressImageLoading = true;
      });
      return addressDir;
    } catch (e) {
      setState(() => _errorMessage = 'image_address 처리 오류: $e');
    } finally {
      setState(() => _isAddressImageLoading = true);
    }
    return '';
  }

  Future<String> _downloadContactImage() async {
    _isContactImageLoading = false;
    final image_url = _resultJsonData?['image_contact_url'];
    if (image_url == null || image_url.isEmpty) {
      setState(() => _errorMessage = 'image_contact_url이 없습니다');
      return '';
    }

    try {
      http.Response response = await http.get(Uri.parse('http://${dotenv.get('ANALYTICS_HOST')}:5005/$image_url'));

      final String contactDir = '${_appDir.path}/${_fileId}/${_fileId}_output_frame_contact.jpg';
      _contactImageFile = await File(contactDir).create(recursive: true);
      await _contactImageFile.writeAsBytes(response.bodyBytes);

      setState(() {
        _isContactImageLoading = true;
      });
      return contactDir;
    } catch (e) {
      setState(() => _errorMessage = 'image_contact 처리 오류: $e');
    } finally {
      setState(() => _isContactImageLoading = true);
    }
    return '';
  }

  Future<String> _downloadTopImage() async {
    _isTopImageLoading = false;
    final image_url = _resultJsonData?['image_top_url'];
    if (image_url == null || image_url.isEmpty) {
      setState(() => _errorMessage = 'image_top_url이 없습니다');
      return '';
    }

    try {
      http.Response response = await http.get(Uri.parse('http://${dotenv.get('ANALYTICS_HOST')}:5005/$image_url'));

      final String topDir = '${_appDir.path}/${_fileId}/${_fileId}_output_frame_top.jpg';
      _topImageFile = await File(topDir).create(recursive: true);
      await _topImageFile.writeAsBytes(response.bodyBytes);

      setState(() {
        _isTopImageLoading = true;
      });
      return topDir;
    } catch (e) {
      setState(() => _errorMessage = 'image_top 처리 오류: $e');
    } finally {
      setState(() => _isTopImageLoading = true);
    }
    return '';
  }

  Future<String> _getSwingAnalysis() async {
    final swingData = _resultJsonData?['swing_analysis'];
    if (swingData == null || swingData.isEmpty) {
      setState(() => _errorMessage = '스윙 분석 데이터가 없습니다');
      return '';
    }
    try {
      final response = await http.get(Uri.parse('http://${dotenv.get('ANALYTICS_HOST')}:5005/$swingData'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _swingAnalysisList = (data as List<dynamic>)
              .map<SwingAnalysis>((item) => SwingAnalysis.fromJson(item as Map<String, dynamic>))
              .toList();
          _errorMessage = null;
          _isSwingAnalysis = true;
        });
        return data.toString();
      } else {
        setState(() => _errorMessage = '서버 응답 오류: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      setState(() => _errorMessage = '스윙 분석 데이터 불러오기 오류: $e');
      return '';
    }
  }

  Future<void> _downloadScore() async {
    final scoreUrl = _resultJsonData?['score_url'];
    if (scoreUrl == null || scoreUrl.isEmpty) {
      setState(() => _errorMessage = 'score_url이 없습니다');
      return;
    }

    try {
      final response = await http.get(Uri.parse('http://${dotenv.get('ANALYTICS_HOST')}:5005/$scoreUrl'));

      if (response.statusCode == 200) {
        var scoreData = jsonDecode(response.body);
        _scoreData = {
          for (var item in scoreData) item.keys.first: item.values.first as double
        };
        setState(() {
          _isScoreLoading = true;
          _errorMessage = null;
        });
      } else {
        setState(() => _errorMessage = '점수 데이터 불러오기 오류: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _errorMessage = '점수 데이터 처리 오류: $e');
    }
  }

  Future<void> _fetchResultData() async {
    try {
        _resultJsonData = {
          "file_id": _fileId,
          "download_url": "/download/video/$_fileId",
          "video_url": "/download/video/$_fileId",
          "zip_url": "/download/images/$_fileId",
          "image_address_url": "/download/image/address/${_fileId}",
          "image_top_url": "/download/image/top/${_fileId}",
          "image_contact_url": "/download/image/contact/${_fileId}",
          "swing_analysis": "/result/${_fileId}",
          "score": _score,
          "score_url": "/score/${_fileId}"
        };

        await _downloadVideo();
        await _getSwingAnalysis();
        await _downloadAddressImage();
        await _downloadTopImage();
        await _downloadContactImage();
        await _downloadScore();
    } catch (e) {
      setState(() {
        _errorMessage = '오류 발생: $e';
        _isLoaded = false;
      });
    }
  }
}

// ================= AppBar 위젯 =================
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      title: const Text(
        '분석결과',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black87),
      actions: [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MainPage()),
                  (route) => false, // 이전 페이지 모두 제거
            );
          },
        ),
      ],
    );
  }
}

// ================= TabBar 위젯 =================
class CustomTabBar extends StatelessWidget {
  const CustomTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      labelColor: Colors.black,
      indicatorColor: Colors.black,
      indicatorSize: TabBarIndicatorSize.tab,
      tabs: [
        Tab(text: 'ADDRESS'),
        Tab(text: 'TOP'),
        Tab(text: 'CONTACT'),
      ],
    );
  }
}

// ================= Motion Result 위젯 =================
class ResultTabPage extends StatelessWidget {
  final String part;
  final File imageFile;
  final List<SwingAnalysis> swingAnalysisList;
  late final String comment;
  final double score;

  ResultTabPage({
    super.key,
    required this.part,
    required this.imageFile,
    required this.swingAnalysisList,
    required this.score,
  }) {
    String tempComment = '스윙 분석 결과: ';
    if (score >= 80) {
      tempComment += '훌륭합니다!';
    } else if (score >= 50) {
      tempComment += '좋습니다.';
    } else if (score >= 30) {
      tempComment += '보통입니다.';
    } else {
      tempComment += '개선이 필요합니다.';
    }
    comment = tempComment;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                comment,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '($score점)',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              // height: 250,
              width: double.infinity,
              color: Colors.grey[300],
              child: Center(
                child: Image.file(imageFile, width: double.infinity, fit: BoxFit.contain),
                // Text(
                //   '이미지 자리',
                //   style: TextStyle(color: Colors.black54),
                // ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          for (final analysis in swingAnalysisList)
            Text(
              analysis.evaluation,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
        ],
      ),
    );
  }
}




