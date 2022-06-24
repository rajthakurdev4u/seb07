import 'package:aft/ATESTS/models/APost.dart';
import 'package:aft/ATESTS/other/AUtils.dart';
import 'package:aft/ATESTS/screens/full_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../methods/AFirestoreMethods.dart';
import '../models/AUser.dart';
import '../provider/AUserProvider.dart';
import 'ALikeAnimation.dart';

class CommentCard extends StatefulWidget {
  // Comment
  final postId;
  final snap;
  final bool? plus;
  final bool? minus;
  final Function parentSetState;

  // Reply
  final bool isReply;
  final Post? parentPost;
  final String? parentCommentId;
  final String? parentReplyId;

  const CommentCard({
    Key? key,

    // Reply
    this.isReply = false,
    this.parentPost,
    this.parentCommentId,
    this.parentReplyId,

    // Comment
    required this.postId,
    required this.snap,
    this.plus,
    this.minus,
    required this.parentSetState,
  }) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  User? user;
  final TextEditingController _replyController = TextEditingController();
  FocusNode currentReplyFocusNode = FocusNode();
  bool isReadmore = false;
  bool showMoreButton = true;
  bool _replyingOnComment = false;
  bool _showCommentReplies = false;
  int _likes = 0;
  int _dislikes = 0;
  dynamic commentReplies;

  @override
  void dispose() {
    super.dispose();
    _replyController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).getUser;
    print('widget.snap: ${widget.snap}');

    _replyingOnComment = widget.isReply
        ? widget.parentReplyId == currentReplyCommentId
        : widget.snap['commentId'] == currentReplyCommentId;

    _likes = widget.snap['likes']?.length ?? 0;
    _dislikes = widget.snap['dislikes']?.length ?? 0;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: widget.isReply ? 46 : 0,
          ),
          child: Column(
            children: [
              Container(
                color: Color.fromARGB(255, 236, 234, 234),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 16.0,
                  left: 16,
                  top: 16,
                  bottom: 10,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        widget.snap['profilePic'],
                      ),
                      radius: widget.isReply ? 14 : 18,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  // width: 270,
                                  // color: Colors.brown,
                                  child: Text(
                                    widget.snap['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Container(width: 8),
                                Visibility(
                                  visible: widget.minus ?? false,
                                  child: Icon(
                                    Icons.do_not_disturb_on,
                                    color: Colors.red,
                                    size: 15,
                                  ),
                                ),
                                Visibility(
                                  visible: widget.plus ?? false,
                                  child: Icon(
                                    Icons.add_circle,
                                    color: Colors.green,
                                    size: 15,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    // color: Colors.brown,
                                    alignment: Alignment.centerRight,
                                    child: Visibility(
                                      visible: widget.snap['uid'] == user?.uid,
                                      child: InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                              child: ListView(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 16,
                                                  ),
                                                  shrinkWrap: true,
                                                  children: [
                                                    'Delete',
                                                  ]
                                                      .map(
                                                        (e) => InkWell(
                                                          onTap: () async {
                                                            widget.isReply
                                                                ? FirestoreMethods().deleteReply(
                                                                    widget
                                                                        .postId,
                                                                    widget
                                                                        .parentCommentId!,
                                                                    widget.snap[
                                                                        'replyId'])
                                                                : FirestoreMethods()
                                                                    .deleteComment(
                                                                    widget
                                                                        .postId,
                                                                    widget.snap[
                                                                        'commentId'],
                                                                  );
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        12,
                                                                    horizontal:
                                                                        16),
                                                            child: Text(e),
                                                          ),
                                                        ),
                                                      )
                                                      .toList()),
                                            ),
                                          );
                                        },
                                        child: const Icon(Icons.more_vert,
                                            size: 18),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                DateFormat.yMMMd().format(
                                    widget.snap['datePublished'].toDate()),
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 68, right: 16),
                child: buildText('${widget.snap['text']}'),
              ),
              Container(height: 12),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, right: 16, left: 68),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          LikeAnimation(
                            isAnimating:
                                widget.snap['likes']?.contains(user?.uid) ??
                                    false,
                            child: InkWell(
                              onTap: () async {
                                performLoggedUserAction(
                                    context: context,
                                    action: () async {
                                      widget.isReply
                                          ? await FirestoreMethods().likeReply(
                                              widget.postId,
                                              widget.parentCommentId!,
                                              user?.uid ?? '',
                                              widget.snap['likes'],
                                              widget.snap['dislikes'],
                                              widget.snap['replyId'])
                                          : await FirestoreMethods()
                                              .likeComment(
                                              widget.postId,
                                              widget.snap['commentId'],
                                              user?.uid ?? '',
                                              widget.snap['likes'],
                                              widget.snap['dislikes'],
                                            );
                                    });
                              },
                              child: Row(
                                children: [
                                  Container(
                                    child: Icon(
                                      Icons.thumb_up,
                                      color: widget.snap['likes']
                                                  ?.contains(user?.uid) ??
                                              false
                                          ? Colors.blueAccent
                                          : Color.fromARGB(255, 206, 204, 204),
                                      size: 16.0,
                                    ),
                                  ),
                                  Container(width: 6),
                                  Text('$_likes',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                      )),
                                ],
                              ),
                            ),
                          ),
                          Container(width: 30),
                          LikeAnimation(
                            isAnimating:
                                widget.snap['dislikes']?.contains(user?.uid) ??
                                    false,
                            child: InkWell(
                              onTap: () async {
                                performLoggedUserAction(
                                    context: context,
                                    action: () async {
                                      widget.isReply
                                          ? await FirestoreMethods()
                                              .dislikeReply(
                                                  widget.postId,
                                                  widget.parentCommentId!,
                                                  user?.uid ?? '',
                                                  widget.snap['likes'],
                                                  widget.snap['dislikes'],
                                                  widget.snap['replyId'])
                                          : await FirestoreMethods()
                                              .dislikeComment(
                                              widget.postId,
                                              widget.snap['commentId'],
                                              user?.uid ?? '',
                                              widget.snap['likes'],
                                              widget.snap['dislikes'],
                                            );
                                    });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.thumb_down,
                                    size: 16,
                                    color: widget.snap['dislikes']
                                                ?.contains(user?.uid) ??
                                            false
                                        ? Colors.blueAccent
                                        : Color.fromARGB(255, 206, 204, 204),
                                  ),
                                  Container(width: 6),
                                  Text('$_dislikes',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !_replyingOnComment,
                      child: InkWell(
                        onTap: () async {
                          performLoggedUserAction(
                              context: context,
                              action: () async {
                                await _startReplying(
                                  to: widget.snap['name'],
                                  commentId: widget.isReply
                                      ? widget.parentReplyId
                                      : widget.snap['commentId'],
                                  replyFocusNode: widget.isReply
                                      ? currentReplyFocusNode
                                      : currentReplyFocusNode,
                                  replyTextController: widget.isReply
                                      ? _replyController
                                      : _replyController,
                                );
                              });
                        },
                        child: Container(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.reply,
                                size: 16,
                                color: Colors.blueAccent,
                              ),
                              Container(width: 3),
                              const Text("REPLY",
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 13,
                                    letterSpacing: 0.5,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _showCommentReplies,
                child: _replyTextField(),
              ),
              Visibility(
                visible: !widget.isReply,
                child: Padding(
                  padding: const EdgeInsets.only(left: 64.0, bottom: 8),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.postId)
                        .collection('comments')
                        .doc(widget.snap['commentId'])
                        .collection('replies')
                        .orderBy('datePublished', descending: false)
                        .snapshots(),
                    builder: (content, snapshot) {
                      int repliesCount =
                          (snapshot.data as dynamic)?.docs.length ?? 0;
                      return repliesCount > 0
                          ? InkWell(
                              onTap: () async {
                                _showCommentReplies = !_showCommentReplies;
                                _stopReplying();
                                setState(() {});
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    _showCommentReplies
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                    size: 18,
                                    color: Colors.blueAccent,
                                  ),
                                  Container(width: 2),
                                  Text("Replies ($repliesCount)",
                                      style: const TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 13,
                                        letterSpacing: 0.5,
                                      )),
                                ],
                              ),
                            )
                          : Container();
                    },
                  ),
                ),
              ),
              Visibility(
                visible: !_showCommentReplies,
                child: _replyTextField(),
              ),
              Visibility(
                visible: _showCommentReplies,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(widget.postId)
                      .collection('comments')
                      .doc(widget.snap['commentId'])
                      .collection('replies')
                      .orderBy('datePublished', descending: false)
                      .snapshots(),
                  builder: (content, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return commentReplies != null
                          ? ReplyList(
                              commentReplies: commentReplies,
                              parentPost: widget.parentPost,
                              parentCommentId: widget.snap['commentId'],
                              postId: widget.postId,
                              parentSetState: widget.parentSetState,
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            );
                    }

                    commentReplies = (snapshot.data as dynamic).docs ?? [];

                    return ReplyList(
                      commentReplies: commentReplies,
                      parentPost: widget.parentPost,
                      parentCommentId: widget.snap['commentId'],
                      postId: widget.postId,
                      parentSetState: widget.parentSetState,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _replyTextField() {
    return Visibility(
      visible: _replyingOnComment,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 8.0,
          left: 8,
          bottom: 12,
        ),
        child: Container(
          color: Colors.white,
          child: PhysicalModel(
            color: Color.fromARGB(255, 247, 245, 245),
            elevation: 2,
            // shadowColor: Colors.black,
            borderRadius: BorderRadius.circular(0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // color: Colors.orange,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, left: 8, bottom: 8),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        user?.photoUrl ?? '',
                      ),
                      radius: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8.0),
                    child: Container(
                      child: TextField(
                        controller: _replyController,
                        maxLines: null,
                        focusNode: currentReplyFocusNode,
                        decoration: const InputDecoration(
                          hintText: 'Write a reply...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.grey),
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () async {
                          performLoggedUserAction(
                              context: context,
                              action: () async {
                                await FirestoreMethods().postReply(
                                    widget.postId,
                                    widget.snap['commentId'],
                                    _replyController.text,
                                    user?.uid ?? '',
                                    user?.username ?? '',
                                    user?.photoUrl ?? '');
                                setState(() {
                                  _replyController.text = "";
                                });
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            children: [
                              Icon(Icons.send,
                                  color: Colors.blueAccent, size: 12),
                              Container(width: 3),
                              Text(
                                'SEND',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await _stopReplying();
                        },
                        child: Container(
                          decoration: BoxDecoration(),
                          child: Row(
                            children: [
                              Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.red,
                              ),
                              Container(width: 3),
                              Text("CANCEL",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                    letterSpacing: 0.5,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildText(String text) {
    TextStyle yourStyle = const TextStyle(fontSize: 15);
    const maxLinesAfterEllipses = 2;
    final lines = isReadmore ? null : maxLinesAfterEllipses;
    Text t = Text(
      text,
      style: yourStyle,
      maxLines: lines,
      overflow: isReadmore ? TextOverflow.visible : TextOverflow.ellipsis,
    );

    return Column(
      children: [
        t,
        LayoutBuilder(builder: (context, constraints) {
          final span = TextSpan(text: text, style: yourStyle);
          final tp = TextPainter(
            text: span,
            textDirection: ui.TextDirection.ltr,
            textAlign: TextAlign.left,
          );
          tp.layout(maxWidth: constraints.maxWidth);
          final numLines = tp.computeLineMetrics().length;

          if (numLines > maxLinesAfterEllipses) {
            return Padding(
              padding: const EdgeInsets.only(left: 68, right: 16),
              child: InkWell(
                onTap: () {
                  setState(() {
                    isReadmore = !isReadmore;
                  });
                },
                child: Text(
                  isReadmore ? 'Show Less' : 'Show More',
                  style: const TextStyle(color: Colors.blueAccent),
                ),
              ),
            );
          } else {
            return Container();
          }
        }),
      ],
    );
  }

  Future<void> _stopReplying() async {
    currentReplyCommentId = null;
    currentReplyFocusNode = FocusNode();
    widget.parentSetState();
    await Future.delayed(
      const Duration(milliseconds: 200),
      () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  Future<void> _startReplying({
    required String to,
    required String commentId,
    required TextEditingController replyTextController,
    required FocusNode replyFocusNode,
  }) async {
    currentReplyCommentId = commentId;
    currentReplyFocusNode = FocusNode();
    widget.parentSetState();
    await Future.delayed(
      const Duration(milliseconds: 200),
      () {
        replyTextController.text = '@$to ';
        FocusScope.of(context).requestFocus(replyFocusNode);
      },
    );
  }
}

class ReplyList extends StatelessWidget {
  final commentReplies;
  final Post? parentPost;
  final String? parentCommentId;
  final postId;
  final Function parentSetState;

  const ReplyList(
      {Key? key,
      this.commentReplies,
      this.parentPost,
      this.parentCommentId,
      this.postId,
      required this.parentSetState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...List.generate(commentReplies.length, (index) {
            var replySnap = commentReplies[index].data();

            return CommentCard(
              isReply: true,
              parentCommentId: parentCommentId,
              parentReplyId: replySnap['replyId'],
              snap: replySnap,
              postId: postId,
              minus: parentPost?.minus.contains(replySnap['uid']),
              plus: parentPost?.plus.contains(replySnap['uid']),
              parentSetState: parentSetState,
            );
          })
        ],
      ),
    );
  }
}
