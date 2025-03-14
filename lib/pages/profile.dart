import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zavod/widgets/app_drawer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
        drawer: AppDrawer(),
        body: ListView(
          padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 30.0),
          children: [
            Text(
              "Profile",
              style: TextStyle(
                fontSize: 24.0,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.0),
            ProfileField(
              label: "First Name",
              value: "James",
              icon: CupertinoIcons.person_fill,
            ),
            ProfileField(
              label: "Last Name",
              value: "Bond",
              icon: CupertinoIcons.person_fill,
            ),
            ProfileField(
              label: "Email",
              value: "jbond@gmail.com",
              icon: Icons.email,
            ),

            SizedBox(height: 30.0),

            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                "Edit Profile",

                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const ProfileField({
    required this.label,
    required this.value,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w600)),

          SizedBox(height: 4.0),

          TextField(
            controller: TextEditingController(text: value),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              hintText: label,
              hintStyle: const TextStyle(fontSize: 16.0),
              prefixIcon: Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 20.0,
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 40.0),

              fillColor: Colors.white30,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              floatingLabelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.0, color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
