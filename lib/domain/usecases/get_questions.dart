import '../entities/question.dart';
import '../repositories/question.dart';

class GetQuestionsUseCase {
  final QuestionRepository repository;

  GetQuestionsUseCase(this.repository);

  Future<List<Question>> execute(String technology, String level) {
    return repository.getQuestions(technology, level);
  }
}
