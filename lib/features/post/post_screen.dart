import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/datamodels/post.dart';
import 'package:flutterbloc/features/post/bloc/single_post_cubit.dart';

import 'widgets/post_preview.dart';

class PostScreen extends StatelessWidget {
  final int id;
  final Post? post;
  const PostScreen({Key? key, required this.id, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SinglePostCubit>(
      create: (BuildContext context) => SinglePostCubit(),
      child: PostScreenContent(
        id: id,
        post: post,
      ),
    );
  }
}

class PostScreenContent extends StatefulWidget {
  final int id;
  final Post? post;
  const PostScreenContent({Key? key, required this.id, this.post})
      : super(key: key);

  @override
  State<PostScreenContent> createState() => _PostScreenContentState();
}

class _PostScreenContentState extends State<PostScreenContent> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = BlocProvider.of<SinglePostCubit>(context);
    if (widget.post != null) {
      bloc.setPost(widget.post!);
    } else {
      bloc.fetch(widget.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: BlocBuilder<SinglePostCubit, SinglePostState>(
          builder: (context, state) {
            if (state is SinglePostError) {
              return const Text('Not found.');
            } else if (state is SinglePostLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is SinglePostLoaded) {
              return PostPreview(
                post: state.post,
              );
            }

            return const Text('Error');
          },
        ),
      )),
    );
  }
}
