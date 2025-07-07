import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:archive/archive.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:math' as math;

import 'package:golf_coach_app/main_pages/main_page.dart';

class ResultPage extends StatefulWidget {
  final String _videoPath;
  final bool isFrontCamera;
  const ResultPage(this._videoPath, {required this.isFrontCamera});

  @override
  _ResultPageState createState() => _ResultPageState();
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
      posture: json['posture'] ?? 'No Posture',
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
  // List<File> _imageFiles = [];
  File _addressImageFile = File('');
  File _topImageFile = File('');
  File _contactImageFile = File('');

  bool _isAddressImageLoading = false;
  bool _isTopImageLoading = false;
  bool _isContactImageLoading = false;

  // bool _isZipLoading = false;
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

  // Future<void> _downloadAndExtractZip() async {
  //   final zipUrl = _resultJsonData?['zip_url'];
  //   if (zipUrl == null || zipUrl.isEmpty) {
  //     setState(() => _errorMessage = 'ZIP URL이 없습니다');
  //     return;
  //   }
  //   try {
  //     // setState(() => _isZipLoading = true);
  //     final response = await http.get(Uri.parse('http://${dotenv.get('ANALYTICS_HOST')}:5005/$zipUrl'));
  //     final archive = ZipDecoder().decodeBytes(response.bodyBytes);
  //     final tempDir = await getTemporaryDirectory();
  //     final imageFiles = <File>[];
  //     for (final file in archive) {
  //       if (file.isFile && (file.name.endsWith('.png') || file.name.endsWith('.jpg'))) {
  //         final filename = '${tempDir.path}/${file.name}';
  //         final outputFile = File(filename);
  //         await outputFile.create(recursive: true);
  //         await outputFile.writeAsBytes(file.content);
  //         imageFiles.add(outputFile);
  //       }
  //     }
  //     setState(() => _imageFiles = imageFiles.take(3).toList());
  //   } catch (e) {
  //     setState(() => _errorMessage = 'ZIP 처리 오류: $e');
  //   } finally {
  //     setState(() => _isZipLoading = true);
  //   }
  // }

  Future<void> _downloadAddressImage() async {
    _isAddressImageLoading = false;
    final image_url = _resultJsonData?['image_address_url'];
    if (image_url == null || image_url.isEmpty) {
      setState(() => _errorMessage = 'image_address_url이 없습니다');
      return;
    }

    try {
      print(image_url);
      http.Response response = await http.get(Uri.parse('http://${dotenv.get('ANALYTICS_HOST')}:5005/$image_url'));
      Directory tempDir = await getTemporaryDirectory();
      _addressImageFile = File('${tempDir.path}/image_address.png');
      await _addressImageFile.writeAsBytes(response.bodyBytes);
      setState(() {
        _isAddressImageLoading = true;
      });
    } catch (e) {
      setState(() => _errorMessage = 'image_address 처리 오류: $e');
    } finally {
      setState(() => _isAddressImageLoading = true);
    }
  }

  Future<void> _downloadContactImage() async {
    _isContactImageLoading = false;
    final image_url = _resultJsonData?['image_contact_url'];
    if (image_url == null || image_url.isEmpty) {
      setState(() => _errorMessage = 'image_contact_url이 없습니다');
      return;
    }

    try {
      print(image_url);
      http.Response response = await http.get(Uri.parse('http://${dotenv.get('ANALYTICS_HOST')}:5005/$image_url'));
      Directory tempDir = await getTemporaryDirectory();
      _contactImageFile = File('${tempDir.path}/image_contact.png');
      await _contactImageFile?.writeAsBytes(response.bodyBytes);
      setState(() {
        _isContactImageLoading = true;
      });
    } catch (e) {
      setState(() => _errorMessage = 'image_contact 처리 오류: $e');
    } finally {
      setState(() => _isContactImageLoading = true);
    }
  }

  Future<void> _downloadTopImage() async {
    _isTopImageLoading = false;
    final image_url = _resultJsonData?['image_top_url'];
    if (image_url == null || image_url.isEmpty) {
      setState(() => _errorMessage = 'image_top_url이 없습니다');
      return;
    }

    try {
      print(image_url);
      http.Response response = await http.get(Uri.parse('http://${dotenv.get('ANALYTICS_HOST')}:5005/$image_url'));
      Directory tempDir = await getTemporaryDirectory();
      _topImageFile = File('${tempDir.path}/image_top.png');
      await _topImageFile?.writeAsBytes(response.bodyBytes);

      setState(() {
        // _topImageFile = imageFile; // Top 이미지 파일 저장
        _isTopImageLoading = true;
      });
    } catch (e) {
      setState(() => _errorMessage = 'image_top 처리 오류: $e');
    } finally {
      setState(() => _isTopImageLoading = true);
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
        // await _downloadAndExtractZip();
        await _getSwingAnalysis();
        await _downloadAddressImage();
        await _downloadContactImage();
        await _downloadTopImage();
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
    Widget player = AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: VideoPlayer(_controller!),
    );

    // 전면 카메라로 촬영한 영상만 좌우 반전
    if (widget.isFrontCamera) {
      player = Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(math.pi),
        child: player,
      );
    }

    return Container(
      width: double.infinity,
      child: player,
    );
  }

  // Widget _buildImageGrid() {
  //   if (_imageFiles.isEmpty) return const SizedBox();
  //   return Container(
  //     height: MediaQuery.of(context).size.height / 3,
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: _imageFiles.length,
  //       itemBuilder: (ctx, index) => Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Image.file(_imageFiles[index], width: MediaQuery.of(context).size.width * 8 / 10, fit: BoxFit.contain),
  //       ),
  //     ),
  //   );
  // }

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

  Widget DiagnosisButtonSection() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            isScrollControlled: true,
            builder: (context) => DiagnosisBottomSheet(
              score: 84
            )
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

  Widget DiagnosisBottomSheet({required int score}) {
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
                  '스윙 점수 : ${score}점',
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
    final isAllLoaded = _isLoaded && _isSwingAnalysis && _isAddressImageLoading && _isTopImageLoading && _isContactImageLoading;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(),
        body: isAllLoaded ?
        Column(
          children: [
            Divider(height: 1, thickness: 1),
            CustomTabBar(),
            Divider(height: 1, thickness: 1),
            Expanded(
              child: TabBarView(
                children: [
                  ResultTabPage(  // Address
                    part: 'ADDRESS',
                    imageFile: _addressImageFile ?? File(''),
                    swingAnalysisList: _swingAnalysisList.where((analysis) => analysis.swingPart == 'ADDRESS').toList()
                  ),
                  ResultTabPage(  // Top
                    part: 'TOP',
                    imageFile: _topImageFile ?? File(''),
                    swingAnalysisList: _swingAnalysisList.where((analysis) => analysis.swingPart == 'TOP').toList()
                  ),
                  ResultTabPage(  // Contact
                    part: 'CONTACT',
                    imageFile: _contactImageFile ?? File(''),
                    swingAnalysisList: _swingAnalysisList.where((analysis) => analysis.swingPart == 'CONTACT').toList()
                  ),
                ],
              ),
            ),
            // isload 초기화
            DiagnosisButtonSection(),
          ],
        ) : Center(child: CircularProgressIndicator()),
      ),
    );
    // // 모든 데이터가 준비될 때까지 하나의 로딩 아이콘만 표시
    // final isAllLoaded = _isLoaded && _isZipLoading && _isSwingAnalysis;
    // return Scaffold(
    //   appBar: AppBar(title: const Text('처리 결과')),
    //   body: isAllLoaded
    //       ? SingleChildScrollView(
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.stretch,
    //             children: [
    //               if (_errorMessage != null)
    //                 Center(child: Text(_errorMessage!, style: TextStyle(color: Colors.red)))
    //               else
    //                 Center(child: Text('결과 데이터가 성공적으로 로드되었습니다!')),
    //               _buildVideoPlayer(),
    //               _buildImageGrid(),
    //               _buildAnalysisList(),
    //             ],
    //           ),
    //         )
    //       : Center(child: CircularProgressIndicator()),
    // );
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
  late final double score;

  ResultTabPage({
    super.key,
    required this.part,
    required this.imageFile,
    required this.swingAnalysisList,
  }) {
    var score_table = {
      'correct_midpoint': 15,
      'correct_arm_angle': 20,
      'correct_pelvis': 25,
      'correct_head': 15,
      'correct_shoulder_ankle': 15,
      'correct_knee_angle': 10
    };

    double totalScore = 0;
    double maxScore = 0;
    for (final analysis in swingAnalysisList) {
      // 예시: 각 스윙 파트에 따라 점수를 계산
      if (analysis.evaluation.contains('정확')) {
        totalScore += score_table[analysis.posture] ?? 0;
      } else {
        maxScore += score_table[analysis.posture] ?? 0;
      }
    }
    maxScore += totalScore;
    if (totalScore != 0) {
      totalScore = (totalScore / maxScore) * 100; // 백분율로 변환
    }
    print('Total Score: $totalScore');

    String tempComment = '스윙 분석 결과: ';
    if (totalScore >= 80) {
      tempComment += '훌륭합니다!';
    } else if (totalScore >= 50) {
      tempComment += '좋습니다.';
    } else if (totalScore >= 30) {
      tempComment += '보통입니다.';
    } else {
      tempComment += '개선이 필요합니다.';
    }
    score = totalScore;
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
