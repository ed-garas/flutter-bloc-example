import 'package:equatable/equatable.dart';
import 'package:flutterbloc/datamodels/post.dart';
import 'package:flutterbloc/services/api_service.dart';
import 'package:flutterbloc/services/locator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends HydratedBloc<BlogEvent, BlogState> {
  final ApiService _api = locator<ApiService>();

  BlogBloc() : super(BlogInitial()) {
    on<BlogFetch>(_fetchPosts);
  }

  _fetchPosts (event, emit) async {
    emit(BlogLoading());
    final posts = await _api.getPosts();
    if (posts.isNotEmpty) {
      emit(BlogLoaded(posts: posts));
    } else {
      emit(const BlogError(message: 'No posts found.'));
    }
  }

  @override
  BlogState fromJson(Map<String, dynamic> json) {
    try {
      final items = (json['posts'] as List).map((data) => Post.fromJson(data)).toList();
      return BlogLoaded(posts: items);
    } catch (e) {
      return const BlogLoaded(posts: []);
    }
  }

  @override
  Map<String, dynamic>? toJson(BlogState state) {
    if (state is BlogLoaded) {
      return {'posts': state.posts};
    }
    return null;
  }
}
