import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/features/main/tabs/blog/bloc/blog_bloc.dart';
import 'package:go_router/go_router.dart';
import 'widgets/post_list_item.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({Key? key}) : super(key: key);

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = BlocProvider.of<BlogBloc>(context);
    bloc.add(BlogFetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Container(
        child: BlocBuilder<BlogBloc, BlogState>(builder: (context, state) {
          if (state is BlogInitial) {
            return const Text('Initial');
          } else if (state is BlogLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is BlogLoaded) {
            return ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: PostListItem(
                      post: state.posts[index],
                      onTap: () {
                        print('onTap');
                        final post = state.posts[index];
                        context.goNamed('SinglePost',
                            params: {'id': post.id.toString()}, extra: post);
                      },
                    ),
                  );
                });
          } else if (state is BlogError) {
            return Text('Error: ${state.message}');
          }
          return const SizedBox.shrink();
        }),
      )),
    );
  }
}
