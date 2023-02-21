import 'package:flutter/material.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/profilescreen.dart';

import 'package:merchandising/utils/headerdrawer.dart';

class MerchandiserDrawer extends StatefulWidget {
  MerchandiserDrawer();

  @override
  State<MerchandiserDrawer> createState() => _MerchandiserDrawerState();
}

class _MerchandiserDrawerState extends State<MerchandiserDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              HeaderDrawer(),
              DrawerTiles(),
            ],
          ),
        ),
      ),
    );
  }

  Widget DrawerTiles() {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.of(context).pushNamed(ProfilePage.routeName);
                // Navigator.of(context).pushReplacementNamed('/');
                // Navigator.of(context)
                //     .pushReplacementNamed(WelcomeScreen.routeName);
              },
            ),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            ListTile(
              leading: Icon(Icons.dataset_outlined),
              title: Text('Logs'),
              onTap: () {
                // Navigator.of(context).pushReplacementNamed('/');
                // Navigator.of(context)
                //     .pushReplacementNamed(WelcomeScreen.routeName);
              },
            ),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            ListTile(
              leading: const Icon(Icons.add_moderator_outlined),
              title: const Text('RMS Version'),
              onTap: () {
                // Navigator.of(context).pushReplacementNamed('/');
                // Navigator.of(context)
                //     .pushReplacementNamed(WelcomeScreen.routeName);
              },
            ),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            ListTile(
              leading: const Icon(Icons.logout_sharp),
              title: const Text('Log Out'),
              onTap: () {
                // Navigator.of(context).pushReplacementNamed('/');
                // Navigator.of(context)
                //     .pushReplacementNamed(WelcomeScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
