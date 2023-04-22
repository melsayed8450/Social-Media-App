
import 'package:image_picker/image_picker.dart';

import '../../domain/repositories/response_repositry.dart';
import '../data_sources/response__data_source.dart';

class ResponeRepositoryImpl extends ResponseRepository {
  final RemoteDataSource dataSource;


  ResponeRepositoryImpl(
      this.dataSource);

  // @override
  // Future<dynamic> getResponse() {
  //   return dataSource.getResponse();
  // }

 
}
