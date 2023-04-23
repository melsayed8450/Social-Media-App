import 'package:get_it/get_it.dart';

import '../core/api_provider.dart';
import 'data/data_sources/response__data_source.dart';
import 'data/repositories/response_repositry_impl.dart';
import 'domain/repositories/response_repositry.dart';
import 'domain/use_cases/response_use_case.dart';

final sl = GetIt.instance;
Future<void> init() async {
  //data source
//  sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(sl()));
 // sl.registerLazySingleton<ResponseUseCase>(() =>  ResponseUseCase(sl()));
 // sl.registerLazySingleton<ResponseRepository>(() =>  ResponeRepositoryImpl(sl()));
  sl.registerLazySingleton<ApiProvider>(() => ApiProvider());
}
