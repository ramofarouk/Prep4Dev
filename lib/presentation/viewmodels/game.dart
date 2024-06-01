import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prep_for_dev/data/repositories/question_impl.dart';

import '../../domain/usecases/validate_question.dart';

final gameViewModelProvider = ChangeNotifierProvider<GameViewModel>((ref) {
  final repository = ref.read(questionRepositoryProvider);
  return GameViewModel(
    validateQuestionUseCase: ValidateQuestionUseCase(repository),
  );
});

class GameViewModel extends ChangeNotifier {
  int score = 0;
  int index = 0;
  bool isLoading = false;
  int answerIndexClicked = 99;
  bool answerState = false;
  bool isClicked = false;
  String comments = "";

  bool isRecorded = false;
  final Codec _codec = Codec.aacMP4;
  String _mPath = 'tau_file.mp4';
  FlutterSoundPlayer? mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? mRecorder = FlutterSoundRecorder();
  bool mPlayerIsInited = false;
  bool mRecorderIsInited = false;
  bool mplaybackReady = false;

  final ValidateQuestionUseCase validateQuestionUseCase;

  GameViewModel({required this.validateQuestionUseCase}) {
    initializePath();
  }

  initializePath() async {
    var tempDir = await getTemporaryDirectory();
    _mPath = '${tempDir.path}/tau_file.mp4';

    mPlayer!.openPlayer().then((value) {
      mPlayerIsInited = true;
    });

    openTheRecorder().then((value) {
      mRecorderIsInited = true;
    });
    notifyListeners();
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException(
            "Permission d'accès au microphone non accordée");
      }
    }
    await mRecorder!.openRecorder();

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    mRecorderIsInited = true;

    notifyListeners();
  }

  void record() async {
    isRecorded = false;
    await mRecorder!.startRecorder(
      toFile: _mPath,
      codec: _codec,
    );
    notifyListeners();
  }

  void stopRecorder() async {
    await mRecorder!.stopRecorder().then((value) {
      mplaybackReady = true;
      isRecorded = true;
    });
    notifyListeners();
  }

  void playRecord() async {
    assert(mPlayerIsInited &&
        mplaybackReady &&
        mRecorder!.isStopped &&
        mPlayer!.isStopped);
    await mPlayer!.startPlayer(fromURI: _mPath, whenFinished: () {});
    notifyListeners();
  }

  void stopPlayer() async {
    await mPlayer!.stopPlayer();
    notifyListeners();
  }

  getRecorderFn() {
    if (!mRecorderIsInited || !mPlayer!.isStopped) {
      return null;
    }
    return mRecorder!.isStopped ? record : stopRecorder;
  }

  getPlaybackFn() {
    if (!mPlayerIsInited || !mplaybackReady || !mRecorder!.isStopped) {
      return null;
    }
    return mPlayer!.isStopped ? playRecord : stopPlayer;
  }

  void onDispose() {
    mPlayer!.closePlayer();
    mPlayer = null;

    mRecorder!.closeRecorder();
    mRecorder = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void changeIndex() {
    index += 1;
    isClicked = false;
    answerIndexClicked = 99;
    comments = "";
    isRecorded = false;
    mplaybackReady = false;
    notifyListeners();
  }

  void addScore(int score) {
    this.score += score;
    notifyListeners();
  }

  void changeAnswerClicked(int answerIndexClicked) {
    this.answerIndexClicked = answerIndexClicked;
    notifyListeners();
  }

  void changeIsClicked(bool isClicked) {
    this.isClicked = isClicked;
    notifyListeners();
  }

  void changeAnswerState(bool answerState) {
    this.answerState = answerState;
    notifyListeners();
  }

  void clearComments() {
    comments = "";
    notifyListeners();
  }

  void reset() {
    score = 0;
    index = 0;
    isLoading = false;
    answerIndexClicked = 99;
    isClicked = false;
    comments = "";
    notifyListeners();
  }

  Future<bool> validateQuestion(String question, String answer) async {
    Uint8List? bytes;
    if (isRecorded) {
      File fileToSend = File(_mPath);
      bytes = await fileToSend.readAsBytes();
    }

    bool isCorrect = false;
    String comment = "";
    try {
      (isCorrect, comment) =
          await validateQuestionUseCase.execute(question, answer, bytes);
      if (isCorrect) {
        score += 1;
      }
      comments = comment;
      notifyListeners();
      return true;
    } catch (e) {
      //
    } finally {
      isLoading = false;
      notifyListeners();
    }

    return false;
  }
}
