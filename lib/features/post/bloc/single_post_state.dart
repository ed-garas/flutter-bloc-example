part of 'single_post_cubit.dart';

abstract class SinglePostState extends Equatable {
  const SinglePostState();

  @override
  List<Object> get props => [];
}

class SinglePostInitial extends SinglePostState {}

class SinglePostLoaded extends SinglePostState {
  final Post post;

  const SinglePostLoaded({ required this.post });

  @override
  List<Object> get props => [post];
}

class SinglePostLoading extends SinglePostState {}

class SinglePostError extends SinglePostState {}