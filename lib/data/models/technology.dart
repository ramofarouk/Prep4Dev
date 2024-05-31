import '../../domain/entities/technology.dart';

class TechnologyModel extends Technology {
  TechnologyModel({
    required super.title,
    required super.imagePath,
  });

  factory TechnologyModel.fromJson(Map<String, dynamic> json) {
    return TechnologyModel(
      title: json['title'],
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imagePath': imagePath,
    };
  }
}
