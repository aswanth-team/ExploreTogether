import 'post_details_screen.dart';
import 'users_profile_screen.dart';
import 'package:flutter/material.dart';

class UserPost extends StatefulWidget {
  final int index;
  final String postId; // Add postId here
  final List<String> images;
  final String location;
  final String locationDescription;
  final String tripDuration;
  final String userImage;
  final String userName;
  final String userGender;
  final bool tripCompleted;
  final List<String> userVisitingPlaces;
  final List<String> userVistedPlaces;

  UserPost({
    required this.index,
    required this.postId, // Accept postId in the constructor
    required this.images,
    required this.location,
    required this.locationDescription,
    required this.tripDuration,
    required this.userImage,
    required this.userName,
    required this.userGender,
    required this.tripCompleted,
    required this.userVisitingPlaces,
    required this.userVistedPlaces,
  });

  @override
  _UserPostState createState() => _UserPostState();
}

class _UserPostState extends State<UserPost> {
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentPage = 0;
  }

  void _nextImage() {
    if (_currentPage < widget.images.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void _previousImage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  Color getBorderColor(String gender) {
    if (gender.toLowerCase() == "male") {
      return Colors.lightBlue;
    } else if (gender.toLowerCase() == "female") {
      return Colors.pinkAccent.shade100;
    } else {
      return Colors.yellow.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the post details screen when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(
              postId: widget.postId,
              username: widget.userName,
            ),
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: widget.tripCompleted
            ? Colors.green[100]
            : Colors.white, // Green if tripCompleted
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UsersProfilePage(username: widget.userName),
                          ),
                        );
                      },
                      child: Container(
                        width:
                            60, // Slightly larger than CircleAvatar radius * 2
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: getBorderColor(widget.userGender),
                            width: 2.0, // Border thickness
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(widget.userImage),
                        ),
                      )),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UsersProfilePage(username: widget.userName),
                        ),
                      );
                    },
                    child: Text(
                      widget.userName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              /* if (widget.tripCompleted)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    'Trip Completed!',
                    style: TextStyle(
                      color: Color.fromARGB(255, 51, 255, 0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ), */

              SizedBox(height: 10),
              GestureDetector(
                onTap: _nextImage,
                child: Container(
                  height: 250,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: widget.images.length,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              widget.images[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          );
                        },
                      ),
                      Positioned(
                        left: 10,
                        top: 100,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios,
                              color: Colors.white),
                          onPressed: _previousImage,
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 100,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios,
                              color: Colors.white),
                          onPressed: _nextImage,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  widget.location,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  widget.locationDescription,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              // Only show trip duration if the trip is not completed
              if (!widget.tripCompleted)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    'Duration Plan : ${widget.tripDuration}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),

              if (!widget.tripCompleted && widget.userVisitingPlaces.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Visiting Places Plan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 200, 118),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          // Calculate the number of columns based on available width
                          final crossAxisCount = (constraints.maxWidth / 100)
                              .floor(); // Adjust 100 for cell width
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  crossAxisCount > 0 ? crossAxisCount : 1,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio:
                                  2, // Adjust to decrease cell height
                            ),
                            itemCount: widget.userVisitingPlaces.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 244, 255, 215),
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Center(
                                  child: Text(
                                    widget.userVisitingPlaces[index],
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign
                                        .center, // Optional for multiline text
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),

              if (widget.tripCompleted && widget.userVistedPlaces.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Visited Places',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 104, 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          // Calculate the number of columns based on available width
                          final crossAxisCount = (constraints.maxWidth / 100)
                              .floor(); // Adjust 100 for cell width
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  crossAxisCount > 0 ? crossAxisCount : 1,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio:
                                  2, // Adjust to decrease cell height
                            ),
                            itemCount: widget.userVistedPlaces.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 179, 255, 251),
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Center(
                                  // Center aligns the text in the middle
                                  child: Text(
                                    widget.userVistedPlaces[index],
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign
                                        .center, // Optional for multiline text
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
