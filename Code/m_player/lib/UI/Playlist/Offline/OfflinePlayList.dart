import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:m_player/UI/Playlist/Offline/Playlist_Songs_Offline.dart';
import 'package:m_player/Utils/MyColors.dart';
import 'package:on_audio_query/on_audio_query.dart';

class OfflinePlaylist extends StatefulWidget {
  const OfflinePlaylist({Key? key}) : super(key: key);

  @override
  State<OfflinePlaylist> createState() => _OfflinePlaylistState();
}

class _OfflinePlaylistState extends State<OfflinePlaylist> {

  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _player = AudioPlayer();
  late final SongModel songModel;
  TextEditingController playlistName = TextEditingController();
  late Future<List<PlaylistModel>> playlist;
  final myPlaylist = OnAudioQuery.platform.queryPlaylists();

  @override
  void initState() {
    // TODO: implement initState
    playlist = myPlaylist;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(
          backgroundColor: myColors.yellow,
          foregroundColor: myColors.darkGreen,
          child: Icon(Icons.add),
          onPressed: () async {
            await showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  contentPadding: const EdgeInsets.all(16.0),
                  content: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new TextField(
                          controller: playlistName,
                          autofocus: true,
                          decoration: new InputDecoration(
                              labelText: 'Playlist Name'),
                        ),
                      )
                    ],
                  ),
                  actions: <Widget>[
                    new TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    new TextButton(
                        child: const Text('Save'),
                        onPressed: () async {
                          setState(() async {
                            String name = playlistName.text.toString();
                            print(name);
                            await OnAudioQuery.platform.createPlaylist(name);
                            playlistName.clear();
                            Navigator.of(context).pop();
                          });
                        }
                        )
                  ],
                );
              },
            );
          },
        ),
      ),

      body: FutureBuilder<List<PlaylistModel>>(
        future: _audioQuery.queryPlaylists(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true
        ),
        builder: (context, item){
          if(item.data == null){
            return const Center(child: CircularProgressIndicator(),);
          }
          if(item.data!.isEmpty){
            return const Center(child: Text("No Playlist."),);
          }
          // playlist.clear();
          // playlist = item.data!;
          return ListView.builder(
              itemCount: item.data!.length,
              itemBuilder: (context, index){
                return Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: myColors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: const[
                        BoxShadow(
                            blurRadius: 4.0,
                            offset: Offset(-4, -4),
                            color: Colors.white24
                        ),
                        BoxShadow(
                            blurRadius: 4.0,
                            offset: Offset(4, 4),
                            color: Colors.black12
                        )
                      ]
                  ),
                  child: ListTile(
                    leading: QueryArtworkWidget(
                      id: item.data![index].id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: Icon(Icons.featured_play_list),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        setState(() async {
                          await OnAudioQuery.platform.removePlaylist(item.data![index].id);
                        });
                      },
                    ),
                    title: Text(item.data![index].playlist),
                    subtitle: Text("${item.data![index].numOfSongs}"),
                    onTap: () async {
                      print("Details : ");
                      print(item.data![index].id);
                      print(item.data![index].data);
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder:
                              (context) =>
                                  PlaylistSongsOffline(
                                    playlistModel: item.data![index],
                                    playlistId: item.data![index].id,
                                  ))
                      );
                    },
                  ),
                );
              }
          );
        },
      ),
    );
  }
}