import 'package:hive/hive.dart';
import 'hive_service.dart';

/// Implementation of HiveService
class HiveServiceImpl implements HiveService {
  final Map<String, Box> _openBoxes = {};

  @override
  Future<void> init() async {
    // Hive is already initialized in service_locator.dart
    // This method can be used for additional initialization if needed
  }

  @override
  Future<Box> openBox(String boxName) async {
    if (_openBoxes.containsKey(boxName)) {
      return _openBoxes[boxName]!;
    }
    
    final box = await Hive.openBox(boxName);
    _openBoxes[boxName] = box;
    return box;
  }

  @override
  Future<void> closeBox(String boxName) async {
    if (_openBoxes.containsKey(boxName)) {
      await _openBoxes[boxName]!.close();
      _openBoxes.remove(boxName);
    }
  }

  @override
  Future<void> closeAllBoxes() async {
    for (final box in _openBoxes.values) {
      await box.close();
    }
    _openBoxes.clear();
  }

  @override
  Future<void> deleteBox(String boxName) async {
    await closeBox(boxName);
    await Hive.deleteBoxFromDisk(boxName);
  }

  @override
  bool isBoxOpen(String boxName) {
    return _openBoxes.containsKey(boxName);
  }
} 