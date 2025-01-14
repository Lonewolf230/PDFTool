import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final updatedPaths = [...state]..removeAt(index);
    state = updatedPaths;
  }

  void reorderPaths(int oldIndex, int newIndex) {
    // final paths = [...state];
    // if (oldIndex < newIndex) {
    //   newIndex -= 1;
    // }
    // final path = paths.removeAt(oldIndex);
    // paths.insert(newIndex, path);
    // state = paths;
    final updatedPaths = [...state];
    if (oldIndex < newIndex) {
      newIndex = -1;
    }
    final path = updatedPaths.removeAt(oldIndex);
    updatedPaths.insert(newIndex, path);
    state = updatedPaths;
  }

  List<Map<String, dynamic>> getPaths() {
    return state;
  }
}
