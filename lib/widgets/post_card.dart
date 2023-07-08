import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ogchat/models/user.dart';
import 'package:ogchat/providers/user_provider.dart';
import 'package:ogchat/resources/firestore_methods.dart';
import 'package:ogchat/utils/colors.dart';
import 'package:ogchat/widgets/like_animation.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.snap});
  final snap;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(
          border:
              Border.all(color: Color.fromARGB(255, 255, 255, 255), width: 2),
          color: mobileBackgroundColor,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 16,
              ).copyWith(right: 0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                      widget.snap['profImage'],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.snap['username'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  child: ListView(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shrinkWrap: true,
                                    children: ['delete']
                                        .map(
                                          (e) => InkWell(
                                            onTap: () async {
                                              FirestoreMethods().deletePost(
                                                  widget.snap['postId']);
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                              child: Text(e),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ));
                      },
                      icon: const Icon(Icons.more_vert)),
                ],
              ),
            ),
            GestureDetector(
              onDoubleTap: () async {
                await FirestoreMethods().likePost(
                  widget.snap['postId'],
                  user.uid,
                  widget.snap['likes'],
                );
                setState(() {
                  isLikeAnimating = true;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: Image.network(
                      widget.snap['postUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 100,
                      ),
                      isAnimating: isLikeAnimating,
                      duration: const Duration(milliseconds: 400),
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                LikeAnimation(
                  isAnimating: widget.snap['likes'].contains(user.uid),
                  smallLike: true,
                  child: IconButton(
                    onPressed: () async {
                      await FirestoreMethods().likePost(
                        widget.snap['postId'],
                        user.uid,
                        widget.snap['likes'],
                      );
                    },
                    splashRadius: 1,
                    icon: widget.snap['likes'].contains(user.uid)
                        ? const Icon(Icons.favorite,
                            color: Color.fromARGB(255, 100, 31, 31))
                        : const Icon(Icons.favorite_border,
                            color: primaryColor),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.send),
                  color: const Color.fromARGB(255, 31, 81, 33),
                ),
                Expanded(
                    child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.bookmark_border)),
                ))
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.w800),
                      child: Text('${widget.snap['likes'].length} Likes',
                          style: Theme.of(context).textTheme.bodyMedium)),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 8),
                    child: RichText(
                        text: TextSpan(
                            style: const TextStyle(color: primaryColor),
                            children: [
                          TextSpan(
                            text: widget.snap['username'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: widget.snap['description'],
                          )
                        ])),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                      ),
                      child: Text(
                        DateFormat.yMMMd().format(
                          widget.snap['datePublished'].toDate(),
                        ),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 139, 139, 139)),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
