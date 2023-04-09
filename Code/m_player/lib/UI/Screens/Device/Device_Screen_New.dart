import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:m_player/Utils/MyColors.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class Device_Screen_New extends StatefulWidget {
  const Device_Screen_New({Key? key}) : super(key: key);

  @override
  State<Device_Screen_New> createState() => _Device_Screen_NewState();
}

class _Device_Screen_NewState extends State<Device_Screen_New> {

  // final OnAudioQuery _audioQuery = OnAudioQuery();
  // final AudioPlayer _audioPlayer = AudioPlayer();
  //
  // @override
  // void initState() {
  //   super.initState();
  //   requestStoragePermission();
  // }
  //
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: FutureBuilder<List<SongModel>>(
  //       // default values
  //       future: _audioQuery.querySongs(
  //         sortType: null,
  //         orderType: OrderType.ASC_OR_SMALLER,
  //         uriType: UriType.EXTERNAL,
  //         ignoreCase: true,
  //       ),
  //       builder: (context, item){
  //         // loading content indicator
  //         if(item.data == null){
  //           return const Center(child: CircularProgressIndicator(),);
  //         }
  //         // no songs found
  //         if(item.data!.isNotEmpty){
  //           return const Center(child: Text("No Songs Found"),);
  //         }
  //         // showing the songs
  //         return ListView.builder(
  //           itemCount: item.data!.length,
  //           itemBuilder: (context, index){
  //             return ListTile(
  //               title: Text(item.data![index].title),
  //               subtitle: Text(item.data![index].displayName),
  //               trailing: const Icon(Icons.more_vert),
  //               leading: QueryArtworkWidget(
  //                 id: item.data![index].id,
  //                 type: ArtworkType.AUDIO,
  //                 nullArtworkWidget: Icon(Icons.music_note),
  //               ),
  //             );
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }
  //
  // void requestStoragePermission() async {
  //   // only if the platform is not web. (web has no permission)
  //   if(!kIsWeb){
  //     bool permissionStatus = await _audioQuery.permissionsStatus();
  //     if(!permissionStatus)
  //       await _audioQuery.permissionsRequest();
  //   }
  //  // Permission.storage.request();
  //
  //   // ensured build methods is called
  //   setState(() {
  //
  //   });
  // }
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestStoragePermission();
  }

  void requestStoragePermission() async {
    // Permission.storage.request();
    // only if the platform is not web. (web has no permission)
    if(!kIsWeb){
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if(!permissionStatus)
        await _audioQuery.permissionsRequest();
    }
    // Permission.storage.request();

    // ensured build methods is called
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true
        ),
        builder: (context, items){
          if(items.data == null){
            return const Center(child: CircularProgressIndicator(),);
          }
          if(items.data!.isEmpty){
            return const Center(child: Text("No Music Found"),);
          }
          return ListView.builder(
            itemCount: items.data!.length,
            itemBuilder: (context, index){
              return Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(10),
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
                        color: Colors.black
                    )
                  ]
                ),
                child: ListTile(
                  leading: QueryArtworkWidget(
                    id: items.data![index].id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: Icon(Icons.music_note),
                  ),
                  title: Text(items.data![index].title),
                  subtitle: Text("${items.data![index].artist}"),
                  trailing: const Icon(Icons.more_vert),
                  onTap: (){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Toast!")));
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
