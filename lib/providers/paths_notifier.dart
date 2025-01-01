import 'package:riverpod/riverpod.dart';

final pathsProvider =
    StateNotifierProvider<PathsNotifier, List<Map<String, dynamic>>>((ref) {
  return PathsNotifier();
});

class PathsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  PathsNotifier() : super([]);

  void setPaths(List<Map<String, dynamic>> paths) {
    state = List.from(paths);
  }

  void removePath(int index) {
    state = [...state]..removeAt(index);
  }

  void reorderPaths(int oldIndex, int newIndex) {
    final paths = [...state];
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final path = paths.removeAt(oldIndex);
    paths.insert(newIndex, path);
    state = paths;
  }

  List<Map<String, dynamic>> getPaths() {
    return state;
  }
}
