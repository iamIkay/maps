import 'package:flutter/material.dart';
import 'package:zavod/config/animate_route.dart';
import 'package:zavod/pages/history.dart';
import 'package:zavod/pages/home_page.dart';
import 'package:zavod/pages/profile.dart';
import 'package:zavod/pages/support.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          SizedBox(
            height: 140.0,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: GestureDetector(
                onTap:
                    () => Navigator.pushAndRemoveUntil(
                      context,
                      MyCustomRoute(builder: (context) => HomePage()),
                      (route) => false,
                    ),
                child: Text(
                  'Zavod',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MyCustomRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Support'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MyCustomRoute(builder: (context) => SupportChatPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('History'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MyCustomRoute(builder: (context) => MapHistoryPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
