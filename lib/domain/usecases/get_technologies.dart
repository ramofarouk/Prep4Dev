import 'package:prep_for_dev/domain/entities/technology.dart';

import '../repositories/technology.dart';

class GetTechnologiesUseCase {
  final TechnologyRepository repository;

  GetTechnologiesUseCase(this.repository);

  List<Technology> execute() {
    return repository.getTechnologies();
  }
}
