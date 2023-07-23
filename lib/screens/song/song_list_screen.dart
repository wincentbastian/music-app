import 'package:flutter/material.dart';
import 'package:music_app/providers/song/song_provider.dart';
import 'package:music_app/utils/helper.dart';
import 'package:music_app/widgets/music_player_bottom_sheet.dart';
import 'package:provider/provider.dart';

class SongListScreen extends StatefulWidget {
  const SongListScreen(
      {super.key, required this.artistId, required this.artistName});

  final String artistId;
  final String artistName;

  @override
  State<SongListScreen> createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SongProvider provider = Provider.of<SongProvider>(context, listen: false);
      provider.setInitial();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<SongProvider>(builder: ((context, provider, _) {
          if (provider.state == SongResultState.intial) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              provider.getSongList(widget.artistId);
            });
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.state == SongResultState.success) {
            return songBody(provider);
          } else if (provider.state == SongResultState.error) {
            showToast(provider.message);
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.pop(context);
            });
            return songBody(provider);
          } else if (provider.state == SongResultState.tokenExpired) {
            showToast(provider.message);
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              resetState(context);
              Navigator.pushReplacementNamed(context, "/splash-screen");
            });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        })),
      ),
    );
  }

  Padding songBody(SongProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.artistName,
                      style: const TextStyle(
                          fontSize: 60, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.black,
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: provider.songList.tracks.length,
            itemBuilder: (context, index) {
              var song = provider.songList.tracks.elementAt(index);
              String image = song.album.images.isNotEmpty
                  ? song.album.images[0].url
                  : "https://cdn0.iconfinder.com/data/icons/internet-2020/1080/Applemusicandroid-1024.png";
              return InkWell(
                onTap: () async {
                  showMusicPlayerBottomSheet(
                      context, song.name, image, song.previewUrl, provider);
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey[200]!)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Row(
                      children: [
                        Image.network(
                          image,
                          width: 100,
                          height: 100,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              song.name,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w800),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ))
        ],
      ),
    );
  }

  void showMusicPlayerBottomSheet(BuildContext parentContext, String songName,
      String image, String url, SongProvider provider) {
    provider.setTime();
    showModalBottomSheet(
        context: parentContext,
        builder: (BuildContext context) {
          return Scaffold(
            body: SingleChildScrollView(
              child: MusicPlayerBottomSheet(
                  audioUrl: url,
                  image: image,
                  songName: songName,
                  artist: widget.artistName),
            ),
          );
        });
  }
}
