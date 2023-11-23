/*

*/
import 'package:flutter/material.dart';
import '../settings/settings_view.dart';
import '../video_feed/video_feed_view.dart';
import '../snapshot/snapshot_view.dart';

ListTile _createDrawerItem(BuildContext context, String text, IconData icon, String routeName, bool selected) {
  return ListTile(
      title: Text(text),
      selected: selected,
      textColor: selected ? Theme.of(context).colorScheme.primary : null,
      selectedTileColor: selected ? Theme.of(context).colorScheme.primaryContainer : null,
      iconColor: selected ? Theme.of(context).colorScheme.primary : null,
      leading: Icon(icon),
      // trailing: selected ? const Icon(Icons.) : null,
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
     );
  }


class _DrawerTop extends StatefulWidget {

  const _DrawerTop();

  @override
  State<_DrawerTop> createState() => _DrawerTopState();

}

class _DrawerTopState extends State<_DrawerTop> {

  final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: Theme.of(context).colorScheme.secondary,
      child: ListView(
        // Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Image(image: AssetImage('assets/images/logo.png')
            ),
          ),
          _createDrawerItem(context, 'Video Feed', Icons.mic_external_on, VideoFeedView.routeName, _selectedIndex == 0),
          _createDrawerItem(context, 'Snapshot', Icons.camera_alt, SnapshotView.routeName, _selectedIndex == 1),
          _createDrawerItem(context, 'Settings', Icons.settings_applications, SettingsView.routeName, _selectedIndex == 2)
        ],
      ),
    );
  }
}

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: [
      Expanded(flex: 1, child: _DrawerTop()),
    ]);
  }
}
