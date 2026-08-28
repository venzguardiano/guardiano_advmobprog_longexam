import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/theme_provider.dart';
import 'detail_screen.dart';

// Displays a list of interactive notifications that navigate to the detail view.
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  // Array storing 15 notification data objects with image and user information.
  final List<Map<String, String>> notifications = const [
    {
      'name': 'NBA Central',
      'post': 'posted a highlight clip',
      'description': 'Stephen Curry hits a crazy 30-foot buzzer beater! 🏀',
      'profile':
          'https://i.etsystatic.com/26217843/r/il/4730b2/3133102213/il_fullxfull.3133102213_r4sf.jpg',
      'image':
          'https://cdn-cf-east.streamable.com/image/stidwm.jpg?Expires=1700635680&Signature=TUFrOn1JKZ0bbUag2amqnCRg7GlKtcXWPWryH-tjyix3zeQcRNFb3bmlq0Mk1dBOBLVtPL4e0o6kw8HtB9lKv4~vlWDGDHQ4cIn95ermdAwAMhnzIh-mPRoQxBOyse~t2p3Rf7AIrGUUHN19GQ~FneVvGsvfJThGOrTS2jHpRJgsmEXNhLCmKrGkWWc5y687Rlak4~bit1BH6PI4goIMmih1Z-6Iepz8b8zqpYqHKmRlkd8JiE5rup~UxohasQymRF--r-yXZTjxTE64wujyCsyU6hc93TLsrGKbhLD9Z9KTHlivk4l7lst4TFrGeE9lTxYO-BSfb7LShIzR~3yI2w__&Key-Pair-Id=APKAIEYUVEN4EVB2OKEQ',
      'date': '10m ago',
    },
    {
      'name': 'Sneaker News',
      'post': 'announced a new release drop',
      'description': 'Air Jordan 4 OG Bred Restock coming this Saturday! 👟',
      'profile':
          'https://sneakernews.com/wp-content/uploads/2020/11/SN_Logo-01.png',
      'image':
          'https://images.sneakercharter.com/images/202107/uploaded/38d94cbf4b7d10dafd166c663d7be8dc.jpeg',
      'date': '25m ago',
    },
    {
      'name': 'PlayStation',
      'post': 'shared a new trailer',
      'description':
          'Check out the gameplay reveal for upcoming PS5 titles! 🎮',
      'profile':
          'https://4kwallpapers.com/images/wallpapers/playstation-logo-8k-7680x4320-14190.png',
      'image':
          'https://storage.googleapis.com/cdn.vcgamers.com/news/wp-content/uploads/2026/08/trailer-gta-VI-di-netflix-768x432.jpg',
      'date': '1h ago',
    },
    {
      'name': 'R&B Vibez Daily',
      'post': 'updated their playlist',
      'description':
          'New R&B drops featuring SZA, Brent Faiyaz, and Daniel Caesar 🎵',
      'profile':
          'https://splice-res.cloudinary.com/image/upload/f_auto,q_auto,w_auto/c_limit,w_450/v1667571883/cyi9bam1vwsvljyriesr.jpg',
      'image':
          'https://music.youtube.com/image/radioart?r=CjcKCi9tLzB0dGw0NzQKDS9nLzExZjE1aGoyam4KCy9tLzAxMjZtcjUwCg0vZy8xMWMzN2xyejU3EOgHGOgH',
      'date': '2h ago',
    },
    {
      'name': 'Esports Arena',
      'post': 'posted a tournament update',
      'description':
          'Mobile tournament finals live right now! Who takes it? 🏆',
      'profile':
          'https://alsacearena.com/wp-content/uploads/2020/10/AEA_LOGO_2019-e1602692052925.png',
      'image':
          'https://wallpapers.com/images/hd/gaming-tournaments-1920-x-1080-wallpaper-cg1vh6g5z2iuixlp.jpg',
      'date': '3h ago',
    },
    {
      'name': 'LeBron James Fans',
      'post': 'liked your photo',
      'description': 'Liked your basketball court picture.',
      'profile':
          'https://www.meme-arsenal.com/memes/82b827df025dd69acd004986dfe0f830.jpg',
      'image':
          'https://gappsi.com/wp-content/uploads/2014/12/asphalt-basket-ball-court-Pictures-design-build-contractor.-Suppliers-company-Remodeling-Services-Nassau-and-Suffolk-Long-island-NY-Gappsi..jpg',
      'date': '4h ago',
    },
    {
      'name': 'Cinema Spot',
      'post': 'posted a movie review',
      'description':
          'Dune Part 2 is officially certified fresh with 97% rating! 🎬',
      'profile':
          'https://static.vecteezy.com/system/resources/previews/005/714/928/original/cinema-logo-modern-design-concept-free-vector.jpg',
      'image':
          'https://tse4.mm.bing.net/th/id/OIP.DVvn7FCJS5rqMzuQ9F0VFAHaEU?r=0&rs=1&pid=ImgDetMain&o=7&rm=3',
      'date': '5h ago',
    },
    {
      'name': 'Frank Ocean Hub',
      'post': 'tagged you in a comment',
      'description': '“This R&B album breakdown is accurate!”',
      'profile':
          'https://numero.com/wp-content/uploads/2025/02/frank-ocean1.jpg',
      'image': '',
      'date': '6h ago',
    },
    {
      'name': 'Kicks on Fire',
      'post': 'shared your post',
      'description': 'Shared your sneaker collection photo to their timeline.',
      'profile': 'https://logodix.com/logo/1296921.png',
      'image':
          'https://bestwalkingfeet.com/wp-content/uploads/2016/06/largest-sneaker-collection-1.webp',
      'date': '8h ago',
    },
    {
      'name': 'Gaming Central',
      'post': 'sent you a game invite',
      'description': 'Invited you to join 2K25 Pro-Am Squad.',
      'profile':
          'https://tse2.mm.bing.net/th/id/OIP.hfFOMb5bIPqggjJAwe1-pgHaHa?r=0&rs=1&pid=ImgDetMain&o=7&rm=3',
      'image': '',
      'date': '12h ago',
    },
    {
      'name': 'Gym & Fitness',
      'post': 'commented on your status',
      'description': '“Late night workout session was intense!”',
      'profile':
          'https://www.creativefabrica.com/wp-content/uploads/2023/05/31/Gym-Logo-Fitness-Logo-Vector-Design-Graphics-70960708-1.jpg',
      'image':
          'https://images.unsplash.com/photo-1601986313624-28c11ac26334?crop=entropy&cs=srgb&fm=jpg&ixid=M3wyMDM2MjN8MHwxfHNlYXJjaHwzfHxuaWdodCUyMHdvcmtvdXR8ZW58MHx8fHwxNzM4NDQ5MTAwfDA&ixlib=rb-4.0.3&q=85',
      'date': '1d ago',
    },
    {
      'name': 'Spotify Philippines',
      'post': 'sent your Weekly Wrapped',
      'description': 'Your top genre this week was R&B / Soul!',
      'profile':
          'https://media.licdn.com/dms/image/v2/D5612AQG0jCMXP3iU8g/article-cover_image-shrink_720_1280/article-cover_image-shrink_720_1280/0/1733320747929?e=2147483647&v=beta&t=CvUx9DYAx3vl0AAJ5DaxYFNYM4nDdG4Pqx798rxGk10',
      'image': '',
      'date': '1d ago',
    },
    {
      'name': 'Nike Basketball',
      'post': 'reacted to your story',
      'description': 'Reacted 🔥 to your story post.',
      'profile':
          'https://static.nike.com/a/images/t_PDP_864_v1,f_auto,q_auto:eco/437f2f79-d34d-4e2b-8e0d-fcd3f6bef31c/kobe-playground-basketball-y7DP6lj1.png',
      'image': '',
      'date': '2d ago',
    },
    {
      'name': 'Movie Buffs Daily',
      'post': 'mentioned you in a post',
      'description': '“Check out this sci-fi series recommendation.”',
      'profile':
          'https://pbs.twimg.com/profile_images/1967095650618929152/Hbe6WZt6.jpg',
      'image': '',
      'date': '2d ago',
    },
    {
      'name': 'Rockstar Games',
      'post': 'sent a you an update',
      'description': 'Its coming! GTA VI!',
      'profile':
          'https://www.dexerto.com/cdn-image/wp-content/uploads/2024/02/28/gta-6-rockstar-games-leaks-action.jpg?width=1200&quality=75&format=auto',
      'image': '',
      'date': '3d ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Retrieves theme mode to set background and card colors dynamically.
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final bgColor = isDark ? VZ_PRIMARY_DARK : Colors.grey[100];
    final cardBg = isDark ? VZ_CARD_DARK : Colors.white;
    final textColor = isDark ? VZ_TEXT_WHITE : Colors.black87;
    final subTextColor = isDark ? VZ_TEXT_GRAY : Colors.grey[600]!;

    return Container(
      color: bgColor,
      // Builds a vertical scrollable list of notification cards.
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Card(
            color: cardBg,
            elevation: isDark ? 0 : 1,
            margin: EdgeInsets.symmetric(vertical: 4.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            // Navigates to DetailScreen with the selected notification content on tap.
            child: ListTile(
              onTap: () {
                // Pushes DetailScreen route with notification text and attached image URL.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                      userName: notif['name']!,
                      postContent: notif['description']!,
                      date: notif['date']!,
                      profileImageUrl: notif['profile']!,
                      imageUrl: notif['image']!,
                    ),
                  ),
                );
              },
              // Renders user avatar image in a circle.
              leading: CircleAvatar(
                backgroundImage: NetworkImage(notif['profile']!),
                radius: 22,
              ),
              // Formats notification text with bold author name.
              title: RichText(
                text: TextSpan(
                  style: TextStyle(color: textColor, fontSize: 14.sp),
                  children: [
                    TextSpan(
                      text: '${notif['name']} ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: notif['post'],
                      style: TextStyle(color: subTextColor),
                    ),
                  ],
                ),
              ),
              // Displays date subtitle text.
              subtitle: Text(
                notif['date']!,
                style: TextStyle(color: VZ_NEON_BLUE, fontSize: 11.sp),
              ),
              // Renders right chevron icon.
              trailing: Icon(Icons.chevron_right, color: subTextColor),
            ),
          );
        },
      ),
    );
  }
}
