import 'package:image_picker/image_picker.dart';
import 'package:profanity_filter_app/app/domain/entities/response_entity.dart';
import '../../../core/api_provider.dart';
import '../models/response_model.dart';

abstract class RemoteDataSource {
//  Future<ResponseEntity> getResponse();
}

class RemoteDataSourceImpl extends RemoteDataSource {
  final ApiProvider apiProvider;
  RemoteDataSourceImpl(this.apiProvider);

  // @override
  // Future<ResponseEntity> getResponse() async {
  //   final output = await apiProvider.post();
  //   return ResponseModel(
  //     none: output,
  //   );
  // }
}
