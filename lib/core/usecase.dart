import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class UseCase<Type> {
  Future<Type> call();
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
