import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/post.dart';
import '../providers/theme_provider.dart';
import '../services/post_service.dart';
import '../widgets/custom_font.dart';
import '../widgets/custom_button.dart';
import '../widgets/post_card.dart';

// This allows the cover photo, user bio, and sticky TabBarView to scroll naturally together as one continuous screen.
class ProfileScreen extends StatefulWidget {
  final String profileName;
  final int userId;
  final String? profileImage;

  const ProfileScreen({
    super.key,
    required this.profileName,
    this.userId = 5,
    this.profileImage,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Service instance to fetch user posts via API
  final PostService _postService = PostService();
  List<Post> _userPosts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Load initial user posts when widget is mounted
    _fetchUserPosts();
  }

  // Async function requesting user-specific posts from DummyJSON backend
  Future<void> _fetchUserPosts() async {
    try {
      final posts = await _postService.getPostsByUserId(widget.userId);
      if (!mounted) return;
      setState(() {
        _userPosts = posts;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      // Handle request error gracefully by stopping loading indicator
      setState(() => _isLoading = false);
    }
  }

  // Profile metadata items displayed inside the "About" tab
  final List<Map<String, dynamic>> aboutInfos = const [
    {
      'icon': Icons.location_city,
      'title': 'Hometown',
      'subtitle': 'Manila, Philippines',
    },
    {'icon': Icons.cake, 'title': 'Birthday', 'subtitle': 'July 30, 2005'},
    {
      'icon': Icons.favorite,
      'title': 'Status',
      'subtitle': 'In a Relationship',
    },
    {'icon': Icons.person, 'title': 'Gender', 'subtitle': 'Male'},
    {
      'icon': Icons.music_note,
      'title': 'Favorite Music',
      'subtitle': 'R&B / Soul / Hip-Hop',
    },
    {
      'icon': Icons.sports_basketball,
      'title': 'Sports',
      'subtitle': 'NBA Basketball',
    },
    {
      'icon': Icons.gamepad,
      'title': 'Console Gaming',
      'subtitle': 'PlayStation 5',
    },
    {
      'icon': Icons.phone_android,
      'title': 'Mobile Gaming',
      'subtitle': 'Esports & Strategy Games',
    },
    {
      'icon': Icons.movie,
      'title': 'Movies & Series',
      'subtitle': 'Sci-Fi & Action Thrillers',
    },
  ];

  // 8 High-resolution, reliable Unsplash photo URLs (7th problematic image removed)
  final List<String> photos = const [
    'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=500', // Basketball
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500', // Sneakers
    'https://images.unsplash.com/photo-1606813907291-d86efa9b94db?w=500', // PlayStation 5 Controller
    'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=500', // Music Studio / R&B Vibes
    'https://images.unsplash.com/photo-1511512578047-dfb367046420?w=500', // Gaming Setup
    'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=500', // Cinema Theater
    'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=500', // Streetwear Sneakers
    'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=500', // Gym / Training
  ];

  @override
  Widget build(BuildContext context) {
    // Dynamically retrieve theme mode (Light vs Dark) to set backgrounds and text contrast
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final Color bgColor = isDark
        ? VZ_PRIMARY_DARK
        : (Colors.grey[100] ?? Colors.white);
    final Color textColor = isDark ? VZ_TEXT_WHITE : Colors.black87;
    final Color subTextColor = isDark
        ? VZ_TEXT_GRAY
        : (Colors.grey[600] ?? Colors.grey);

    // Profile picture URL with fallback handling
    final avatarUrl =
        (widget.profileImage != null && widget.profileImage!.isNotEmpty)
        ? widget.profileImage!
        : 'https://i.pravatar.cc/150?img=68';

    // 5 Personalized profile posts matching your interests
    final customPosts = [
      {
        'content':
            'Late night R&B playlist hit different tonight. SZA and Frank Ocean on repeat 🎵',
        'likes': 342,
        'img':
            'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=600',
      },
      {
        'content':
            'Mobile esports tournament finals tonight! Squad is locked in and ready 🎮🔥',
        'likes': 512,
        'img':
            'https://images.unsplash.com/photo-1511512578047-dfb367046420?w=600',
      },
      {
        'content':
            'Copped the new Kobe 8 Protros today! Cleanest pair in the rotation 👟🏀',
        'likes': 689,
        'img':
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600',
      },
      {
        'content':
            'PS5 gaming session with the squad. Ready for 2K25 tournament! 🎮',
        'likes': 210,
        'img':
            'https://images.unsplash.com/photo-1606813907291-d86efa9b94db?w=600',
      },
      {
        'content': 'Interstellar soundtrack and IMAX movie night 🎬',
        'likes': 415,
        'img': '',
      },
    ];

    return Scaffold(
      backgroundColor: bgColor,
      body: DefaultTabController(
        length: 3,
        // NestedScrollView solves unconstrained height bugs by coordinating inner list scrolling with outer slivers
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // Holds the top cover banner, profile picture, name, and action buttons
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cover photo containing exact NBA image
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 180.h,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                'https://cdn.nba.com/manage/2023/01/MID-SEASON-SURVEY-PLAYERS-16X9-UPDATED.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Overlaid circular profile avatar
                        Positioned(
                          bottom: -40.h,
                          left: 20.w,
                          child: CircleAvatar(
                            radius: 45,
                            backgroundImage: CachedNetworkImageProvider(
                              avatarUrl,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 45.h),

                    // User full name, stats, and interactive follow/message buttons
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomFont(
                            text: widget.profileName,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                            color: textColor,
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Text(
                                '50K ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                'followers • ',
                                style: TextStyle(color: subTextColor),
                              ),
                              Text(
                                '1 ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                'following',
                                style: TextStyle(color: subTextColor),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              CustomButton(
                                buttonName: 'Follow',
                                onPressed: () {},
                                buttonType: 'elevated',
                                fontColor: Colors.white,
                                backgroundColor: VZ_NEON_BLUE,
                              ),
                              SizedBox(width: 10.w),
                              CustomButton(
                                buttonName: 'Message',
                                onPressed: () {},
                                buttonType: 'elevated',
                                fontColor: Colors.white,
                                backgroundColor: VZ_NEON_BLUE,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10.h),
                  ],
                ),
              ),

              // Pinned TabBar header that locks at the top when scrolling down
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabBarDelegate(
                  TabBar(
                    indicatorColor: VZ_NEON_BLUE,
                    labelColor: VZ_NEON_BLUE,
                    unselectedLabelColor: subTextColor,
                    tabs: const [
                      Tab(text: 'Posts'),
                      Tab(text: 'About'),
                      Tab(text: 'Photos'),
                    ],
                  ),
                  bgColor,
                ),
              ),
            ];
          },
          // Tab views rendered seamlessly inside NestedScrollView body
          body: TabBarView(
            children: [
              // 1. Posts Tab: Renders dynamic API posts or customized fallback posts
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: VZ_NEON_BLUE),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(8.w),
                      itemCount: _userPosts.length >= 5
                          ? _userPosts.length
                          : customPosts.length,
                      itemBuilder: (context, index) {
                        if (_userPosts.length >= 5) {
                          final post = _userPosts[index];
                          return PostCard(
                            userName: widget.profileName,
                            profileImagePath: avatarUrl,
                            postContent: post.body,
                            numOfLikes: post.likes,
                            date: 'Recent',
                          );
                        } else {
                          final post = customPosts[index];
                          return PostCard(
                            userName: widget.profileName,
                            profileImagePath: avatarUrl,
                            postContent: post['content'] as String,
                            numOfLikes: post['likes'] as int,
                            date: 'Recent',
                            hasImage: (post['img'] as String).isNotEmpty,
                            postImagePath: (post['img'] as String).isNotEmpty
                                ? post['img'] as String
                                : null,
                          );
                        }
                      },
                    ),

              // 2. About Tab: Renders structured bio list items with icons
              ListView.builder(
                padding: EdgeInsets.all(10.w),
                itemCount: aboutInfos.length,
                itemBuilder: (context, index) {
                  final info = aboutInfos[index];
                  return ListTile(
                    leading: Icon(info['icon'], color: VZ_NEON_BLUE),
                    title: Text(
                      info['title'],
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      info['subtitle'],
                      style: TextStyle(color: subTextColor),
                    ),
                  );
                },
              ),

              // 3. Photos Tab: Renders 3-column GridView displaying working 8 images
              GridView.builder(
                padding: EdgeInsets.all(10.w),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      photos[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: isDark ? Colors.grey[800] : Colors.grey[300],
                          child: Icon(Icons.broken_image, color: subTextColor),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom delegate for locking the TabBar in place as the user scrolls
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  final Color backgroundColor;

  _SliverTabBarDelegate(this._tabBar, this.backgroundColor);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: backgroundColor, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor;
  }
}
