import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prep_for_dev/domain/entities/answer.dart';
import 'package:prep_for_dev/themes/app_theme.dart';

import '../viewmodels/game.dart';

class AnswerWidget extends ConsumerWidget {
  final Answer answerModel;
  final int indexAnswer;
  const AnswerWidget(
      {required this.answerModel, required this.indexAnswer, super.key});

  final alphabets = "ABCDEF";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameViewModel = ref.watch(gameViewModelProvider);

    return GestureDetector(
      onTap: () {
        if (!gameViewModel.isClicked) {
          gameViewModel.changeIsClicked(true);
          gameViewModel.changeAnswerClicked(indexAnswer);
          if (answerModel.isCorrect) {
            gameViewModel.addScore(1);
          }
        }
      },
      child: Card(
        color: gameViewModel.isClicked &&
                gameViewModel.answerIndexClicked == indexAnswer
            ? AppTheme.primaryColor
            : Colors.white,
        elevation: 8,
        child: ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: gameViewModel.isClicked &&
                    gameViewModel.answerIndexClicked == indexAnswer
                ? Colors.white38
                : AppTheme.primaryColor.withOpacity(0.2),
            child: Text(
              alphabets[indexAnswer],
              style: TextStyle(
                  color: gameViewModel.isClicked &&
                          gameViewModel.answerIndexClicked == indexAnswer
                      ? Colors.white
                      : AppTheme.primaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            answerModel.label,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: gameViewModel.isClicked &&
                        gameViewModel.answerIndexClicked == indexAnswer
                    ? Colors.white
                    : Colors.black,
                fontSize: 16),
          ),
          trailing: Visibility(
              visible: (gameViewModel.isClicked &&
                      gameViewModel.answerIndexClicked == indexAnswer ||
                  gameViewModel.isClicked && answerModel.isCorrect),
              child: CircleAvatar(
                backgroundColor:
                    answerModel.isCorrect ? Colors.green : Colors.red,
                radius: 10,
                child: FaIcon(
                  answerModel.isCorrect
                      ? FontAwesomeIcons.check
                      : FontAwesomeIcons.xmark,
                  color: Colors.white,
                  size: 10,
                ),
              )),
        ),
      ),
    );
  }
}
