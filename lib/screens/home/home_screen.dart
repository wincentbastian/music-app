import 'package:flutter/material.dart';
import 'package:music_app/providers/home/home_provider.dart';
import 'package:music_app/screens/song/song_list_screen.dart';
import 'package:music_app/utils/helper.dart';
import 'package:music_app/widgets/card_artist_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

TextEditingController _searchTextEditingController = TextEditingController();

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<HomeProvider>(builder: ((context, provider, _) {
          if (provider.state == HomeResultState.initial) {
            return homeBody(provider);
          } else if (provider.state == HomeResultState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.state == HomeResultState.success) {
            return provider.artistList.artists.items.isEmpty
                ? const Center(
                    child: Text("Artist not found"),
                  )
                : homeSearchBody(provider);
          } else if (provider.state == HomeResultState.error) {
            return Center(
              child: Text(provider.message),
            );
          } else if (provider.state == HomeResultState.noConnection) {
            showToast(provider.message);
            return homeBody(provider);
          } else if (provider.state == HomeResultState.tokenExpired) {
            showToast(provider.message);
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              resetState(context);
              Navigator.pushReplacementNamed(context, "/splash-screen");
            });
          }
          return homeBody(provider);
        })),
      ),
    );
  }

  Padding homeSearchBody(HomeProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _searchTextEditingController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Search here',
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
              onPressed: () {
                provider.searchArtist(_searchTextEditingController.text);
              },
              child: const Text("Search")),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: provider.artistList.artists.items.length,
              itemBuilder: (context, index) {
                var artist = provider.artistList.artists.items.elementAt(index);
                return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SongListScreen(
                                    artistId: artist.id,
                                    artistName: artist.name,
                                  )));
                    },
                    child: CardArtistWidget(artist: artist));
              },
            ),
          )
        ],
      ),
    );
  }

  Padding homeBody(HomeProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchTextEditingController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search Artist',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  provider.searchArtist(_searchTextEditingController.text);
                },
                child: const Text("Search"))
          ],
        ),
      ),
    );
  }
}
