import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/theme_provider.dart';
import '../widgets/post_card.dart';

// NewsFeedScreen displaying 15 scrollable posts and 5 native inline ads without scroll freezes.
class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({super.key});

  // Generates 15 customized feed posts.
  List<Map<String, dynamic>> generatePosts() {
    final random = Random();

    final List<Map<String, dynamic>> basePosts = [
      {
        'userName': 'Stephen Curry',
        'profileImagePath':
            'https://statico.profootballnetwork.com/wp-content/uploads/2025/04/21230150/golden-state-warriors-end-3-year-scoring-curse-3840x2560.jpg',
        'postContent': 'Back in the gym working on range! 🏀🔥',
        'hasImage': true,
        'postImagePath':
            'https://phantom-marca.unidadeditorial.es/12922bdd31214377ca4b663f4f9f7506/resize/828/f/jpg/assets/multimedia/imagenes/2024/07/08/17204569400569.jpg',
      },
      {
        'userName': 'Sneaker Collector',
        'profileImagePath':
            'https://static.vecteezy.com/system/resources/previews/047/763/220/non_2x/sneakers-shoes-logo-vintage-for-your-community-or-your-brand-tshirt-design-vector.jpg',
        'postContent': 'Fresh pick up today! Kobe 8 Protro looking clean 👟',
        'hasImage': true,
        'postImagePath':
            'https://sneakerbardetroit.com/wp-content/uploads/2024/04/Nike-Kobe-8-Protro-Lakers-Home-On-Feet-HF9550-100.jpg',
      },
      {
        'userName': 'PlayStation Nation',
        'profileImagePath':
            'https://i.pinimg.com/736x/6c/01/69/6c0169e271452f4b0c1fb82692704ad9.jpg',
        'postContent':
            'Weekend gaming session ready! What are you playing tonight? 🎮',
        'hasImage': true,
        'postImagePath':
            'https://whalesdev.com/wp-content/uploads/2025/02/TV-PS5-Pro-dewickedone5-2-e1740274932352-1024x926.jpg',
      },
      {
        'userName': 'R&B Soul Daily',
        'profileImagePath':
            'https://th.bing.com/th/id/OIP.Dp7jubdcAbB9HKPeD0NRtgHaHa?r=0&o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3',
        'postContent':
            'Frank Ocean and SZA playlist hits different on rainy days 🎵',
        'hasImage': false,
      },
      {
        'userName': 'Esports Arena',
        'profileImagePath':
            'https://images.seeklogo.com/logo-png/22/1/arena-sports-logo-png_seeklogo-227108.png',
        'postContent':
            'Mobile tournament finals live right now! Who takes it? 🏆',
        'hasImage': true,
        'postImagePath':
            'https://imgix.bustle.com/inverse/8a/c3/ce/ed/294d/4cfd/9e8f/3b14d0615c38/league-of-legends-world-championships.jpeg?w=1200&h=630&fit=crop&crop=faces&fm=jpg',
      },
      {
        'userName': 'Movie Buffs',
        'profileImagePath':
            'https://mir-s3-cdn-cf.behance.net/projects/404/f617ba66281503.Y3JvcCwxMzg0LDEwODMsMTcwLDA.png',
        'postContent': 'Interstellar soundtrack in IMAX is pure perfection 🎬',
        'hasImage': false,
      },
      {
        'userName': 'LeBron James',
        'profileImagePath':
            'https://tse1.mm.bing.net/th/id/OIP.Fvl92ZcioXUaqd7jj32UWAAAAA?r=0&rs=1&pid=ImgDetMain&o=7&rm=3',
        'postContent': 'Strive for greatness every single day! 👑',
        'hasImage': true,
        'postImagePath':
            'https://phantom-marca.unidadeditorial.es/a4dda9e8efc54f4842c4d54b2d42dada/resize/1320/f/jpg/assets/multimedia/imagenes/2023/02/08/16758325144709.jpg',
      },
      {
        'userName': 'Mobile Esports',
        'profileImagePath':
            'https://static-cdn.jtvnw.net/jtv_user_pictures/ce70ef3e-eab5-4c93-95de-8fbb310291e9-profile_image-300x300.png',
        'postContent':
            'Grand finals starting in 10 minutes! Who taking the trophy? 🏆',
        'hasImage': false,
      },
      {
        'userName': 'Kicks Central',
        'profileImagePath':
            'https://img.ws.mms.shopee.co.id/6ba984a6e7f33c5c934171424bf60531',
        'postContent': 'Travis Scott Jordan 1 Low rotation 👟🔥',
        'hasImage': true,
        'postImagePath':
            'https://sneakernews.com/wp-content/uploads/2022/06/travis-scott-air-jordan-1-low-og-dm7866-162-5.jpg',
      },
      {
        'userName': 'R&B Lounge',
        'profileImagePath':
            'https://img.freepik.com/premium-vector/rnb-logo-design-initial-letter-rnb-monogram-logo-using-hexagon-shape_1101554-47614.jpg?w=1060',
        'postContent':
            'Giveon, Brent Faiyaz, and Daniel Caesar late night vibes 🌌',
        'hasImage': true,
        'postImagePath':
            'https://yt3.googleusercontent.com/TQcLZ9VOypeTRFacUwZpFWkvuxFnex9HOYR2gOEn35Dy6pDyIh__Gzn4FxWo0-MqWozDtuh69qQ=s1200',
      },
      {
        'userName': 'Cinema Central',
        'profileImagePath':
            'https://static.vecteezy.com/system/resources/previews/005/188/413/non_2x/cinema-logo-template-isolated-on-white-background-vector.jpg',
        'postContent': 'Dune 2 IMAX experience was unforgettable 🏜️',
        'hasImage': true,
        'postImagePath':
            'https://i.pinimg.com/736x/6a/c4/d1/6ac4d1411c3b4c7fda77240f12affa42.jpg',
      },
      {
        'userName': 'NBA Hoop News',
        'profileImagePath':
            'https://tse2.mm.bing.net/th/id/OIP._IQNwUQQ7O1k4gTGQKlLmgHaHa?r=0&pid=ImgDet&w=474&h=474&rs=1&o=7&rm=3',
        'postContent':
            'Which team is winning the Finals this year? Comment below! 🏆',
        'hasImage': false,
      },
      {
        'userName': 'Tech & Games',
        'profileImagePath':
            'https://static.vecteezy.com/system/resources/previews/014/039/748/large_2x/game-and-tech-tree-logo-design-template-gaming-and-leaf-logo-design-template-vector.jpg',
        'postContent': 'PS5 Pro specs breakdown and game performance tests 🎮',
        'hasImage': false,
      },
      {
        'userName': 'Gym & Fitness Hub',
        'profileImagePath':
            'https://static.vecteezy.com/system/resources/previews/040/973/007/original/gym-center-logo-logo-design-for-gym-center-vector.jpg',
        'postContent': 'Consistency is key. Late night workout session 💪🏀',
        'hasImage': true,
        'postImagePath': 'https://c.stocksy.com/a/gn4300/z9/733440.jpg',
      },
      {
        'userName': 'Venz Guardiano',
        'profileImagePath':
            'https://ih1.redbubble.net/image.1094571479.7011/bg,f8f8f8-flat,750x,075,f-pad,750x1000,f8f8f8.jpg',
        'postContent': 'Taking off! 🚀',
        'hasImage': true,
        'postImagePath': 'https://i.imgflip.com/6ohyt2.jpg',
      },
    ];

    return basePosts.map((post) {
      final now = DateTime.now();
      final randomDays = random.nextInt(6);
      DateTime postDate = now.subtract(Duration(days: randomDays));

      String formattedDate = randomDays == 0
          ? "Today"
          : randomDays == 1
          ? "Yesterday"
          : "${postDate.month}/${postDate.day}/${postDate.year}";

      return {
        ...post,
        'numOfLikes': random.nextInt(600) + 50,
        'date': formattedDate,
      };
    }).toList();
  }

  // 5 Customized Advertisements
  List<Map<String, String>> adPosts() {
    return [
      {
        'profileImage':
            'https://static.vecteezy.com/system/resources/previews/010/994/236/large_2x/nike-logo-white-with-name-clothes-design-icon-abstract-football-illustration-with-black-background-free-vector.jpg',
        'sponsorName': 'Nike Basketball',
        'postContent': 'Check out the new Jordan OG Collection drops!',
        'imageUrl':
            'https://urbansyndicate.co.uk/wp-content/uploads/2024/07/Air-Jordan-1-Collectors-819x1024.webp',
        'cta': 'Shop Now',
      },
      {
        'profileImage':
            'https://4kwallpapers.com/images/wallpapers/playstation-logo-8k-7680x4320-14190.png',
        'sponsorName': 'PlayStation',
        'postContent': 'PlayHasNoLimits - New PS5 Titles available now!',
        'imageUrl':
            'https://static0.gamerantimages.com/wordpress/wp-content/uploads/2024/02/take-two-ceo-comments-on-impact-of-grand-theft-auto-6-trailer-leak.jpg',
        'cta': 'Explore Games',
      },
      {
        'profileImage':
            'https://cdn.pixabay.com/photo/2016/04/28/23/53/spotify-1360002_1280.jpg',
        'sponsorName': 'Spotify',
        'postContent': 'Stream pure R&B hits ad-free with lossless audio 🎵',
        'imageUrl':
            'https://i.scdn.co/image/ab67706f000000020dc0a69d6fd347575d626e3d',
        'cta': 'Get 3 Months Free',
      },
      {
        'profileImage':
            'https://static.vecteezy.com/system/resources/previews/047/763/218/large_2x/sneakers-shoes-logo-vintage-for-your-community-or-your-brand-tshirt-design-free-vector.jpg',
        'sponsorName': 'SNKRS App',
        'postContent': 'Exclusive restock alert for Jordan 1 Low Retro! 👟',
        'imageUrl':
            'https://www.shoepalace.com/cdn/shop/files/222fc7fbc14d5bd382550196bf91f2f8_2048x2048.jpg?v=1762793332&title=jordan-hq6999-600-air-jordan-1-retro-low-og-chicago-grade-school-lifestyle-shoes-varsity-red-summit-white-black',
        'cta': 'Enter Draw',
      },
      {
        'profileImage':
            'https://logos-world.net/wp-content/uploads/2020/11/Razer-Emblem.jpg',
        'sponsorName': 'Razer Gaming Gear',
        'postContent':
            'Level up your mobile gaming experience with DualSense Controllers 🎮',
        'imageUrl':
            'https://koanile.co.ke/wp-content/uploads/2024/12/IMG_0593.png',
        'cta': 'Order Today',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Retrieves dark mode state to set backgrounds appropriately.
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final bgColor = isDark ? VZ_PRIMARY_DARK : Colors.grey[100];

    final posts = generatePosts();
    final ads = adPosts();

    // Dynamically builds list items (interleaving 1 ad every 3 posts).
    List<Widget> feedItems = [];
    int adIndex = 0;

    for (int i = 0; i < posts.length; i++) {
      feedItems.add(
        PostCard(
          userName: posts[i]['userName'],
          profileImagePath: posts[i]['profileImagePath'],
          postContent: posts[i]['postContent'],
          numOfLikes: posts[i]['numOfLikes'],
          date: posts[i]['date'],
          hasImage: posts[i]['hasImage'],
          postImagePath: posts[i]['hasImage']
              ? posts[i]['postImagePath']
              : null,
        ),
      );

      if ((i + 1) % 3 == 0 && adIndex < ads.length) {
        feedItems.add(_buildAdCard(ads[adIndex], isDark));
        adIndex++;
      }
    }

    return Container(
      color: bgColor,
      // Uses ListView.builder to handle memory-efficient lazy scrolling without layout freezes.
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: feedItems.length,
        itemBuilder: (context, index) => feedItems[index],
      ),
    );
  }

  // Helper widget rendering individual ad cards without layout constraints errors.
  Widget _buildAdCard(Map<String, String> ad, bool isDark) {
    final cardBg = isDark ? VZ_CARD_DARK : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      color: cardBg,
      elevation: isDark ? 0 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            dense: true,
            leading: CircleAvatar(
              backgroundImage: NetworkImage(ad['profileImage']!),
              radius: 18,
            ),
            title: Text(
              ad['sponsorName']!,
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
            subtitle: Text(
              'Sponsored',
              style: TextStyle(color: Colors.grey[600], fontSize: 11),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              ad['postContent']!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: textColor, fontSize: 13),
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            child: Image.network(
              ad['imageUrl']!,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 140,
                color: Colors.grey[800],
                child: const Icon(Icons.broken_image, color: Colors.white),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              color: VZ_NEON_BLUE,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            ),
            child: Text(
              ad['cta']!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
