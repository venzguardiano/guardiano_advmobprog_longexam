import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/comment.dart';
import '../providers/theme_provider.dart';
import '../services/comment_service.dart';
import '../widgets/custom_font.dart';

// Detailed post view featuring comments list and persistent like counters
class DetailScreen extends StatefulWidget {
  final int postId;
  final String userName;
  final String postContent;
  final int numOfLikes;
  final bool isLiked;
  final String date;
  final String imageUrl;
  final String profileImageUrl;
  final int currentUserId;

  const DetailScreen({
    super.key,
    this.postId = 1,
    required this.userName,
    required this.postContent,
    this.numOfLikes = 0,
    this.isLiked = false,
    required this.date,
    this.imageUrl = '',
    this.profileImageUrl = '',
    this.currentUserId = 5,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late int _likes;
  late bool _isLiked;
  final CommentService _commentService = CommentService();
  final TextEditingController _commentController = TextEditingController();

  List<Comment> _comments = [];
  bool _isLoadingComments = true;
  bool _isAddingComment = false;

  @override
  void initState() {
    super.initState();
    _likes = widget.numOfLikes;
    _isLiked = widget.isLiked;
    _fetchComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // Fetch comments from API for this specific post
  Future<void> _fetchComments() async {
    try {
      final fetched = await _commentService.getCommentsByPostId(widget.postId);
      if (!mounted) return;
      setState(() {
        _comments = fetched;
        _isLoadingComments = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingComments = false);
    }
  }

  // Submit new comment and persist in local array
  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isAddingComment = true);

    try {
      final newComment = await _commentService.addComment(
        body: text,
        postId: widget.postId,
        userId: widget.currentUserId,
      );

      if (!mounted) return;
      setState(() {
        _comments.insert(0, newComment);
        _commentController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Comment published!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to publish comment'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isAddingComment = false);
    }
  }

  // Toggle like status and notify parent screen on pop
  void _toggleLikes() {
    setState(() {
      if (_isLiked) {
        _likes -= 1;
        _isLiked = false;
      } else {
        _likes += 1;
        _isLiked = true;
      }
    });
  }

  // Handle back button to send updated likes to PostCard
  void _onPopBack() {
    Navigator.pop(context, {'likes': _likes, 'isLiked': _isLiked});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final bgColor = isDark ? VZ_PRIMARY_DARK : Colors.grey[100];
    final cardBg = isDark ? VZ_CARD_DARK : Colors.white;
    final textColor = isDark ? VZ_TEXT_WHITE : Colors.black87;
    final subTextColor = isDark ? VZ_TEXT_GRAY : Colors.grey[600]!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _onPopBack();
      },
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: cardBg,
          elevation: 1,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: _onPopBack,
          ),
          title: CustomFont(
            text: widget.userName,
            fontSize: ScreenUtil().setSp(18),
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Author Header
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20.sp,
                          backgroundImage: widget.profileImageUrl.isNotEmpty
                              ? NetworkImage(widget.profileImageUrl)
                              : null,
                          child: widget.profileImageUrl.isEmpty
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomFont(
                              text: widget.userName,
                              fontSize: 15.sp,
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                            Text(
                              widget.date,
                              style: TextStyle(
                                color: subTextColor,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    // Post Body Text
                    CustomFont(
                      text: widget.postContent,
                      fontSize: 14.sp,
                      color: textColor,
                    ),
                    SizedBox(height: 12.h),

                    // Image attachment
                    if (widget.imageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.w),
                        child: Image.network(
                          widget.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                    SizedBox(height: 12.h),
                    Divider(color: subTextColor),

                    // Interactive Action Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton.icon(
                          onPressed: _toggleLikes,
                          icon: Icon(
                            Icons.thumb_up,
                            color: _isLiked ? VZ_NEON_BLUE : subTextColor,
                          ),
                          label: Text(
                            _likes == 0 ? 'Like' : '$_likes Likes',
                            style: TextStyle(
                              color: _isLiked ? VZ_NEON_BLUE : subTextColor,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.comment, color: subTextColor),
                          label: Text(
                            '${_comments.length} Comments',
                            style: TextStyle(color: subTextColor),
                          ),
                        ),
                      ],
                    ),
                    Divider(color: subTextColor),
                    SizedBox(height: 8.h),

                    // Comments List Header
                    CustomFont(
                      text: 'Comments',
                      fontSize: 16.sp,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 10.h),

                    _isLoadingComments
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: VZ_NEON_BLUE,
                            ),
                          )
                        : _comments.isEmpty
                        ? Text(
                            'No comments yet. Be the first to comment!',
                            style: TextStyle(color: subTextColor),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _comments.length,
                            itemBuilder: (context, index) {
                              final comment = _comments[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 8.h),
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  color: cardBg,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomFont(
                                      text: comment.userFullName,
                                      fontSize: 13.sp,
                                      color: VZ_NEON_BLUE,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    SizedBox(height: 4.h),
                                    CustomFont(
                                      text: comment.body,
                                      fontSize: 13.sp,
                                      color: textColor,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),

            // Comment input field bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              color: cardBg,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: 'Write a comment...',
                        hintStyle: TextStyle(color: subTextColor),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  _isAddingComment
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          icon: const Icon(Icons.send, color: VZ_NEON_BLUE),
                          onPressed: _submitComment,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
