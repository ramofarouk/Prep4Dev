import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prep_for_dev/data/repositories/question_impl.dart';
import 'package:prep_for_dev/data/repositories/technology_impl.dart';
import 'package:prep_for_dev/domain/entities/question.dart';
import 'package:prep_for_dev/domain/entities/technology.dart';

import '../../domain/usecases/get_questions.dart';
import '../../domain/usecases/get_technologies.dart';

final homeViewModelProvider = ChangeNotifierProvider<HomeViewModel>((ref) {
  final repository = ref.read(technologyRepositoryProvider);
  final repositoryQuestion = ref.read(questionRepositoryProvider);
  return HomeViewModel(
      getTechnologiesUseCase: GetTechnologiesUseCase(repository),
      getQuestionsUseCase: GetQuestionsUseCase(repositoryQuestion),
      ref: ref);
});

class HomeViewModel extends ChangeNotifier {
  final GetTechnologiesUseCase getTechnologiesUseCase;
  final GetQuestionsUseCase getQuestionsUseCase;
  final Ref ref;
  late List<Technology> technologies;
  bool isLoading = false;
  String technologyChoosen = "";
  String level = "";
  List<Question> questions = [];

  HomeViewModel(
      {required this.getTechnologiesUseCase,
      required this.getQuestionsUseCase,
      required this.ref}) {
    technologies = getTechnologiesUseCase.execute();
  }

  Future<bool> fetchQuestions() async {
    try {
      questions = await getQuestionsUseCase.execute(technologyChoosen, level);
      notifyListeners();
      return true;
    } catch (e) {
      //
    } finally {
      isLoading = false;
      notifyListeners();
    }

    return false;
  }

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void changeQuestion(String title) {
    technologyChoosen = title;
    notifyListeners();
  }

  void changeLevel(String level) {
    this.level = level;
    notifyListeners();
  }
}
