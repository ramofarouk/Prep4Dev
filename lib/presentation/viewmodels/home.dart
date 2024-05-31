import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prep_for_dev/data/repositories/technology_impl.dart';
import 'package:prep_for_dev/domain/entities/technology.dart';

import '../../domain/usecases/get_technologies.dart';

final homeViewModelProvider = ChangeNotifierProvider<HomeViewModel>((ref) {
  final repository = ref.read(technologyRepositoryProvider);
  return HomeViewModel(
      getTechnologiesUseCase: GetTechnologiesUseCase(repository));
});

class HomeViewModel extends ChangeNotifier {
  final GetTechnologiesUseCase getTechnologiesUseCase;
  late List<Technology> technologies;

  HomeViewModel({required this.getTechnologiesUseCase}) {
    technologies = getTechnologiesUseCase.execute();
  }
}
