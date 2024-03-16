import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.45,
      child: ListView(
        children: [
          ListTile(
            leading: Icon(
              Icons.account_circle_outlined,
              size: 30,
            ),
            title: Text(
              "PROFILE",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.home_outlined,
              size: 30,
            ),
            title: Text(
              "HOME",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.edit_calendar_outlined,
              size: 30,
            ),
            title: Text(
              "SCHEDULE",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.calendar_today_outlined,
              size: 30,
            ),
            title: Text(
              "CALENDAR",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              size: 30,
            ),
            title: Text(
              "SETTINGS",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
