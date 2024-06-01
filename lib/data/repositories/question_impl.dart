import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/gemini_api.dart';
import '../../domain/entities/question.dart';
import '../../domain/repositories/question.dart';
import '../datasources/question_remote_data_source.dart';

final questionRepositoryProvider = Provider<QuestionRepositoryImpl>((ref) {
  final client = GeminiApi(type: "gemini-1.5-flash");
  final dataSource = QuestionRemoteDataSource(client: client);
  return QuestionRepositoryImpl(remoteDataSource: dataSource);
});

class QuestionRepositoryImpl implements QuestionRepository {
  final QuestionRemoteDataSource remoteDataSource;

  QuestionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Question>> getQuestions(String technology, String level) async {
    return await remoteDataSource.getQuestions(technology, level);
  }

  @override
  Future<(bool, String)> validateQuestion(
      String question, String answer, Uint8List? file) async {
    return await remoteDataSource.validateQuestion(question,
        answer: answer, file: file);
  }
}
