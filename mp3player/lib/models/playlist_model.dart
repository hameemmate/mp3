import 'package:hive/hive.dart';

class Playlist extends HiveObject {
  final String id;
  String name;
  List<String> songPaths;

  Playlist({required this.id, required this.name, required this.songPaths});
}

// Manual adapter (no code generation)
class PlaylistAdapter extends TypeAdapter<Playlist> {
  @override
  final int typeId = 0;

  @override
  Playlist read(BinaryReader reader) {
    final fields = reader.readMap().cast<int, dynamic>();
    return Playlist(
      id: fields[0] as String,
      name: fields[1] as String,
      songPaths: (fields[2] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Playlist obj) {
    writer.writeMap({0: obj.id, 1: obj.name, 2: obj.songPaths});
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistAdapter && runtimeType == other.runtimeType;
}
