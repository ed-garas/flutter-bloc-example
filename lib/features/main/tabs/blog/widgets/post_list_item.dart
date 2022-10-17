import 'package:flutter/material.dart';
import 'package:flutterbloc/datamodels/post.dart';

class PostListItem extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;
  const PostListItem({Key? key, required this.post, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(post.body),
          ],
        ),
      ),
    );
  }
}
