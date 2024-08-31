import 'package:flutter/material.dart';

class FeedListScreen extends StatefulWidget {
  @override
  _FeedListScreenState createState() => _FeedListScreenState();
}

class _FeedListScreenState extends State<FeedListScreen> {
  List<Map<String, dynamic>> feedRecords =
      []; // This should be fetched from the backend
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFeedRecords();
  }

  Future<void> fetchFeedRecords() async {
    setState(() => isLoading = true);
    // TODO: Call the backend API to fetch feed records
    // Example: Using a service or repository pattern
    await Future.delayed(Duration(seconds: 2)); // Simulating network delay
    setState(() {
      feedRecords = [
        // Example data, replace with fetched data
        {
          "id": "1",
          "feed_type": "Starter Feed",
          "quantity": 100,
          "date": "2024-08-01"
        },
        {
          "id": "2",
          "feed_type": "Layer Feed",
          "quantity": 200,
          "date": "2024-08-05"
        },
      ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/createFeedRecord'),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : feedRecords.isEmpty
              ? Center(child: Text('No feed records found'))
              : ListView.builder(
                  itemCount: feedRecords.length,
                  itemBuilder: (context, index) {
                    final record = feedRecords[index];
                    return ListTile(
                      title: Text(record['feed_type']),
                      subtitle: Text(
                          'Quantity: ${record['quantity']} kg, Date: ${record['date']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.pushNamed(context, '/editFeedRecord',
                                  arguments: record);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _confirmDelete(record['id']),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Feed Record'),
        content: Text('Are you sure you want to delete this feed record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteFeedRecord(id);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> deleteFeedRecord(String id) async {
    // TODO: Call the backend API to delete the feed record
    setState(() => feedRecords.removeWhere((record) => record['id'] == id));
  }
}
