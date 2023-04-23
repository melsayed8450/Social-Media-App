// ignore_for_file: must_be_immutable

import '../../domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  PostModel({
    required super.date,
    required super.id,
    required super.text,
    required super.personId,
  });
}
