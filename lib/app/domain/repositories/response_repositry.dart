import 'package:social_media_app/app/data/models/response_model.dart';



abstract class ResponseRepository {
  Future<PostModel> getPosts();

}