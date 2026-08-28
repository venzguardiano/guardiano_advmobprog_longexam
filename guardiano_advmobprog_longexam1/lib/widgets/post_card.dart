import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/theme_provider.dart';
import 'custom_font.dart';
import 'custom_button.dart';
import '../screens/detail_screen.dart';

// Reusable PostCard widget displaying post author, content, images, and like toggles.
class PostCard extends StatefulWidget {
  final String userName;
  final String postContent;
  final String date;
  final int numOfLikes;
  final bool hasImage;
  final String? postImagePath;
  final String? profileImagePath;

  const PostCard({
    super.key,
    required this.userName,
    required this.postContent,
    required this.date,
    this.numOfLikes = 0,
    this.hasImage = false,
    this.postImagePath,
    this.profileImagePath,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late int _currentLikes;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    // Initialize likes from parent post widget
    _currentLikes = widget.numOfLikes;
  }

  // Toggles the like state and updates the like count dynamically
  void _toggleLike() {
    setState(() {
      if (_isLiked) {
        _currentLikes--;
        _isLiked = false;
      } else {
        _currentLikes++;
        _isLiked = true;
      }
    });
  }

  // Navigates to detail screen and syncs back any like updates
  Future<void> _navigateToDetail() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          userName: widget.userName,
          postContent: widget.postContent,
          date: widget.date,
          numOfLikes: _currentLikes,
          imageUrl: widget.postImagePath ?? '',
          profileImageUrl: widget.profileImagePath ?? '',
        ),
      ),
    );

    // Update local state if likes were changed on the detail screen
    if (result != null && mounted) {
      setState(() {
        _currentLikes = result['likes'] ?? _currentLikes;
        _isLiked = result['isLiked'] ?? _isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Read theme state for dynamic card background and text colors
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final cardBg = isDark ? VZ_CARD_DARK : Colors.white;
    final textColor = isDark ? VZ_TEXT_WHITE : Colors.black87;
    final subTextColor = isDark ? VZ_TEXT_GRAY : Colors.grey[600]!;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      color: cardBg,
      elevation: isDark ? 0 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.w)),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author info header
            GestureDetector(
              onTap: _navigateToDetail,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20.sp,
                    backgroundColor: Colors.grey[400],
                    backgroundImage:
                        (widget.profileImagePath != null &&
                            widget.profileImagePath!.isNotEmpty)
                        ? NetworkImage(widget.profileImagePath!)
                        : null,
                    child:
                        (widget.profileImagePath == null ||
                            widget.profileImagePath!.isEmpty)
                        ? const Icon(Icons.person, color: Colors.white)
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
                      Row(
                        children: [
                          CustomFont(
                            text: widget.date,
                            fontSize: 12.sp,
                            color: subTextColor,
                          ),
                          SizedBox(width: 4.w),
                          Icon(Icons.public, size: 14.sp, color: subTextColor),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Icon(Icons.more_horiz, color: textColor),
                ],
              ),
            ),
            SizedBox(height: 8.h),

            // Post content text
            GestureDetector(
              onTap: _navigateToDetail,
              child: CustomFont(
                text: widget.postContent,
                fontSize: 13.sp,
                color: textColor,
              ),
            ),
            SizedBox(height: 8.h),

            // Optional post image display
            if (widget.hasImage && widget.postImagePath != null)
              GestureDetector(
                onTap: _navigateToDetail,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.w),
                  child: CachedNetworkImage(
                    imageUrl: widget.postImagePath!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 180.h,
                    placeholder: (context, url) => Container(
                      height: 180.h,
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            SizedBox(height: 10.h),

            // Action buttons row (Like, Comment, Share)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  buttonName: _isLiked
                      ? 'Liked ($_currentLikes)'
                      : 'Like ($_currentLikes)',
                  onPressed: _toggleLike,
                  buttonType: _isLiked ? 'filled' : 'outlined',
                  fontColor: _isLiked ? Colors.blue : textColor,
                  outlineColor: _isLiked ? Colors.blue : subTextColor,
                ),
                CustomButton(
                  buttonName: 'Comment',
                  onPressed: _navigateToDetail,
                  buttonType: 'outlined',
                  fontColor: textColor,
                  outlineColor: subTextColor,
                ),
                CustomButton(
                  buttonName: 'Share',
                  onPressed: () {},
                  buttonType: 'outlined',
                  fontColor: textColor,
                  outlineColor: subTextColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
