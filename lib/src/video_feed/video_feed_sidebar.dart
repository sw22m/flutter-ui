import 'package:flutter/material.dart';
import 'axes_controls_widget.dart';


class VideoFeedSidebar extends StatelessWidget {
  const VideoFeedSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 37, 35, 35),
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1), // changes position of shadow
        ),
      ],
      ),
      child: const DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              indicatorColor: Colors.green,
              tabs: [
                Tab(icon: Icon(Icons.control_camera_sharp)),
                Tab(icon: Icon(Icons.lightbulb_rounded)),
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