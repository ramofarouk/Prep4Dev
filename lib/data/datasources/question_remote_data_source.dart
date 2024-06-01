import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../core/api/gemini_api.dart';
import '../../core/exceptions/gemini_exception.dart';
import '../../domain/entities/question.dart';
import '../models/question.dart';

class QuestionRemoteDataSource {
  const QuestionRemoteDataSource({
    required GeminiApi client,
  }) : _client = client;

  final GeminiApi _client;

  Future<List<Question>> getQuestions(String technology, String level) async {
    final prompt = '''
    You're a system that helps developers prepare for job interviews. Create a list of questions that could help a developer interview successfully for a $level position in $technology.
    Give me 15 questions, including 10 MCQs (4 options maximum per question but one option must be correct per question) and 5 small questions to answer, all in one block. 
    Provide your answer in the following format(JSON): {"questions": [{"label":"", "answers":[{"label":"", "isCorrect":false},{"label":"", "isCorrect":true}]}]}. For the 5 questions to be answered, you must have "answers": [].
    Do not return the result as Markdown.
    ''';
    try {
      final response = await _client.generateContent(prompt);

      if (response == null) {
        throw const GeminiException('Response is empty');
      }
      String cleanedResponse = response.replaceAll(RegExp(r'```json\n*'), '');
      cleanedResponse = cleanedResponse.replaceAll(RegExp(r'```'), '');
      if (jsonDecode(cleanedResponse)
          case {'questions': List<dynamic> questions}) {
        return questions.map((json) => QuestionModel.fromJson(json)).toList();
      }

      throw const GeminiException('Invalid JSON schema');
    } on GenerativeAIException {
      throw const GeminiException(
        'Problem with the Generative AI service',
      );
    } catch (e) {
      if (e is GeminiException) rethrow;

      throw const GeminiException();
    }
  }

  Future<(bool, String)> validateQuestion(String question,
      {String? answer, Uint8List? file}) async {
    final prompt = file == null
        ? '''
    You're a system that helps developers prepare for job interviews.
    Check if the answer to the following question is correct.
    The question is : $question.
    The answer is: $answer.
    Provide your response in the following format: {"isCorrect": true/false, "answer": ""}.
    If it's partially correct, returns true but provide more informations.
    If it's wrong, provide the answer of this question. (No more than 200 words for the answer)
    Do not return the result as Markdown.
    '''
        : '''
    You're a system that helps developers prepare for job interviews.
    Check if the answer to the following question is correct.
    The question is : $question.
    We give you an audio file that contains the answer.
    Provide your response in the following format: {"isCorrect": true/false, "answer": ""}.
    If it's partially correct, returns true but provide more informations.
    If it's wrong, provide the answer of this question. (No more than 200 words for the answer)
    Do not return the result as Markdown.
    ''';
    try {
      final response = file == null
          ? await _client.generateContent(prompt)
          : await _client.generateContentWithImage(prompt, file, 'audio/mp3');

      if (response == null) {
        throw const GeminiException('Response is empty');
      }
      String cleanedResponse = response.replaceAll(RegExp(r'```json\n*'), '');
      cleanedResponse = cleanedResponse.replaceAll(RegExp(r'```'), '');

      if (jsonDecode(cleanedResponse)
          case {'isCorrect': bool isCorrect, 'answer': String answer}) {
        return (isCorrect, answer);
      }

      throw const GeminiException('Invalid JSON schema');
    } on GenerativeAIException {
      throw const GeminiException(
        'Problem with the Generative AI service',
      );
    } catch (e) {
      if (e is GeminiException) rethrow;

      throw const GeminiException();
    }
  }
}
