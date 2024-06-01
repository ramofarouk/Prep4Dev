import 'dart:typed_data';

import '../repositories/question.dart';

class ValidateQuestionUseCase {
  final QuestionRepository repository;

  ValidateQuestionUseCase(this.repository);

  Future<(bool, String)> execute(
      String question, String answer, Uint8List? file) {
    return repository.validateQuestion(question, answer, file);
  }
}
