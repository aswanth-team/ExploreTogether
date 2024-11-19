import 'package:flutter/material.dart';
import 'users_profile_screen.dart';
import 'users.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = "";
  Color getBorderColor(String gender) {
    if (gender == "Male") {
      return Colors.lightBlue;
    } else if (gender == "Female") {
      return Colors.pinkAccent.shade100;
    } else {
      return Colors.yellow.shade600;
    }
  }

  Color getShadowColor(String gender) {
    if (gender == "Male") {
      return Colors.lightBlue.withOpacity(0.1); // Light Blue with low opacity
    } else if (gender == "Female") {
      return Colors.pinkAccent.shade100
          .withOpacity(0.1); // Light Rose with low opacity
    } else {
      return Colors.yellow.shade600.withOpacity(0.1); // Yellow with low opacity
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredUsers = users
        .where((user) =>
            user['userName'].toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Search Users"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search by username...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
              ),
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UsersProfilePage(username: user['userName']),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5, // Adds a shadow around the card
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                    shadowColor: getShadowColor(
                        user['userGender']), // Shadow color based on gender
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors
                            .white, // Keep the card color the same (white)
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: getShadowColor(user['userGender']),
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: Offset(0, 2), // Shadow offset
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: getBorderColor(user['userGender']),
                                  width: 3.0,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundImage: AssetImage(user['userImage']),
                                radius: 30,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              user['userName'],
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
