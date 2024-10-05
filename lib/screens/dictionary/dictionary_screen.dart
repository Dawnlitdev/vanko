import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/services/database_helper.dart';
import '/widgets/word_details.dart';
import '/widgets/change_dialect_popup.dart';
import '/widgets/change_dialect_button.dart';
import '/widgets/custom_search_bar.dart';
import '/widgets/filter_popup.dart';

class DictionaryScreen extends StatefulWidget {
  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  List<Map<String, dynamic>> wordList = [];
  List<Map<String, dynamic>> filteredWordList = [];
  String selectedDialect = 'UpperWancho'; // Default selected dialect
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadSavedDialect(); // Load the saved dialect when the screen initializes
    _loadData(); // Load data based on the selected dialect
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose of the ScrollController
    super.dispose();
  }

  Future<void> _loadSavedDialect() async {
    // Load the saved dialect from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedDialect = prefs.getString('selectedDialect') ?? 'UpperWancho';
    });
    _loadData(); // Reload data after setting the saved dialect
  }

  Future<void> _saveDialect(String dialect) async {
    // Save the selected dialect to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedDialect', dialect);
  }

  Future<void> _loadData() async {
    // Fetch data for the selected dialect
    List<Map<String, dynamic>> data =
        await DatabaseHelper.instance.fetchData(selectedDialect);

    // Update state with fetched data
    setState(() {
      wordList = data;
      filteredWordList = data; // Initialize with all data
    });
  }

  void _onWordTap(Map<String, dynamic> word) {
    // Show dialog with word details
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WordDetails(
            word: word, tableName: selectedDialect); // Enhanced Popup
      },
    );
  }

  void _onSearchResult(List<Map<String, dynamic>> results) {
    // Update state with search results from CustomSearchBar
    setState(() {
      filteredWordList = results;
    });
  }

  void _onFilterSelected(String filter) {
    // Find the first word that starts with the selected alphabet
    int index = filteredWordList.indexWhere((word) {
      final englishWord = word['English Word']?.toLowerCase() ?? '';
      return englishWord.startsWith(filter.toLowerCase());
    });

    if (index != -1 && _scrollController.hasClients) {
      // Ensure ScrollController is attached
      _scrollController.animateTo(
        index * 85.0, // Adjust the offset calculation if needed
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onChangeDialect(String newDialect) {
    // Update selected dialect and reload data
    setState(() {
      selectedDialect = newDialect;
      _saveDialect(newDialect); // Save the new dialect to SharedPreferences
      _loadData(); // Reload data for the new dialect
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vanko',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'English to Wancho Dictionary',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize:
              Size.fromHeight(48.0), // Height of the bottom widget area
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ChangeDialectButton(
                  selectedDialect: selectedDialect,
                  onPressed: () {
                    // Show change dialect popup dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomChangeDialectPopup(
                          currentDialect: selectedDialect,
                          onChangeDialect: _onChangeDialect,
                        );
                      },
                    );
                  },
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.filter_list, color: Colors.white),
                  label: Text('Filter', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 3, 48, 132), // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Show filter popup dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomFilterPopup(
                            onFilterSelected: _onFilterSelected);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.grey[100], // Light background color
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomSearchBar(
                wordList: wordList, // Pass the full word list to the search bar
                onSearchResult: _onSearchResult, // Callback with search results
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: filteredWordList.length,
                  itemBuilder: (context, index) {
                    final word = filteredWordList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => _onWordTap(word),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        word['English Word'] ?? '',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        word['Wancho Word'] ?? '',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios,
                                    size: 16, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
