import 'package:flutter/material.dart';
import 'package:m_player/Utils/MyColors.dart';

class OfflinePlaylist extends StatefulWidget {
  const OfflinePlaylist({Key? key}) : super(key: key);

  @override
  State<OfflinePlaylist> createState() => _OfflinePlaylistState();
}

class _OfflinePlaylistState extends State<OfflinePlaylist> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Create Playlist", style: TextStyle(fontSize: 18),),
                Flexible(
                  child: InkWell(
                    onTap: () async {
                      await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            contentPadding: const EdgeInsets.all(16.0),
                            content: new Row(
                              children: <Widget>[
                                new Expanded(
                                  child: new TextField(
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
                                  onPressed: () {
                                    Navigator.pop(context);
                                  })
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                          Icons.playlist_add,
                          size: 30,
                          color: myColors.green,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
