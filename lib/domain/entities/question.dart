import 'package:prep_for_dev/domain/entities/answer.dart';

class Question {
  final String label;
  late List<Answer> answers;

  Question({required this.label, List<Answer>? answers}) {
    this.answers = answers ?? [];
  }
}
