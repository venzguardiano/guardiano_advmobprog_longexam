import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screens/detail_screen.dart';
import 'custom_font.dart';

// Displays notification or post information list item with user profile image and details.
class CustomInformation extends StatelessWidget {
  final String name;
  final String post;
  final String description;
  final String profileImageUrl;
  final String date;
  final String imageUrl;
  final bool atProfile;

  const CustomInformation({
    super.key,
    required this.name,
    required this.post,
    required this.description,
    required this.profileImageUrl,
    required this.date,
    this.imageUrl = '',
    this.atProfile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.sp),
      // Makes item clickable to navigate to detail screen.
      child: InkWell(
        onTap: () {
          // Navigates to detail screen if not currently on profile page.
          if (!atProfile) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(
                  userName: name,
                  postContent: description,
                  date: date,
                  numOfLikes: 0,
                  imageUrl: imageUrl,
                  profileImageUrl: profileImageUrl,
                ),
              ),
            );
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Displays fallback person icon if profile image string is empty.
            profileImageUrl.isEmpty
                ? Icon(Icons.person, size: 30.sp)
                : CircleAvatar(
                    radius: 15.sp,
                    backgroundImage: AssetImage(profileImageUrl),
                  ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Renders user name in bold font.
                  CustomFont(
                    text: name,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  // Renders post summary text.
                  CustomFont(text: post, fontSize: 14.sp, color: Colors.black),
                  // Renders post description text in italic font.
                  CustomFont(
                    text: description,
                    fontSize: 12.sp,
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                  ),
                  SizedBox(height: 5.h),
                  // Renders post timestamp.
                  CustomFont(
                    text: date,
                    fontSize: 12.sp,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            // Renders options icon.
            const Icon(Icons.more_horiz),
          ],
        ),
      ),
    );
  }
}
