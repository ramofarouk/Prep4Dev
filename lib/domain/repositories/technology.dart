import 'package:prep_for_dev/domain/entities/technology.dart';

abstract class TechnologyRepository {
  List<Technology> getTechnologies();
  Technology getSingleTechnology(int index);
}
