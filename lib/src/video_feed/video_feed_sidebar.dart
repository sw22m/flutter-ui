import 'package:flutter/material.dart';
import 'axes_controls_widget.dart';

class VideoFeedSidebar extends StatelessWidget {
  const VideoFeedSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1), // changes position of shadow
        ),
      ],
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(icon: Icon(Icons.control_camera_sharp)),
                Tab(icon: Icon(Icons.new_label)),
              ]),
        Expanded(
          child: TabBarView(
              children: [
                AxesControlsWidget(),
                Center(child: Text('Tab 2 Content'))
              ]
            )
          ),
        ],
      ),
    ));
  }
}