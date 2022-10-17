import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterbloc/datamodels/post.dart';
import 'package:flutterbloc/services/api_service.dart';
import 'package:flutterbloc/services/locator.dart';

part 'single_post_state.dart';

class SinglePostCubit extends Cubit<SinglePostState> {
  final ApiService _api = locator<ApiService>();
  SinglePostCubit() : super(SinglePostInitial());

  void setPost(Post post) {
    emit(SinglePostLoaded(post: post));
  }

  void fetch(int id) async {
    emit(SinglePostLoading());
    final posts = await _api.getPosts();
    final post = findById(id, posts);
    if (post == null) {
      emit(SinglePostError());
      return;
    }
    emit(SinglePostLoaded(post: post));
  }

  Post? findById(int id, List<Post> posts) {
    try {
      return posts.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

}
