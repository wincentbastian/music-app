import 'package:flutter/material.dart';
import 'package:music_app/providers/song/song_provider.dart';
import 'package:music_app/utils/helper.dart';
import 'package:provider/provider.dart';

class MusicPlayerBottomSheet extends StatefulWidget {
  final String audioUrl;
  final String image;
  final String songName;
  final String artist;

  const MusicPlayerBottomSheet(
      {super.key,
      required this.audioUrl,
      required this.image,
      required this.songName,
      required this.artist});

  @override
  _MusicPlayerBottomSheetState createState() => _MusicPlayerBottomSheetState();
}

class _MusicPlayerBottomSheetState extends State<MusicPlayerBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SongProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(
                widget.image,
                width: 200,
                height: 200,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(widget.songName),
              Text(
                widget.artist,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
              Slider(
                min: 0.0,
                max: provider.duration.inMilliseconds.toDouble(),
                value: provider.position.inMilliseconds.toDouble(),
                onChanged: (double value) {
                  setState(() {
                    provider.seekAudio(Duration(milliseconds: value.toInt()));
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatDuration(provider.position),
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    formatDuration(provider.duration),
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              IconButton(
                iconSize: 50,
                onPressed: () {
                  provider.isPlaying
                      ? provider.pauseAudio()
                      : provider.playAudio(widget.audioUrl);
                },
                icon: Icon(provider.isPlaying ? Icons.pause : Icons.play_arrow),
              ),
            ],
          ),
        );
      },
    );
  }
}
