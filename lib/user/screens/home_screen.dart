import 'dart:math';

import 'package:flutter/material.dart';
import 'post_details_screen.dart';
import 'users_profile_screen.dart';
import 'users.dart';
import 'upload_trip_and_images_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Map<String, dynamic>> posts;

  late List<String> allSuggestions;
  late List<Map<String, dynamic>> searchResults;
  String selectedGender = 'All';
  String selectedCompletionStatus = 'All';
  String tripDuration = '';
  bool filterApplied = false;

  List<Map<String, dynamic>> _generatePostFeed(
      List<Map<String, dynamic>> users) {
    List<Map<String, dynamic>> allPosts = [];

    for (var user in users) {
      for (var post in user["userPosts"]) {
        allPosts.add({
          "postId": post["postId"],
          "images": post["locationImages"],
          "location": post["tripLocation"],
          "locationDescription": post["tripLocationDescription"],
          "buddyLoaction": post['userLocation'],
          "tripDuration": post["tripDuration"],
          "userImage": user["userImage"],
          "userName": user["userName"],
          "userVisitingPlaces":
              post["planToVisitPlaces"], // Use post instead of user

          "userGender": user["userGender"],
          "tripCompleted": post["tripCompleted"],
        });

        print(
            "User: ${user['userName']}, Visiting Places: ${post['planToVisitPlaces']}");
      }
    }

    allPosts.shuffle();
    return _interleavePostsByUser(allPosts);
  }

  List<Map<String, dynamic>> _interleavePostsByUser(
      List<Map<String, dynamic>> posts) {
    Map<String, List<Map<String, dynamic>>> userPosts = {};

    for (var post in posts) {
      userPosts.putIfAbsent(post['userName'], () => []).add(post);
    }

    List<Map<String, dynamic>> result = [];
    while (userPosts.isNotEmpty) {
      for (var user in userPosts.keys.toList()) {
        if (userPosts[user]!.isNotEmpty) {
          result.add(userPosts[user]!.removeAt(0));
        }
        if (userPosts[user]!.isEmpty) {
          userPosts.remove(user);
        }
      }
    }
    return result;
  }

  String filterLocation = '';
  List<Map<String, dynamic>> filteredPosts = [];

  // Helper function for Levenshtein Distance
  int levenshteinDistance(String s1, String s2) {
    List<List<int>> dp =
        List.generate(s1.length + 1, (_) => List<int>.filled(s2.length + 1, 0));

    for (int i = 0; i <= s1.length; i++) {
      for (int j = 0; j <= s2.length; j++) {
        if (i == 0) {
          dp[i][j] = j;
        } else if (j == 0) {
          dp[i][j] = i;
        } else if (s1[i - 1] == s2[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] =
              1 + [dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]].reduce(min);
        }
      }
    }
    return dp[s1.length][s2.length];
  }

  // Function to calculate string similarity based on Levenshtein distance
  double calculateStringSimilarity(String a, String b) {
    int maxLength = max(a.length, b.length);
    if (maxLength == 0) return 1.0;

    int distance = levenshteinDistance(a, b);
    return 1.0 - (distance / maxLength);
  }

  // Function to check if two strings are similar (with a customizable threshold)
  bool isSimilar(String query, String target, {double threshold = 0.7}) {
    return calculateStringSimilarity(
            query.toLowerCase(), target.toLowerCase()) >=
        threshold;
  }

  // Create a TextEditingController for the search bar
  TextEditingController _searchController = TextEditingController();
  TextEditingController tripDurationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    posts = _generatePostFeed(users);
    searchResults = posts;
    filteredPosts = searchResults;

    // Combine all post locations and visiting places into a unique list
    allSuggestions = posts
        .expand((post) {
          String? location = post['location'];
          List<dynamic>? visitingPlaces = post['userVisitingPlaces'];

          // Create a list containing location and visiting places
          List<String> suggestions = [];
          if (location != null && location.isNotEmpty) {
            suggestions.add(location); // Add location if it's not null
          }
          if (visitingPlaces != null) {
            suggestions.addAll(
                visitingPlaces.map((place) => place.toString()).toList());
          }
          return suggestions;
        })
        .toSet()
        .toList(); // Remove duplicates and convert to a list
  }

  // Function to apply filters after search
  void applyFilters() {
    setState(() {
      filterApplied = true;
      filteredPosts = searchResults.where((post) {
        // Gender filter
        if (selectedGender != 'All' &&
            post['userGender']?.toLowerCase() != selectedGender.toLowerCase()) {
          return false;
        }

        // Trip duration filter
        if (tripDuration.isNotEmpty) {
          int duration = int.tryParse(tripDuration) ?? 0;
          if (post['tripDuration'] != duration) return false;
        }

        if (selectedCompletionStatus != 'All') {
          bool isCompleted = post['tripCompleted'] ?? false;
          if (selectedCompletionStatus == 'Completed' && !isCompleted) {
            return false;
          }
          if (selectedCompletionStatus == 'Incomplete' && isCompleted) {
            return false;
          }
        }

        return true;
      }).toList();
    });
  }

  void resetFilters() {
    setState(() {
      selectedGender = 'All';
      selectedCompletionStatus = 'All';
      tripDuration = '';
      tripDurationController.clear();
      filterApplied = false;
      filteredPosts = posts;
    });
  }

  void onSearchChanged(String query) {
    setState(() {
      // Filter posts based on the search query
      searchResults = posts.where((post) {
        bool locationMatches = isSimilar(query, post['location'] ?? '');
        bool visitingPlacesMatch = (post['userVisitingPlaces'] ?? [])
            .any((place) => isSimilar(query, place.toString()));
        return locationMatches || visitingPlacesMatch;
      }).toList();

      // Apply the filter to the updated search results
      if (filterApplied) {
        applyFilters();
      } else {
        filteredPosts = searchResults; // Update visible posts
      }
    });
  }

  void showFilterPopup() {
    showDialog(
      context: context,
      barrierDismissible: true, // Allows dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Options'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Completion Status Dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Completion Status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DropdownButton<String>(
                          value: selectedCompletionStatus,
                          hint: Text('Select Status'),
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCompletionStatus = newValue!;
                            });
                          },
                          items: <String>['All', 'Incomplete', 'Completed']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    // Gender Dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gender',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DropdownButton<String>(
                          value: selectedGender,
                          hint: Text('Select Gender'),
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedGender = newValue!;
                            });
                          },
                          items: <String>['All', 'Male', 'Female', 'Others']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Trip Duration Text Field
                    TextFormField(
                      controller: tripDurationController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Trip Duration (days)',
                      ),
                      onChanged: (value) {
                        setState(() {
                          tripDuration = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),

                    // Buttons for Apply and Reset
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            applyFilters();
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('Apply'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            resetFilters();
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('Reset'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  height: 40,
                  child: Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<String>.empty();
                      }
                      return allSuggestions.where((suggestion) => suggestion
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()));
                    },
                    onSelected: (String selection) {
                      // Update the search results based on the selected suggestion
                      _searchController.text = selection;
                      onSearchChanged(selection);
                    },
                    optionsViewBuilder: (BuildContext context,
                        AutocompleteOnSelected<String> onSelected,
                        Iterable<String> options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4.0,
                          child: Container(
                            width: MediaQuery.of(context).size.width -
                                50, // Adjust width
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final option = options.elementAt(index);
                                return ListTile(
                                  title: Text(option),
                                  trailing: Icon(Icons.search,
                                      color: Colors.grey), // Add icon
                                  onTap: () {
                                    onSelected(option);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted) {
                      _searchController = textEditingController;
                      return TextField(
                        controller: _searchController,
                        focusNode: focusNode,
                        onChanged: onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Search by location',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0,
                            horizontal: 10.0,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                filterLocation = '';
                                filteredPosts = posts;
                                _searchController.clear();
                                selectedGender = 'All';
                                selectedCompletionStatus = 'All';
                                tripDuration = '';
                                tripDurationController.clear();
                                filterApplied = false;
                                filteredPosts = posts;
                              });
                            },
                          ),
                          prefixIcon: Icon(Icons.search),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.add_circle,
                size: 30,
                color: Colors.blueAccent,
              ),
              onPressed: () {
                print("Add button pressed");
              },
            ),
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: showFilterPopup,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredPosts.length,
              itemBuilder: (context, index) {
                final post = filteredPosts[index];
                return UserPost(
                  index: index,
                  postId: post['postId'], // Pass postId here
                  images: post['images'],
                  location: post['location'],
                  locationDescription: post['locationDescription'],
                  tripDuration: post['tripDuration'].toString(),
                  userImage: post['userImage'],
                  userName: post['userName'],
                  tripCompleted: post['tripCompleted'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class UserPost extends StatefulWidget {
  final int index;
  final String postId; // Add postId here
  final List<String> images;
  final String location;
  final String locationDescription;
  final String tripDuration;
  final String userImage;
  final String userName;
  final bool tripCompleted;

  UserPost({
    required this.index,
    required this.postId, // Accept postId in the constructor
    required this.images,
    required this.location,
    required this.locationDescription,
    required this.tripDuration,
    required this.userImage,
    required this.userName,
    required this.tripCompleted,
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
                      // Navigating to the ProfilePage with the username parameter
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UsersProfilePage(username: widget.userName),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(widget.userImage),
                    ),
                  ),
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
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: _previousImage,
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 100,
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward_ios,
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
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  widget.locationDescription,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              // Only show trip duration if the trip is not completed
              if (!widget.tripCompleted)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    'Duration Plan : ${widget.tripDuration}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              if (widget.tripCompleted)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    'Trip Completed!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
