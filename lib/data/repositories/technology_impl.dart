import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prep_for_dev/data/datasources/technology_data_source.dart';
import 'package:prep_for_dev/domain/entities/technology.dart';

import '../../domain/repositories/technology.dart';

final technologyRepositoryProvider = Provider<TechnologyRepositoryImpl>((ref) {
  return TechnologyRepositoryImpl();
});

class TechnologyRepositoryImpl implements TechnologyRepository {
  @override
  List<Technology> getTechnologies() {
    return TechnologyDataSource.technologies;
  }

  @override
  Technology getSingleTechnology(int index) {
    return TechnologyDataSource.technologies[index];
  }
}
