import 'package:flutter/material.dart';
import 'package:flutterbloc/datamodels/post.dart';

class PostPreview extends StatelessWidget {
  final Post post;
  const PostPreview({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(post.body),
        ],
      ),
    );
  }
}
