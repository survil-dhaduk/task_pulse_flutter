import 'package:hive/hive.dart';

/// Interface for Hive database operations
abstract class HiveService {
  /// Initialize Hive boxes
  Future<void> init();
  
  /// Open a Hive box
  Future<Box> openBox(String boxName);
  
  /// Close a Hive box
  Future<void> closeBox(String boxName);
  
  /// Close all Hive boxes
  Future<void> closeAllBoxes();
  
  /// Delete a Hive box
  Future<void> deleteBox(String boxName);
  
  /// Check if a box is open
  bool isBoxOpen(String boxName);
} 