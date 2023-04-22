import 'package:flutter/material.dart';
import 'package:m_player/UI/Playlist/OfflinePlayList.dart';
import 'package:m_player/UI/Playlist/OnlinePlaylist.dart';
import 'package:m_player/Utils/MyColors.dart';

class Playlists extends StatefulWidget {
  const Playlists({Key? key}) : super(key: key);

  @override
  State<Playlists> createState() => _PlaylistsState();
}

class _PlaylistsState extends State<Playlists>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                  color: myColors.yellow,
                ),
                labelColor: myColors.green,
                unselectedLabelColor: myColors.darkGreen,
                tabs: [
                  Tab(
                    text: 'Online Playlist',
                  ),

                  Tab(
                    text: 'Offline Playlist',
                  ),
                ],
              ),
            ),
            // tab bar view here
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  OnlinePlaylist(),
                  OfflinePlaylist()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
