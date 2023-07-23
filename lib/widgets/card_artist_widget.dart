import 'package:flutter/material.dart';

import '../models/artist/get_artist_list_success_model.dart';

class CardArtistWidget extends StatelessWidget {
  const CardArtistWidget({
    super.key,
    required this.artist,
  });

  final Item artist;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey[200]!)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Text(
                artist.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              width: 40,
            ),
            Expanded(
              child: Column(
                children: [
                  const Text(
                    "Popularity/Followers",
                    style: TextStyle(fontSize: 10),
                  ),
                  Text(
                    "${artist.popularity}/${artist.followers.total}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
