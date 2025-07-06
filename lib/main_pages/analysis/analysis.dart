import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:video_trimmer/video_trimmer.dart';
import 'result.dart';
import 'package:golf_coach_app/main_pages/analysis/result_ui.dart';

class AnalysisPage extends StatefulWidget {
  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isRecording = false;
  bool _isEditing = false;
  Duration _recordingDuration = Duration.zero;  // 촬영 시간을 저장할 변수
  Timer? _timer;  // 타이머 변수
  String? _videoPath;
  VideoPlayerController? _videoController;
  double _startTrim = 0.0;
  double _endTrim = 0.0;
  Trimmer? _trimmer;
  bool _isTrimming = false;

  List<CameraDescription> _cameras = [];
  int _selectedCameraIdx = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera([int? cameraIdx]) async {
    // 카메라 권한 요청
    final status = await Permission.camera.request();
    if (status.isDenied) {
      return;
    }

    // 사용 가능한 카메라 목록 가져오기
    _cameras = await availableCameras();
    if (_cameras.isEmpty) return;
    int frontIdx = _cameras.indexWhere((c) => c.lensDirection == CameraLensDirection.front);
    int selectedIdx = cameraIdx ?? (frontIdx != -1 ? frontIdx : 0);
    if (selectedIdx >= _cameras.length) selectedIdx = 0;
    _selectedCameraIdx = selectedIdx;
    final selectedCamera = _cameras[_selectedCameraIdx];

    _controller?.dispose();
    _controller = CameraController(
      selectedCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      await _controller!.prepareForVideoRecording();  // 비디오 로딩 최적화
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print('카메라 초기화 실패: $e');
    }
  }

  Future<void> _stopRecording() async {
    if (!_controller!.value.isRecordingVideo) {
      return;
    }
    try {
      final XFile video = await _controller!.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _timer?.cancel();
        _recordingDuration = Duration.zero;
        _videoPath = video.path;
        _isEditing = true;
      });
      _trimmer = Trimmer();
      await _trimmer!.loadVideo(videoFile: File(_videoPath!));
      setState(() {});
      print('영상이 저장되었습니다: $_videoPath');
    } catch (e) {
      print('촬영 중지 실패: $e');
      setState(() {
        _isEditing = false;
        _trimmer = null;
        _videoPath = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('영상 파일을 불러오지 못했습니다. 다시 시도해 주세요.')),
      );
    }
  }

  Future<void> _startRecording() async {
    if (!_controller!.value.isInitialized) return;
    try {
      await _controller!.startVideoRecording();
      setState(() {
        _isRecording = true;
        _recordingDuration = Duration.zero;
        _timer = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            _recordingDuration += Duration(seconds: 1);
          });
        });
      });
    } catch (e) {
      print('촬영 시작 실패: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();  // 타이머 정리
    _controller?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  // 촬영 시간을 문자열로 변환하는 함수
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_isEditing && _trimmer != null) {
      final controller = _trimmer!.videoPlayerController!;
      final videoSize = controller.value.size;
      return Scaffold(
        body: SizedBox.expand(
          child: Stack(
            children: [
              // 영상 미리보기(화면 전체, 비율 유지, 잘림 없이)
              Positioned.fill(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: videoSize.width,
                    height: videoSize.height,
                    child: VideoViewer(trimmer: _trimmer!),
                  ),
                ),
              ),
              // TrimViewer (하단 오버레이)
              Positioned(
                left: 0,
                right: 0,
                bottom: 90,
                child: TrimViewer(
                  trimmer: _trimmer!,
                  viewerHeight: 50.0,
                  viewerWidth: MediaQuery.of(context).size.width,
                  maxVideoLength: const Duration(seconds: 60),
                  // numberOfFrames: 60,
                  onChangeStart: (value) async {
                    setState(() => _startTrim = value);
                    final controller = _trimmer!.videoPlayerController;
                    if (controller != null) {
                      await controller.seekTo(Duration(milliseconds: (value * controller.value.duration.inMilliseconds).toInt()));
                    }
                  },
                  onChangeEnd: (value) => setState(() => _endTrim = value),
                  onChangePlaybackState: (value) => setState(() => _isRecording = value),
                ),
              ),
              // SAVE + 재생/정지 버튼 (하단 오버레이)
              Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: _isRecording
                          ? Icon(Icons.pause, size: 40.0, color: Colors.white)
                          : Icon(Icons.play_arrow, size: 40.0, color: Colors.white),
                      onPressed: () async {
                        bool playbackState = await _trimmer!.videoPlaybackControl(
                          startValue: _startTrim,
                          endValue: _endTrim,
                        );
                        setState(() {
                          _isRecording = playbackState;
                        });
                      },
                    ),
                    SizedBox(width: 24),
                    ElevatedButton(
                      onPressed: _isTrimming
                          ? null
                          : () async {
                              setState(() {
                                _isTrimming = true;
                              });
                              await _trimmer!.saveTrimmedVideo(
                                startValue: _startTrim,
                                endValue: _endTrim,
                                onSave: (outputPath) {
                                  setState(() {
                                    _isTrimming = false;
                                  });
                                  if (outputPath != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('성공적으로 저장되었습니다.')),
                                    );
                                    print('트리밍 완료: $outputPath');
                                    _videoPath = outputPath;
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('트리밍 실패!')),
                                    );
                                  }
                                },
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResultPage(_videoPath!),
                                  // builder: (context) => ResultUIPage(_videoPath!),
                                ),
                              );
                            },
                      child: Text(
                        "저장",
                        style: TextStyle(color: Colors.green),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      ),
                    ),
                  ],
                ),
              ),
              // 진행 표시 (상단 오버레이)
              if (_isTrimming)
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: LinearProgressIndicator(),
                ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // 카메라 미리보기
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller!.value.previewSize!.height,
                height: _controller!.value.previewSize!.width,
                child: CameraPreview(_controller!),
              ),
            ),
          ),
          // 안내 문구
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  _isRecording 
                    ? _formatDuration(_recordingDuration)  // 촬영 시간 표시
                    : '촬영을 시작한 후\n아래와 같은 자세를 취해주세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: _isRecording ? 48 : 18,  // 촬영 중일 때는 더 큰 글씨
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.white,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 골퍼 실루엣 가이드라인
          if (!_isRecording)
            Center(
              child: Opacity(
                opacity: 0.4,
                child: Image.asset(
                  'assets/guide_golfer.png',
                  width: MediaQuery.of(context).size.width * 3.0,
                  height: MediaQuery.of(context).size.height * 3.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          // 촬영 버튼
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: () async {
                  if (_isRecording) {
                    await _stopRecording(); // 녹화 종료 및 편집 모드 진입
                  } else {
                    await _startRecording(); // 녹화 시작
                  }
                },
                child: Icon(
                  _isRecording ? Icons.stop : Icons.camera_alt,
                  size: 36,
                  color: _isRecording ? Colors.red : Colors.black,
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}