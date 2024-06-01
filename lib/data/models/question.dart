import 'package:prep_for_dev/domain/entities/answer.dart';

import '../../domain/entities/question.dart';
import 'answer.dart';

class QuestionModel extends Question {
  QuestionModel({
    required super.label,
    required super.answers,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    List<Answer> answers = [];
    for (var item in json['answers']) {
      answers.add(AnswerModel.fromJson(item));
    }
    answers.shuffle();
    return QuestionModel(
      label: json['label'],
      answers: answers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'answers': answers,
    };
  }
}
