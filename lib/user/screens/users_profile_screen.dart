import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProfilePage(),
  ));
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Map<String, dynamic> userData = {
    'userImage': 'assets/profile/aswanth.webp',
    'userName': 'Aswanth',
    'bio': 'Travel enthusiast and photographer.',
    'userPosts': [
      {
        'location': 'New York',
        'images': ['assets/bg2.jpg', 'assets/bg3.jpg']
      },
      {
        'location': 'Paris',
        'images': ['assets/location3.jpg', 'assets/location4.jpg']
      }
    ],
    'tripPhotos': [
      'assets/bg2.jpg',
      'assets/bg3.jpg',
      'assets/bg2.jpg',
    ],
  };

  bool showPosts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // User Image
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(userData['userImage']),
              onBackgroundImageError: (_, __) {
                print('Error loading profile image.');
              },
            ),
            const SizedBox(height: 10),
            // User Name
            Text(
              userData['userName'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            // User Bio
            Text(
              userData['bio'],
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Buttons (Posts and Trip Photos)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showPosts = true;
                      print("Posts button clicked");
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: showPosts ? Colors.blue : Colors.grey[300],
                  ),
                  child: const Text('Posts'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showPosts = false;
                      print("Trip Photos button clicked");
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: showPosts ? Colors.grey[300] : Colors.blue,
                  ),
                  child: const Text('Trip Photos'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Posts or Trip Photos
            showPosts ? buildPosts() : buildTripPhotos(),
          ],
        ),
      ),
    );
  }

  // Build Posts
  Widget buildPosts() {
    final List<dynamic> posts = userData['userPosts'];

    if (posts.isEmpty) {
      return const Center(child: Text('No posts yet.'));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        final location = post['location'];
        final images = post['images'];

        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                child: ImageSlideshow(images: images),
              ),
            );
          },
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Image.asset(
                images[0],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 50);
                },
              ),
              Container(
                color: Colors.black54,
                padding: const EdgeInsets.all(5),
                child: Text(
                  location,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Build Trip Photos
  Widget buildTripPhotos() {
    final List<dynamic> tripPhotos = userData['tripPhotos'];

    if (tripPhotos.isEmpty) {
      return const Center(child: Text('No trip photos yet.'));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemCount: tripPhotos.length,
      itemBuilder: (context, index) {
        return Image.asset(
          tripPhotos[index],
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image, size: 50);
          },
        );
      },
    );
  }
}

class ImageSlideshow extends StatefulWidget {
  final List<String> images;

  const ImageSlideshow({Key? key, required this.images}) : super(key: key);

  @override
  State<ImageSlideshow> createState() => _ImageSlideshowState();
}

class _ImageSlideshowState extends State<ImageSlideshow> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Image.asset(
            widget.images[currentIndex],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.broken_image, size: 50);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: currentIndex > 0
                  ? () {
                      setState(() {
                        currentIndex--;
                      });
                    }
                  : null,
              icon: const Icon(Icons.arrow_back),
            ),
            IconButton(
              onPressed: currentIndex < widget.images.length - 1
                  ? () {
                      setState(() {
                        currentIndex++;
                      });
                    }
                  : null,
              icon: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ],
    );
  }
}
