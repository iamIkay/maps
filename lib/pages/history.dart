import 'package:flutter/material.dart';
import 'package:zavod/widgets/app_drawer.dart';

// Sample navigation history data
final List<Map<String, String>> navigationHistory = [
  {'from': 'Home', 'to': 'Office', 'date': '2023-10-01 08:00 AM'},
  {'from': 'Office', 'to': 'Gym', 'date': '2023-10-01 06:00 PM'},
  {'from': 'Gym', 'to': 'Home', 'date': '2023-10-01 08:00 PM'},
  {'from': 'Home', 'to': 'Supermarket', 'date': '2023-10-02 10:00 AM'},
  {'from': 'Supermarket', 'to': 'Home', 'date': '2023-10-02 11:30 AM'},
];

class MapHistoryPage extends StatelessWidget {
  const MapHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      drawer: AppDrawer(),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
            child: Text(
              "Map History",
              style: TextStyle(
                fontSize: 22.0,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ListView.builder(
            itemCount: navigationHistory.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final record = navigationHistory[index];
              return ListTile(
                leading: Icon(
                  Icons.directions,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  '${record['from']} to ${record['to']}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text('Date: ${record['date']}'),
                onTap: () {
                  // You can add navigation to a map view here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Navigating from ${record['from']} to ${record['to']}',
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
