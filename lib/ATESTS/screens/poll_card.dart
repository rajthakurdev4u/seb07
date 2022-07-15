import 'dart:developer';

import 'package:aft/ATESTS/other/AUtils.dart';
import 'package:aft/ATESTS/other/poll_view/PollView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// import 'package:polls/polls.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../methods/AFirestoreMethods.dart';
import '../models/AUser.dart';
import '../provider/AUserProvider.dart';
import 'like_animation.dart';
import '../models/poll.dart';

class PollCard extends StatefulWidget {
  final Poll poll;

  const PollCard({
    Key? key,
    required this.poll,
  }) : super(key: key);

  @override
  State<PollCard> createState() => _PollCardState();
}

class _PollCardState extends State<PollCard> {
  late Poll _poll;
  bool _isPollEnded = false;
  bool isLikeAnimating = false;
  int commentLen = 0;
  String placement = '';
  var testt = 21100;

  final TextStyle _pollOptionTextStyle = const TextStyle(
    fontSize: 16,
  );

  @override
  void initState() {
    super.initState();
    _poll = widget.poll;
    // placement = '#${(widget.indexPlacement + 1).toString()}';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    _poll = widget.poll;
    final User? user = Provider.of<UserProvider>(context).getUser;
    print('_poll.endDate: ${_poll.endDate.runtimeType}');

    _isPollEnded = (_poll.endDate as Timestamp)
        .toDate()
        .difference(
          DateTime.now(),
        )
        .isNegative;

    return Padding(
      key: Key(_poll.pollId),
      padding: const EdgeInsets.only(
        top: 8,
        right: 8,
        left: 8,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 6,
                  // bottom: 6,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(_poll.profImage),
                    ),
                    SizedBox(width: 8),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                child: Text(
                              _poll.username,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  letterSpacing: 1),
                            )),
                            SizedBox(height: 4),
                            Text(
                              DateFormat.yMMMd().format(
                                _poll.datePublished.toDate(),
                              ),
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Container(
                          // color: Colors.brown,
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: ListView(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shrinkWrap: true,
                                      children: [
                                        'Delete',
                                      ]
                                          .map(
                                            (e) => InkWell(
                                              onTap: () async {
                                                FirestoreMethods()
                                                    .deletePost(_poll.pollId);
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
                                          .toList()),
                                ),
                              );
                            },
                            icon: const Icon(Icons.more_vert),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Stack(
              children: [
                PollView(
                  pollId: _poll.pollId,
                  hasVoted: _poll.allVotesUIDs.contains(user?.uid),
                  pollEnded: _isPollEnded,
                  userVotedOptionId: _getUserPollOptionId(user?.uid ?? ''),
                  onVoted: (PollOption pollOption, int newTotalVotes) async {
                    if (!_isPollEnded) {
                      performLoggedUserAction(
                          context: context,
                          action: () async {
                            await FirestoreMethods().poll(
                              poll: _poll,
                              uid: user?.uid ?? '',
                              optionIndex: pollOption.id!,
                            );
                          });
                    }

                    print('newTotalVotes: ${newTotalVotes}');
                    print('Voted: ${pollOption.id}');
                  },
                  leadingVotedProgessColor: Colors.blue.shade200,
                  pollOptionsSplashColor: Colors.white,
                  votedProgressColor: Colors.blueGrey.withOpacity(0.3),
                  votedBackgroundColor: Colors.grey.withOpacity(0.2),
                  votedCheckmark: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.black,
                    size: 18,
                  ),
                  pollTitle: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _poll.pollTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  pollOptions: [
                    PollOption(
                      id: 1,
                      title: Text(
                        _poll.option1,
                        style: _pollOptionTextStyle,
                      ),
                      votes: _poll.vote1.length,
                    ),
                    PollOption(
                      id: 2,
                      title: Text(
                        _poll.option2,
                        style: _pollOptionTextStyle,
                      ),
                      votes: _poll.vote2.length,
                    ),
                    if (_poll.option3 != '')
                      PollOption(
                        id: 3,
                        title: Text(
                          _poll.option3,
                          style: _pollOptionTextStyle,
                        ),
                        votes: _poll.vote3.length,
                      ),
                    if (_poll.option4 != '')
                      PollOption(
                        id: 4,
                        title: Text(
                          _poll.option4,
                          style: _pollOptionTextStyle,
                        ),
                        votes: _poll.vote4.length,
                      ),
                    if (_poll.option5 != '')
                      PollOption(
                        id: 5,
                        title: Text(
                          _poll.option5,
                          style: _pollOptionTextStyle,
                        ),
                        votes: _poll.vote5.length,
                      ),
                    if (_poll.option6 != '')
                      PollOption(
                        id: 6,
                        title: Text(
                          _poll.option6,
                          style: _pollOptionTextStyle,
                        ),
                        votes: _poll.vote6.length,
                      ),
                    if (_poll.option7 != '')
                      PollOption(
                        id: 7,
                        title: Text(
                          _poll.option7,
                          style: _pollOptionTextStyle,
                        ),
                        votes: _poll.vote7.length,
                      ),
                    if (_poll.option8 != '')
                      PollOption(
                        id: 8,
                        title: Text(
                          _poll.option8,
                          style: _pollOptionTextStyle,
                        ),
                        votes: _poll.vote8.length,
                      ),
                    if (_poll.option9 != '')
                      PollOption(
                        id: 9,
                        title: Text(
                          _poll.option9,
                          style: _pollOptionTextStyle,
                        ),
                        votes: _poll.vote9.length,
                      ),
                    if (_poll.option10 != '')
                      PollOption(
                        id: 10,
                        title: Text(
                          _poll.option10,
                          style: _pollOptionTextStyle,
                        ),
                        votes: _poll.vote10.length,
                      ),
                  ],
                  metaWidget: Row(
                    children: [
                      const SizedBox(width: 6),
                      const Text(
                        '•',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        _pollTimeLeftLabel(poll: _poll),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                    child: Visibility(
                  visible: _isPollEnded,
                  child: Container(
                    color: Colors.cyanAccent.withOpacity(0.0),
                  ),
                )),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  int? _getUserPollOptionId(String uid) {
    print("uid: $uid");
    int? optionId;
    for (int i = 1; i <= 10; i++) {
      switch (i) {
        case 1:
          if (_poll.vote1.contains(uid)) {
            optionId = i;
          }
          break;
        case 2:
          if (_poll.vote2.contains(uid)) {
            optionId = i;
          }
          break;
        case 3:
          if (_poll.vote3.contains(uid)) {
            optionId = i;
          }
          break;
        case 4:
          if (_poll.vote4.contains(uid)) {
            optionId = i;
          }
          break;
        case 5:
          if (_poll.vote5.contains(uid)) {
            optionId = i;
          }
          break;
        case 6:
          if (_poll.vote6.contains(uid)) {
            optionId = i;
          }
          break;
        case 7:
          if (_poll.vote7.contains(uid)) {
            optionId = i;
          }
          break;
        case 8:
          if (_poll.vote8.contains(uid)) {
            optionId = i;
          }
          break;
        case 9:
          if (_poll.vote9.contains(uid)) {
            optionId = i;
          }
          break;
        case 10:
          if (_poll.vote10.contains(uid)) {
            optionId = i;
          }
          break;
      }
    }
    print("POLLED optionId: $optionId");
    return optionId;
  }

  // Returns poll time left
  String _pollTimeLeftLabel({required Poll poll}) {
    if (_isPollEnded) {
      return 'Poll ended on ${DateFormat.yMMMd().format(
        _poll.endDate.toDate(),
      )}';
    }

    Duration timeLeft = (_poll.endDate as Timestamp).toDate().difference(
          DateTime.now(),
        );

    return timeLeft.inHours >= 1
        ? "${timeLeft.inHours} hours left"
        : "${timeLeft.inMinutes} minutes left";
  }
}
