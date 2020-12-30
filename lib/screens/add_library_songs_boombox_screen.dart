import 'package:BoomBoxApp/providers/streaming_library_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddLibrarySongsBoomboxScreen extends StatefulWidget {
  @override
  _AddLibrarySongsBoomboxScreenState createState() =>
      _AddLibrarySongsBoomboxScreenState();
}

class _AddLibrarySongsBoomboxScreenState
    extends State<AddLibrarySongsBoomboxScreen> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer<StreamingLibraryManager>(
      builder: (context, streamingLibraryManager, child) {
        return SizedBox.expand(
          child: ListView.builder(
            controller: scrollController,
            itemCount: streamingLibraryManager.allLibrarySongs.length,
            itemBuilder: (BuildContext context, int index) {
              final currSong = streamingLibraryManager.allLibrarySongs[index]; 
              return ListTile(
                // leading: Image.network(currSong.appleMusicCatalogSong.attributes.),
                title: Text(
                 currSong.isrcId,
                  style: TextStyle(color: Colors.black54),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
