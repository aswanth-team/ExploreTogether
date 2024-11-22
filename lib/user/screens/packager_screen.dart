import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: PackagePage(),
  ));
}

class PackagePage extends StatefulWidget {
  @override
  _PackagePageState createState() => _PackagePageState();
}

class _PackagePageState extends State<PackagePage> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> users = [
    {'providername': 'Name1', 'provideImage': 'assets/image1.jpg'},
    {'providername': 'Name2', 'provideImage': 'assets/image2.jpg'},
    {'providername': 'Name3', 'provideImage': 'assets/image3.jpg'},
    // Add more provider data as needed
  ];
  List<Map<String, dynamic>> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    filteredUsers = users; // Initially, show all providers
  }

  // Update filtered users based on the search input
  void _filterProviders(String query) {
    setState(() {
      filteredUsers = users
          .where((user) =>
              user['providername']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Navigate to the ProviderDetailsPage
  void _navigateToProviderDetails(Map<String, dynamic> provider) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProviderDetailsPage(provider: provider),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trip Providers"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Bar with Autocomplete
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: 40,
                child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    return users
                        .where((user) => user['providername']!
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase()))
                        .map((user) => user['providername'] as String) // Cast to String
                        .toList(); // Return as List<String> (Iterable<String>)
                  },
                  onSelected: (String selection) {
                    _searchController.text = selection;
                    _filterProviders(selection);
                  },
                  optionsViewBuilder: (BuildContext context,
                      AutocompleteOnSelected<String> onSelected,
                      Iterable<String> options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 50,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final option = options.elementAt(index);
                              return ListTile(
                                title: Text(option),
                                trailing: Icon(Icons.search, color: Colors.grey),
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
                      onChanged: _filterProviders,
                      decoration: InputDecoration(
                        hintText: 'Search by provider name',
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
                              _searchController.clear();
                              filteredUsers = users; // Show all users
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
            // Grid of trip packages
            GridView.builder(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 4,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final provider = filteredUsers[index];
                return GestureDetector(
                  onTap: () => _navigateToProviderDetails(provider), // Navigate on tap
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[100],
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          offset: Offset(0, 2),
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          provider['provideImage']!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            provider['providername']!,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Icon(Icons.arrow_forward, color: Colors.blue),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProviderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> provider;

  // Constructor to receive provider details
  ProviderDetailsPage({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(provider['providername']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              provider['provideImage'],
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              'Provider Name: ${provider['providername']}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Additional details can be displayed here.',
              style: TextStyle(fontSize: 16),
            ),
            // You can add more details about the provider here
          ],
        ),
      ),
    );
  }
}
