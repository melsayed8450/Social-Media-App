import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String id;
  final String personId;
  final String text;
  final DateTime date;

  PostEntity({required this.personId,required this.id, required this.text, required this.date});

  @override
  List<Object?> get props => [id, text, date, personId];

  @override
  bool get stringify => true;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          text == other.text &&
          date == other.date &&
          personId == other.personId;

  @override
  int get hashCode => id.hashCode ^ text.hashCode ^ date.hashCode ^ personId.hashCode;
}
