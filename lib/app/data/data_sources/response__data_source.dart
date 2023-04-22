import 'package:image_picker/image_picker.dart';
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
