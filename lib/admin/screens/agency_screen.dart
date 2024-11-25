import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../agencies.dart'; // Your agencies data

void main() {
  runApp(const MaterialApp(
    home: TravelAgencyPage(),
  ));
}

class TravelAgencyPage extends StatefulWidget {
  const TravelAgencyPage({super.key});

  @override
  _TravelAgencyPageState createState() => _TravelAgencyPageState();
}

class _TravelAgencyPageState extends State<TravelAgencyPage> {
  TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> filteredAgencies = [];
  String selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    filteredAgencies = agencies; // Initially, show all agencies
  }

  List<String> getCategories() {
    final categories = agencies.map((agency) => agency['category']).toSet();
    return ['All', ...categories]; // Add 'All' as the default option
  }

  void _filterAgencies(String query) {
    setState(() {
      filteredAgencies = agencies.where((agency) {
        final matchSearch =
            agency['agencyName']!.toLowerCase().contains(query.toLowerCase());
        final matchCategory =
            selectedCategory == "All" || agency['category'] == selectedCategory;
        return matchSearch && matchCategory;
      }).toList();
    });
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      filteredAgencies = agencies; // Reset to original agencies data
    });
  }

  // Simulated functions to update/remove agencies in the database
  void _updateAgency(Map<String, dynamic> updatedAgency) {
    // You can replace this function with actual database calls
    print('Agency Updated: ${updatedAgency['agencyName']}');
  }

  void _removeAgency(int index) {
    // You can replace this function with actual database calls
    setState(() {
      filteredAgencies.removeAt(index);
    });
    print('Agency Removed');
  }

  @override
  Widget build(BuildContext context) {
    final List<String> categories = getCategories();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Trip Providers"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) => _filterAgencies(query),
              decoration: InputDecoration(
                hintText: 'Search here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterAgencies(''); // Reset filter
                  },
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                final isSelected = category == selectedCategory;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                      _filterAgencies(_searchController.text);
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 4,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: filteredAgencies.length,
                itemBuilder: (context, index) {
                  final agency = filteredAgencies[index];
                  return GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey[100],
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            agency['agencyImage']!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              agency['agencyName']!,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  _showEditPopup(context, agency, index);
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _removeAgency(index);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditPopup(
      BuildContext context, Map<String, dynamic> agency, int index) {
    TextEditingController nameController =
        TextEditingController(text: agency['agencyName']);
    TextEditingController webController =
        TextEditingController(text: agency['agencyWeb']);
    TextEditingController categoryController =
        TextEditingController(text: agency['category']);

    // Use the agencyKeywords to initialize the tags list
    List<String> tags = List<String>.from(agency['agencyKeywords'] ?? []);

    // Controller for adding new tags
    TextEditingController tagController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Agency'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  // Implement image change logic here
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(agency['agencyImage']!),
                      radius: 30,
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Logic to update image
                      },
                    ),
                  ],
                ),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Agency Name'),
              ),
              TextField(
                controller: webController,
                decoration: const InputDecoration(labelText: 'Agency Web URL'),
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),

              // Displaying existing tags (agencyKeywords) as chips
              Wrap(
                spacing: 8.0,
                children: tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    deleteIcon: const Icon(Icons.cancel),
                    onDeleted: () {
                      setState(() {
                        tags.remove(tag);
                      });
                    },
                  );
                }).toList(),
              ),

              // TextField to input new tags (keywords)
              TextField(
                controller: tagController,
                decoration: const InputDecoration(labelText: 'Keywords (tags)'),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      tags.add(value);
                    });
                    tagController.clear(); // Clear the input after adding
                  }
                },
                onChanged: (value) {
                  // Optionally handle real-time changes
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Collect all data after editing
                Map<String, dynamic> updatedAgency = {
                  'agencyName': nameController.text,
                  'agencyWeb': webController.text,
                  'category': categoryController.text,
                  'agencyKeywords': tags, // Updated tags list
                  'agencyImage':
                      agency['agencyImage'], // For now, it stays the same
                };

                _updateAgency(
                    updatedAgency); // Update in DB (this is a placeholder function)
                setState(() {
                  filteredAgencies[index] = updatedAgency;
                });

                Navigator.pop(context); // Close the popup
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }

// Placeholder function for updating agency in DB (implement with actual DB logic)
  //void _updateAgency(Map<String, dynamic> updatedAgency) {
  // This function should interact with your database and update the agency data
  //   print('Updated agency: $updatedAgency');
//  }
}
