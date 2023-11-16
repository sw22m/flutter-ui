import 'package:flutter/material.dart';
import '../settings/settings_view.dart';
import '../video_feed/video_feed_view.dart';
import '../snapshot/snapshot_view.dart';

class _DrawerTop extends StatelessWidget {
  const _DrawerTop({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: Colors.white,
      child: ListView(
        // Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Image(image: AssetImage('assets/images/logo.png')
            ),
          ),
          ListTile(
            title: const Text('Video Feed'),
            leading: const Icon(Icons.mic_external_on),
            onTap: () {
              Navigator.pushNamed(context, VideoFeedView.routeName);
            },
          ),
          ListTile(
              title: const Text('Snapshot'),
              leading: const Icon(Icons.camera_alt),
              onTap: () {
                Navigator.pushNamed(context, SnapshotView.routeName);
              }),
          ListTile(
            title: const Text('Settings'),
            leading: const Icon(Icons.settings_applications),
            onTap: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
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
      // Text('pyuscope v0.1'),
    
    ]);
  }
}
