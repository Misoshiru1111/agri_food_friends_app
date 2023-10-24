import 'dart:math';

import 'package:agri_food_freind/event/app_widgets.dart';
import 'package:agri_food_freind/event/state/models/user.dart';
import 'package:agri_food_freind/event/utils.dart';
import 'package:agri_food_freind/event/widgets/widgets.dart';
import 'package:agri_food_freind/request/event/event.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:flutter_quill/flutter_quill.dart' as editor;
import 'dart:convert';

import '../request/event/event_list.dart';

// import 'widgets/post_card.dart';
// import 'package:simple_permissions/simple_permissions.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  // int _page = 0;

  final ValueNotifier<bool> _showCommentBox = ValueNotifier(false);
  final TextEditingController _commentTextController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  EnrichedActivity? activeActivity;
  List<Event> list = [];
  bool _isPaginating = false;
  EventRepo eventRepo = EventRepo();

  static const _feedGroup = 'timeline';
  static final _flags = EnrichmentFlags()
    ..withOwnReactions()
    ..withRecentReactions()
    ..withReactionCounts();

  void openCommentBox(EnrichedActivity activity, {String? message}) {
    _commentTextController.text = message ?? '';
    _commentTextController.selection = TextSelection.fromPosition(
        TextPosition(offset: _commentTextController.text.length));
    activeActivity = activity;
    // print(activity)
    _showCommentBox.value = true;
    _commentFocusNode.requestFocus();
  }

  Future<void> addComment(String? message) async {
    if (activeActivity != null &&
        message != null &&
        message.isNotEmpty &&
        message != '') {
      var a = activeActivity?.target ?? 0;
      eventRepo
          .msg(
        Msg(
            account: "109ab0450",
            content: message,
            time: DateTime.now().toString(),
            article_id: int.parse(a.toString())),
      )
          .then((value) {
        print(value);
      });

      _commentTextController.clear();
      if (!mounted) return;
      FocusScope.of(context).unfocus();
      _showCommentBox.value = false;
    }
  }

  Future<void> _loadMore() async {
    // Ensure we're not already loading more activities.
    // if (!_isPaginating) {
    //   _isPaginating = true;
    //   context.
    //   feedBloc
    //       .loadMoreEnrichedActivities(feedGroup: _feedGroup, flags: _flags)
    //       .whenComplete(() {
    //     _isPaginating = false;
    //   });
    // }
  }

  @override
  void dispose() {
    _commentTextController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    eventRepo.getEventList().then((value) {
      print("list length" + value.length.toString());
      setState(() {
        list = value;
      });
    });

    super.initState();
  }

  List<Widget> getPost() {
    List<Widget> res = [];

    for (Event element in list) {
      res.add(PostCard(
        msg_list: element.msg,
        enrichedActivity: GenericEnrichedActivity(
            actor: User(
                data: StreamagramUser(
              firstName: '王',
              fullName: element.account,
              lastName: '小花',
              profilePhoto:
                  'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
            ).toMap()),
            time: element.createTime,
            target: element.article_id.toString()),
        onAddComment: openCommentBox,
        // article_id: element.account,
        // controller: editor.QuillController(
        //     document: editor.Document.fromJson(jsonDecode(element.content)),
        //     selection: TextSelection.collapsed(offset: 0)),
      ));
    }

    return res;
  }

  @override
  Widget build(BuildContext context) {
    StreamagramUser uuser = StreamagramUser(
      firstName: '王',
      fullName: '王小花',
      lastName: '小花',
      profilePhoto:
          'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
    );

    return Scaffold(
        resizeToAvoidBottomInset: false,
        // backgroundColor: Colors.transparent,
        body: Container(
            // width: 200,
            // height: 300,

            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
            child: Column(
              children: list.isEmpty
                  ? []
                  : [
                      Stack(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height - 100,
                            child: ListView(
                              children: getPost(),
                              scrollDirection: Axis.vertical,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0,
                                MediaQuery.of(context).size.height - 300, 0, 0),
                            // padding:  EdgeInsets.fromLTRB(0, _commentFocusNode.offset.dy, 0, 0),
                            child: _CommentBox(
                              textEditingController: _commentTextController,
                              focusNode: _commentFocusNode,
                              addComment: addComment,
                              showCommentBox: _showCommentBox,
                              commenter: uuser,
                            ),
                          )
                        ],
                      )
                    ],
            )));
  }

  getMainUI() {
    if (0 == 0) {
      return (Stack(
        children: [
          // FlatFeedCore(
          //   feedGroup: _feedGroup,
          //   errorBuilder: (context, error) =>
          //       const Text('Could not load profile'),
          //   loadingBuilder: (context) => const SizedBox(),
          //   emptyBuilder: (context) => const Center(
          //     child: Text('No Posts\nGo and post something'),
          //   ),
          //   flags: _flags,
          //   feedBuilder: (context, activities) {
          //     return RefreshIndicator(
          //       onRefresh: () {
          //         return FeedProvider.of(context)
          //             .bloc
          //             .refreshPaginatedEnrichedActivities(
          //               feedGroup: 'timeline',
          //               flags: EnrichmentFlags()
          //                 ..withOwnReactions()
          //                 ..withRecentReactions()
          //                 ..withReactionCounts(),
          //             );
          //       },
          //       child: ListView.builder(
          //         itemCount: activities.length,
          //         itemBuilder: (context, index) {
          //           // Pagination (Infinite scroll)
          //           bool shouldLoadMore = activities.length - 3 == index;
          //           if (shouldLoadMore) {
          //             _loadMore();
          //           }

          //           return PostCard(
          //             key: ValueKey('post-${activities[index].id}'),
          //             enrichedActivity: activities[index],
          //             onAddComment: openCommentBox,
          //           );
          //         },
          //       ),
          //     );
          //   },
          // ),
          _CommentBox(
            commenter: context.appState.streamagramUser!,
            textEditingController: _commentTextController,
            focusNode: _commentFocusNode,
            addComment: addComment,
            showCommentBox: _showCommentBox,
          )
        ],
      ));
    } else {
      return (Text("test"));
    }
  }
}

class _CommentBox extends StatefulWidget {
  const _CommentBox({
    Key? key,
    required this.commenter,
    required this.textEditingController,
    required this.focusNode,
    required this.addComment,
    required this.showCommentBox,
  }) : super(key: key);

  final StreamagramUser commenter;
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final Function(String?) addComment;
  final ValueNotifier<bool> showCommentBox;

  @override
  __CommentBoxState createState() => __CommentBoxState();
}

class __CommentBoxState extends State<_CommentBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
    reverseCurve: Curves.easeIn,
  );

  bool visibility = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          visibility = false;
        });
      } else {
        setState(() {
          visibility = true;
        });
      }
    });
    widget.showCommentBox.addListener(_showHideCommentBox);
  }

  void _showHideCommentBox() {
    if (widget.showCommentBox.value) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visibility,
      child: FadeTransition(
        opacity: _animation,
        child: Builder(builder: (context) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: CommentBox(
              commenter: widget.commenter,
              textEditingController: widget.textEditingController,
              focusNode: widget.focusNode,
              onSubmitted: widget.addComment,
            ),
          );
        }),
      ),
    );
  }
}
