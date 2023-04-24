import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String id;
  final String personName;
  final String personEmail;
  final String text;
  final int likes;
  final List<dynamic> likedEmails;
  final DateTime date;

  PostEntity({required this.personName,required this.id, required this.text, required this.date, required this.personEmail, required this.likes, required this.likedEmails});

  @override
  List<Object?> get props => [id, text, date, personName, personEmail, likes, likedEmails];

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
          likes == other.likes &&
          likedEmails == other.likedEmails &&
          personEmail == other.personEmail;

  @override
  int get hashCode => id.hashCode ^ text.hashCode ^ date.hashCode ^ personEmail.hashCode ^ likes.hashCode ^ likedEmails.hashCode;
}
