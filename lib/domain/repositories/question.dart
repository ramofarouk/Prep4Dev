import 'dart:typed_data';

import '../entities/question.dart';

abstract class QuestionRepository {
  Future<List<Question>> getQuestions(String technology, String level);
  Future<(bool, String)> validateQuestion(
      String question, String answer, Uint8List? file);
}
