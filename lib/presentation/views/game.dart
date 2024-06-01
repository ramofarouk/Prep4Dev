import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prep_for_dev/core/utils/app_helpers.dart';
import 'package:prep_for_dev/presentation/viewmodels/game.dart';
import 'package:prep_for_dev/presentation/widgets/answer.dart';
import 'package:prep_for_dev/presentation/widgets/simple_button.dart';
import 'package:prep_for_dev/themes/app_theme.dart';

import '../viewmodels/home.dart';

class GameView extends ConsumerWidget {
  GameView({super.key});
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameViewModel = ref.watch(gameViewModelProvider);
    final homeViewModel = ref.watch(homeViewModelProvider);

    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SimpleButton(
            color: AppTheme.primaryColor,
            textColor: Colors.white,
            text: (gameViewModel.index < homeViewModel.questions.length - 1)
                ? "NEXT QUESTION"
                : "FINISH",
            onPressed: () {
              if (gameViewModel.index < homeViewModel.questions.length - 1) {
                _descriptionController.clear();
                gameViewModel.changeIndex();
              } else {
                Navigator.pop(context);
              }
            }),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: size.height * 0.8,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              margin: EdgeInsets.only(top: size.height * 0.1),
              alignment: Alignment.center,
              child: ListView(
                children: [
                  Text(
                    "QUESTION ${gameViewModel.index + 1}/${homeViewModel.questions.length}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppTheme.primaryColor.withOpacity(0.4),
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    homeViewModel.questions[gameViewModel.index].label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  AppHelpers.getSpacerHeight(3),
                  Visibility(
                      visible: homeViewModel
                          .questions[gameViewModel.index].answers.isNotEmpty,
                      child: mcqSection(homeViewModel, gameViewModel)),
                  Visibility(
                      visible: homeViewModel
                          .questions[gameViewModel.index].answers.isEmpty,
                      child: questionSection(
                          size, homeViewModel, gameViewModel, context)),
                ],
              ),
            ),
            topSection(context, size, homeViewModel, gameViewModel)
          ],
        ),
      ),
    );
  }

  Widget topSection(BuildContext context, size, homeViewModel, gameViewModel) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
          child: Card(
            elevation: 8,
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: size.height * 0.07,
              width: size.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Text(
                "${homeViewModel.technologyChoosen} - ${homeViewModel.level}",
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
          ),
        ),
        Positioned(
            top: 30,
            left: 0,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                  side:
                      const BorderSide(width: 2, color: AppTheme.primaryColor)),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "${gameViewModel.score}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                        fontSize: 20),
                  ),
                ),
              ),
            )),
        Positioned(
            top: 45,
            right: 0,
            child: GestureDetector(
              onTap: () {
                quitGame(context, size);
              },
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 20,
                    child: FaIcon(
                      FontAwesomeIcons.xmark,
                      color: Colors.white,
                    )),
              ),
            ))
      ],
    );
  }

  Widget mcqSection(homeViewModel, gameViewModel) {
    return Column(children: [
      ...homeViewModel.questions[gameViewModel.index].answers
          .map((answer) => AnswerWidget(
                answerModel: answer,
                indexAnswer: homeViewModel
                    .questions[gameViewModel.index].answers
                    .indexOf(answer),
              ))
          .toList()
    ]);
  }

  Widget questionSection(size, homeViewModel, gameViewModel, context) {
    return Column(children: [
      TextFormField(
        maxLines: 4,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: "Write your answer here",
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: AppTheme.primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        controller: _descriptionController,
        keyboardType: TextInputType.text,
        maxLength: 500,
      ),
      gameViewModel.comments.isNotEmpty
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width * 0.15,
                      child: const Divider(
                        thickness: 1,
                        color: Colors.black26,
                      ),
                    ),
                    AppHelpers.getSpacerWidth(1),
                    Text(
                      gameViewModel.answerState == true
                          ? "CORRECT ANSWER BUT"
                          : "INCORRECT ANSWER",
                      style: TextStyle(
                          color: gameViewModel.answerState == true
                              ? Colors.green
                              : Colors.black26,
                          fontWeight: FontWeight.bold),
                    ),
                    AppHelpers.getSpacerWidth(1),
                    SizedBox(
                      width: size.width * 0.15,
                      child: const Divider(
                        thickness: 1,
                        color: Colors.black26,
                      ),
                    )
                  ],
                ),
                AppHelpers.getSpacerHeight(1),
                Text(gameViewModel.comments)
              ],
            )
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width * 0.15,
                      child: const Divider(
                        thickness: 1,
                        color: Colors.black26,
                      ),
                    ),
                    AppHelpers.getSpacerWidth(1),
                    const Text(
                      "OR RECORD YOUR ANSWER",
                      style: TextStyle(
                          color: Colors.black26, fontWeight: FontWeight.bold),
                    ),
                    AppHelpers.getSpacerWidth(1),
                    SizedBox(
                      width: size.width * 0.15,
                      child: const Divider(
                        thickness: 1,
                        color: Colors.black26,
                      ),
                    )
                  ],
                ),
                AppHelpers.getSpacerHeight(1),
                Row(children: [
                  Visibility(
                    visible: gameViewModel.isRecorded,
                    child: GestureDetector(
                      onTap: gameViewModel.getRecorderFn(),
                      child: CircleAvatar(
                        backgroundColor: AppTheme.thirdyColor,
                        child: FaIcon(
                          !gameViewModel.mRecorder!.isRecording
                              ? FontAwesomeIcons.recordVinyl
                              : FontAwesomeIcons.stop,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !gameViewModel.isRecorded,
                    child: Expanded(
                        child: ElevatedButton(
                            onPressed: gameViewModel.getRecorderFn(),
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    gameViewModel.mRecorder!.isRecording
                                        ? AppTheme.primaryColorLight
                                        : AppTheme.thirdyColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.recordVinyl,
                                  color: Colors.white,
                                ),
                                AppHelpers.getSpacerWidth(0.5),
                                Text(
                                  !gameViewModel.mRecorder!.isRecording
                                      ? "Record now"
                                      : "Stop recording",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ))),
                  ),
                  AppHelpers.getSpacerWidth(1),
                  Visibility(
                      visible: gameViewModel.mRecorder!.isRecording,
                      child: const Text("Recording...")),
                  Visibility(
                    visible: gameViewModel.isRecorded,
                    child: Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor),
                            onPressed: gameViewModel.getPlaybackFn(),
                            child: Row(
                              children: [
                                FaIcon(
                                  gameViewModel.mPlayer!.isPlaying
                                      ? FontAwesomeIcons.pause
                                      : FontAwesomeIcons.play,
                                  color: Colors.white,
                                ),
                                AppHelpers.getSpacerWidth(0.5),
                                Text(
                                  gameViewModel.mPlayer!.isPlaying
                                      ? "Stop reading"
                                      : "Read now",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ))),
                  ),
                  AppHelpers.getSpacerWidth(0.5),
                ]),
                AppHelpers.getSpacerHeight(1),
                SizedBox(
                  width: size.width * 0.4,
                  child: gameViewModel.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: AppTheme.secondaryColor))
                      : SimpleButton(
                          color: AppTheme.secondaryColor,
                          textColor: Colors.white,
                          text: "Submit",
                          onPressed: () {
                            if (_descriptionController.text.isNotEmpty ||
                                gameViewModel.isRecorded) {
                              gameViewModel.setLoading(true);
                              gameViewModel.validateQuestion(
                                  homeViewModel
                                      .questions[gameViewModel.index].label,
                                  _descriptionController.text);
                            } else {
                              AppHelpers.showSnackBar(
                                  context, "Provide your answer");
                            }
                          }),
                )
              ],
            )
    ]);
  }

  void quitGame(context, size) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) => Container(
              height: 200,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              width: size.width,
              child: Column(
                children: [
                  AppHelpers.getSpacerHeight(1),
                  const Text(
                    "Confirmation",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  AppHelpers.getSpacerHeight(1),
                  const Text(
                    "Are you sure you want to quit the game and lose your progress?",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ),
                  AppHelpers.getSpacerHeight(1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SimpleButton(
                            color: const Color(0xFF0F8C3B),
                            textColor: Colors.white,
                            text: "Yes",
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }),
                      ),
                      AppHelpers.getSpacerWidth(1),
                      Expanded(
                        child: SimpleButton(
                            color: Colors.red,
                            textColor: Colors.white,
                            text: "No",
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      )
                    ],
                  )
                ],
              ),
            ));
  }
}
