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
      evaluation: _translateEvaluation(json['evaluation'] ?? 'No Evaluation'),
    );
  }

  // 영어 피드백을 한국어로 번역하는 함수
  static String _translateEvaluation(String evaluation) {
    // 일반적인 골프 스윙 피드백 번역
    Map<String, String> translations = {
      // 정확한 자세
      'correct_pelvis': '골반 위치가 정확합니다.',
      'correct_arm_angle': '팔 각도가 적절합니다.',
      'correct_head': '머리 위치가 좋습니다.',
      'correct_shoulder_ankle': '어깨와 발목 정렬이 정확합니다.',
      'correct_knee_angle': '무릎 각도가 적절합니다.',
      'correct_midpoint': '중점 위치가 정확합니다.',
      'correct_posture': '자세가 올바릅니다.',
      'correct_balance': '균형이 좋습니다.',
      'correct_grip': '그립이 적절합니다.',
      'correct_stance': '스탠스가 정확합니다.',

      // 잘못된 자세
      'incorrect_pelvis': '골반 위치를 조정해주세요.',
      'incorrect_arm_angle': '팔 각도를 개선해주세요.',
      'incorrect_head': '머리 위치를 조정해주세요.',
      'incorrect_shoulder_ankle': '어깨와 발목 정렬을 개선해주세요.',
      'incorrect_knee_angle': '무릎 각도를 조정해주세요.',
      'incorrect_midpoint': '중점 위치를 개선해주세요.',
      'incorrect_posture': '자세를 개선해주세요.',
      'incorrect_balance': '균형을 조정해주세요.',
      'incorrect_grip': '그립을 수정해주세요.',
      'incorrect_stance': '스탠스를 조정해주세요.',

      // 일반적인 피드백
      'too_fast': '스윙이 너무 빠릅니다.',
      'too_slow': '스윙이 너무 느립니다.',
      'good_tempo': '스윙 템포가 좋습니다.',
      'weight_shift': '체중 이동을 개선해주세요.',
      'good_weight_shift': '체중 이동이 좋습니다.',
      'follow_through': '팔로우 스루를 완성해주세요.',
      'good_follow_through': '팔로우 스루가 좋습니다.',
    };

    // 정확한 매칭이 있으면 번역된 텍스트 반환
    if (translations.containsKey(evaluation)) {
      return translations[evaluation]!;
    }

    // 부분 매칭 시도
    for (String key in translations.keys) {
      if (evaluation.toLowerCase().contains(key.toLowerCase())) {
        return translations[key]!;
      }
    }

    // 번역이 없으면 원본 텍스트 반환
    return evaluation;
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

  bool _isVideoLoading = false;
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
  void initState() {
    super.initState();
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
            builder: (context) => DiagnosisBottomSheet());
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

  Widget buildLoadingScreen() {
    int totalTasks = 6;
    int completedTasks = (_isAddressImageLoading ? 1 : 0) +
        (_isTopImageLoading ? 1 : 0) +
        (_isContactImageLoading ? 1 : 0) +
        (_isVideoLoading ? 1 : 0) +
        (_isScoreLoading ? 1 : 0) +
        (_isSwingAnalysis ? 1 : 0);
    double progress = (completedTasks / totalTasks) * 100;

    // 디버깅 정보
    List<String> completedList = [];
    List<String> pendingList = [];

    if (_isAddressImageLoading)
      completedList.add('주소 이미지');
    else
      pendingList.add('주소 이미지');

    if (_isTopImageLoading)
      completedList.add('탑 이미지');
    else
      pendingList.add('탑 이미지');

    if (_isContactImageLoading)
      completedList.add('컨택트 이미지');
    else
      pendingList.add('컨택트 이미지');

    if (_isVideoLoading)
      completedList.add('영상');
    else
      pendingList.add('영상');

    if (_isScoreLoading)
      completedList.add('점수 데이터');
    else
      pendingList.add('점수 데이터');

    if (_isSwingAnalysis)
      completedList.add('스윙 분석');
    else
      pendingList.add('스윙 분석');

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                value: completedTasks / totalTasks,
              ),
              SizedBox(height: 16),
              Text(
                '분석 데이터 로딩 중... ${progress.toStringAsFixed(0)}%',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              if (completedList.isNotEmpty) ...[
                Text(
                  '완료: ${completedList.join(', ')}',
                  style: TextStyle(fontSize: 12, color: Colors.green[600]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
              ],
              if (pendingList.isNotEmpty) ...[
                Text(
                  '대기: ${pendingList.join(', ')}',
                  style: TextStyle(fontSize: 12, color: Colors.orange[600]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
              ],
              if (_errorMessage != null) ...[
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    border: Border.all(color: Colors.red[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '오류: $_errorMessage',
                    style: TextStyle(fontSize: 12, color: Colors.red[700]),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 16),
              ],
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isAddressImageLoading = false;
                    _isTopImageLoading = false;
                    _isContactImageLoading = false;
                    _isVideoLoading = false;
                    _isScoreLoading = false;
                    _isSwingAnalysis = false;
                    _errorMessage = null;
                  });
                  _fetchResultData();
                },
                child: Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 최소한의 데이터가 로딩되면 결과 화면 표시
    int completedTasks = (_isAddressImageLoading ? 1 : 0) +
        (_isTopImageLoading ? 1 : 0) +
        (_isContactImageLoading ? 1 : 0) +
        (_isVideoLoading ? 1 : 0) +
        (_isScoreLoading ? 1 : 0) +
        (_isSwingAnalysis ? 1 : 0);

    // 3개 이상의 작업이 완료되면 결과 화면 표시
    _isLoaded = completedTasks >= 3;

    if (!_isLoaded) {
      print(
          'Loading state: Address: $_isAddressImageLoading, Top: $_isTopImageLoading, Contact: $_isContactImageLoading, Video: $_isVideoLoading, Score: $_isScoreLoading, Swing Analysis: $_isSwingAnalysis');
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(),
        body: Center(
          child: _errorMessage != null
              ? Text(_errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 16))
              : buildLoadingScreen(),
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
                    ResultTabPage(
                      // Address
                      part: 'ADDRESS',
                      imageFile: _addressImageFile,
                      swingAnalysisList: _swingAnalysisList
                          .where((analysis) => analysis.swingPart == 'ADDRESS')
                          .toList(),
                      score:
                          _scoreData['ADDRESS_score']?.toDouble() ?? _score / 3,
                      isImageLoaded: _isAddressImageLoading,
                    ),
                    ResultTabPage(
                      // Top
                      part: 'TOP',
                      imageFile: _topImageFile,
                      swingAnalysisList: _swingAnalysisList
                          .where((analysis) => analysis.swingPart == 'TOP')
                          .toList(),
                      score: _scoreData['TOP_score']?.toDouble() ?? _score / 3,
                      isImageLoaded: _isTopImageLoading,
                    ),
                    ResultTabPage(
                      // Contact
                      part: 'CONTACT',
                      imageFile: _contactImageFile,
                      swingAnalysisList: _swingAnalysisList
                          .where((analysis) => analysis.swingPart == 'CONTACT')
                          .toList(),
                      score:
                          _scoreData['CONTACT_score']?.toDouble() ?? _score / 3,
                      isImageLoaded: _isContactImageLoading,
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
        _isVideoLoading = false;
      });
      return '';
    }
    try {
      print(
          'Downloading video from: http://${dotenv.get('ANALYTICS_HOST')}:5005/$url');
      final response = await http.get(
        Uri.parse('http://${dotenv.get('ANALYTICS_HOST')}:5005/$url'),
        headers: {'Connection': 'keep-alive'},
      ).timeout(Duration(seconds: 60));

      if (response.statusCode == 200) {
        final String videoPath =
            '${_appDir.path}/${_fileId}/${_fileId}_output.mp4';
        _videoFile = await File(videoPath).create(recursive: true);
        await _videoFile?.writeAsBytes(response.bodyBytes);

        final controller = VideoPlayerController.file(_videoFile!);
        // 영상 초기화 및 실패 대응
        await controller.initialize().catchError((e) {
          if (mounted) {
            setState(() {
              _errorMessage = '영상 로딩 실패: $e';
              _isVideoLoading = false;
            });
          }
          throw e; // 필요시 주석 처리
        });
        if (!mounted) return '';

        setState(() {
          _controller = controller
            ..play()
            ..setLooping(true);
          _isVideoLoading = true;
          _errorMessage = null;
        });
        print('Video downloaded and initialized successfully');
        return videoPath;
      } else {
        setState(() {
          _errorMessage = '영상 다운로드 실패: HTTP ${response.statusCode}';
          _isVideoLoading = true; // 실패해도 로딩 상태를 true로 설정하여 진행
        });
        return '';
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = '영상 다운로드 실패: $e';
          _isVideoLoading = true; // 실패해도 로딩 상태를 true로 설정하여 진행
        });
      }
      print('Video download error: $e');
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
      print(
          'Downloading address image from: http://${dotenv.get('ANALYTICS_HOST')}:5005/$image_url');
      http.Response response = await http.get(
        Uri.parse('http://${dotenv.get('ANALYTICS_HOST')}:5005/$image_url'),
        headers: {'Connection': 'keep-alive'},
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final String addressDir =
            '${_appDir.path}/${_fileId}/${_fileId}_output_frame_address.jpg';
        _addressImageFile = await File(addressDir).create(recursive: true);
        await _addressImageFile.writeAsBytes(response.bodyBytes);

        setState(() {
          _isAddressImageLoading = true;
          _errorMessage = null;
        });
        print('Address image downloaded successfully');
        return addressDir;
      } else {
        setState(() =>
            _errorMessage = '주소 이미지 다운로드 실패: HTTP ${response.statusCode}');
        return '';
      }
    } catch (e) {
      setState(() => _errorMessage = '주소 이미지 처리 오류: $e');
      print('Address image download error: $e');
      // 실패해도 로딩 상태를 true로 설정하여 진행
      setState(() => _isAddressImageLoading = true);
      return '';
    }
  }

  Future<String> _downloadContactImage() async {
    _isContactImageLoading = false;
    final image_url = _resultJsonData?['image_contact_url'];
    if (image_url == null || image_url.isEmpty) {
      setState(() => _errorMessage = 'image_contact_url이 없습니다');
      return '';
    }

    try {
      print(
          'Downloading contact image from: http://${dotenv.get('ANALYTICS_HOST')}:5005/$image_url');
      http.Response response = await http.get(
        Uri.parse('http://${dotenv.get('ANALYTICS_HOST')}:5005/$image_url'),
        headers: {'Connection': 'keep-alive'},
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final String contactDir =
            '${_appDir.path}/${_fileId}/${_fileId}_output_frame_contact.jpg';
        _contactImageFile = await File(contactDir).create(recursive: true);
        await _contactImageFile.writeAsBytes(response.bodyBytes);

        setState(() {
          _isContactImageLoading = true;
          _errorMessage = null;
        });
        print('Contact image downloaded successfully');
        return contactDir;
      } else {
        setState(() =>
            _errorMessage = '컨택트 이미지 다운로드 실패: HTTP ${response.statusCode}');
        return '';
      }
    } catch (e) {
      setState(() => _errorMessage = '컨택트 이미지 처리 오류: $e');
      print('Contact image download error: $e');
      // 실패해도 로딩 상태를 true로 설정하여 진행
      setState(() => _isContactImageLoading = true);
      return '';
    }
  }

  Future<String> _downloadTopImage() async {
    _isTopImageLoading = false;
    final image_url = _resultJsonData?['image_top_url'];
    if (image_url == null || image_url.isEmpty) {
      setState(() => _errorMessage = 'image_top_url이 없습니다');
      return '';
    }

    try {
      print(
          'Downloading top image from: http://${dotenv.get('ANALYTICS_HOST')}:5005/$image_url');
      http.Response response = await http.get(
        Uri.parse('http://${dotenv.get('ANALYTICS_HOST')}:5005/$image_url'),
        headers: {'Connection': 'keep-alive'},
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final String topDir =
            '${_appDir.path}/${_fileId}/${_fileId}_output_frame_top.jpg';
        _topImageFile = await File(topDir).create(recursive: true);
        await _topImageFile.writeAsBytes(response.bodyBytes);

        setState(() {
          _isTopImageLoading = true;
          _errorMessage = null;
        });
        print('Top image downloaded successfully');
        return topDir;
      } else {
        setState(
            () => _errorMessage = '탑 이미지 다운로드 실패: HTTP ${response.statusCode}');
        return '';
      }
    } catch (e) {
      setState(() => _errorMessage = '탑 이미지 처리 오류: $e');
      print('Top image download error: $e');
      // 실패해도 로딩 상태를 true로 설정하여 진행
      setState(() => _isTopImageLoading = true);
      return '';
    }
  }

  Future<String> _getSwingAnalysis() async {
    final swingData = _resultJsonData?['swing_analysis'];
    if (swingData == null || swingData.isEmpty) {
      print('Swing analysis URL is empty, creating default analysis');
      // 기본 스윙 분석 데이터 생성
      setState(() {
        _swingAnalysisList = [
          SwingAnalysis(
            swingPart: 'ADDRESS',
            posture: 'address_position',
            evaluation: '스윙 분석을 위한 기본 피드백입니다. 정확한 분석을 위해 더 나은 영상을 촬영해주세요.',
          ),
          SwingAnalysis(
            swingPart: 'TOP',
            posture: 'backswing_position',
            evaluation: '백스윙 시 팔꿈치를 펴고 어깨를 회전시켜주세요.',
          ),
          SwingAnalysis(
            swingPart: 'CONTACT',
            posture: 'impact_position',
            evaluation: '임팩트 시 체중을 앞쪽으로 이동하고 팔을 펴주세요.',
          ),
        ];
        _errorMessage = null;
        _isSwingAnalysis = true;
      });
      return 'default_analysis';
    }
    try {
      print(
          'Downloading swing analysis from: http://${dotenv.get('ANALYTICS_HOST')}:5005/$swingData');
      final response = await http.get(
        Uri.parse('http://${dotenv.get('ANALYTICS_HOST')}:5005/$swingData'),
        headers: {'Connection': 'keep-alive'},
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Raw swing analysis data: $data');
        print('Data type: ${data.runtimeType}');

        setState(() {
          if (data is List && data.isNotEmpty) {
            _swingAnalysisList = data
                .map<SwingAnalysis>((item) =>
                    SwingAnalysis.fromJson(item as Map<String, dynamic>))
                .toList();
          } else if (data is Map && data.containsKey('error')) {
            // 서버에서 오류 응답이 올 경우
            _swingAnalysisList = [
              SwingAnalysis(
                swingPart: 'INFO',
                posture: '분석 정보',
                evaluation: '분석 결과가 아직 준비되지 않았습니다. 분석이 완료되면 자동으로 업데이트됩니다.',
              ),
            ];
          } else {
            // 서버에서 빈 배열이나 잘못된 데이터가 올 경우 기본 데이터 사용
            _swingAnalysisList = [
              SwingAnalysis(
                swingPart: 'ADDRESS',
                posture: 'address_position',
                evaluation: '스윙 분석을 위한 기본 피드백입니다. 정확한 분석을 위해 더 나은 영상을 촬영해주세요.',
              ),
              SwingAnalysis(
                swingPart: 'TOP',
                posture: 'backswing_position',
                evaluation: '백스윙 시 팔꿈치를 펴고 어깨를 회전시켜주세요.',
              ),
              SwingAnalysis(
                swingPart: 'CONTACT',
                posture: 'impact_position',
                evaluation: '임팩트 시 체중을 앞쪽으로 이동하고 팔을 펴주세요.',
              ),
            ];
          }
          _errorMessage = null;
          _isSwingAnalysis = true;
        });
        print(
            'Swing analysis processed successfully: ${_swingAnalysisList.length} items');
        return data.toString();
      } else if (response.statusCode == 404) {
        print('Analysis result not found (404)');
        // 404 오류는 분석이 아직 완료되지 않았음을 의미
        setState(() {
          _swingAnalysisList = [
            SwingAnalysis(
              swingPart: 'INFO',
              posture: 'analysis_in_progress',
              evaluation: '골프 스윙 분석이 진행 중입니다. 완료되면 자동으로 결과가 표시됩니다.',
            ),
            SwingAnalysis(
              swingPart: 'TIP',
              posture: 'general_tips',
              evaluation: '정확한 분석을 위해 스윙 전체가 잘 보이도록 촬영해주세요.',
            ),
          ];
          _errorMessage = null;
          _isSwingAnalysis = true;
        });
        return 'analysis_in_progress';
      } else {
        print('Server response error: ${response.statusCode}');
        setState(() =>
            _errorMessage = '스윙 분석 데이터 서버 응답 오류: HTTP ${response.statusCode}');
        // 오류 시에도 기본 데이터 설정
        setState(() {
          _swingAnalysisList = [
            SwingAnalysis(
              swingPart: 'ERROR',
              posture: 'server_error',
              evaluation: '분석 서버 연결에 문제가 있습니다. 나중에 다시 시도해주세요.',
            ),
          ];
          _isSwingAnalysis = true;
        });
        return '';
      }
    } catch (e) {
      print('Swing analysis download error: $e');
      setState(() => _errorMessage = '스윙 분석 데이터 불러오기 오류: $e');
      // 오류 시에도 기본 데이터 설정
      setState(() {
        _swingAnalysisList = [
          SwingAnalysis(
            swingPart: 'ERROR',
            posture: 'network_error',
            evaluation: '네트워크 연결에 문제가 있습니다. 인터넷 연결을 확인해주세요.',
          ),
        ];
        _isSwingAnalysis = true;
      });
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
      print(
          'Downloading score data from: http://${dotenv.get('ANALYTICS_HOST')}:5005/$scoreUrl');
      final response = await http.get(
        Uri.parse('http://${dotenv.get('ANALYTICS_HOST')}:5005/$scoreUrl'),
        headers: {'Connection': 'keep-alive'},
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        var scoreData = jsonDecode(response.body);
        _scoreData = {
          for (var item in scoreData)
            item.keys.first: item.values.first as double
        };
        setState(() {
          _isScoreLoading = true;
          _errorMessage = null;
        });
        print('Score data downloaded successfully');
      } else {
        setState(() =>
            _errorMessage = '점수 데이터 불러오기 오류: HTTP ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _errorMessage = '점수 데이터 처리 오류: $e');
      print('Score data download error: $e');
      // 실패해도 로딩 상태를 true로 설정하여 진행
      setState(() => _isScoreLoading = true);
    }
  }

  Future<void> _fetchResultData() async {
    _appDir = await getTemporaryDirectory();
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

      print('Starting data fetch for file ID: $_fileId');
      print('Analytics host: ${dotenv.get('ANALYTICS_HOST')}');

      // 순차적으로 데이터 다운로드 (병렬 대신)
      await _downloadVideo();
      await _getSwingAnalysis();
      await _downloadAddressImage();
      await _downloadTopImage();
      await _downloadContactImage();
      await _downloadScore();

      print('All data fetch completed');

      // 모든 작업이 완료되었는지 확인
      if (_isAddressImageLoading &&
          _isTopImageLoading &&
          _isContactImageLoading &&
          _isVideoLoading &&
          _isScoreLoading &&
          _isSwingAnalysis) {
        print('All tasks completed successfully');
      } else {
        print('Some tasks failed to complete');
        setState(() {
          _errorMessage = '일부 데이터 로딩이 실패했습니다. 다시 시도해주세요.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '데이터 로딩 중 오류 발생: $e';
        _isLoaded = false;
      });
      print('Data fetch error: $e');
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
  final bool isImageLoaded;

  ResultTabPage({
    super.key,
    required this.part,
    required this.imageFile,
    required this.swingAnalysisList,
    required this.score,
    this.isImageLoaded = true,
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
          Text(
            textAlign: TextAlign.left,
            comment,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            textAlign: TextAlign.left,
            '(${score.toStringAsFixed(2)}점)',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              // height: 250,
              width: double.infinity,
              color: Colors.grey[300],
              child: Center(
                child: isImageLoaded && imageFile.existsSync()
                    ? Image.file(imageFile,
                        width: double.infinity, fit: BoxFit.contain)
                    : Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_not_supported,
                                size: 50, color: Colors.grey[600]),
                            SizedBox(height: 10),
                            Text(
                              '이미지 로딩 중...',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 14),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (swingAnalysisList.isNotEmpty) ...[
            for (final analysis in swingAnalysisList)
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${analysis.swingPart} - ${analysis.posture}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      analysis.evaluation,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
          ] else ...[
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Column(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange[600], size: 24),
                  SizedBox(height: 8),
                  Text(
                    '분석 데이터가 아직 준비되지 않았습니다.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.orange[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '잠시 후 다시 시도해주세요.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
