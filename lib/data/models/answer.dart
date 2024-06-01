import '../../domain/entities/answer.dart';

class AnswerModel extends Answer {
  AnswerModel({
    required super.label,
    required super.isCorrect,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      label: json['label'],
      isCorrect: json['isCorrect'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'isCorrect': isCorrect,
    };
  }
}
