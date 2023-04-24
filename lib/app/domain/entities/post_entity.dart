import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String id;

  final String personName;
  final String personEmail;
  final String text;
  final DateTime date;

  PostEntity({required this.personName,required this.id, required this.text, required this.date, required this.personEmail});

  @override
  List<Object?> get props => [id, text, date, personName, personEmail];

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
          personName == other.personName &&
          personEmail == other.personEmail;

  @override
  int get hashCode => id.hashCode ^ text.hashCode ^ date.hashCode ^ personEmail.hashCode;
}
