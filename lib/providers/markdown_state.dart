import 'package:flutter/foundation.dart';

class MarkdownState extends ChangeNotifier {
  bool previewMode = false;
  // List<String> markDownHistory = [];
  String content = "";
  final List<String> _undoStack = []; // Undo history
  final List<String> _redoStack = []; // Redo history
  final int _maxHistorySize = 50;

  void setPreviewMode(bool previewMode) {
    this.previewMode = previewMode;
    notifyListeners();
    // onNotifyParent?.call(); // Notify the parent (TabsManager)
  }

  void toggleView() {
    setPreviewMode(!previewMode);
    notifyListeners();
  }

  void setContent(String content) {
    this.content = content;
    notifyListeners();
  }

  /// Save a new version of the file
  void saveVersion(String newContent) {
    if (newContent == content) return; // No changes, skip saving
    print("Save content: $newContent");
    // Add current state to undo stack
    _addToUndoStack(content);

    // Update content
    setContent(newContent);

    // Clear redo stack as history diverges
    _redoStack.clear();
  }

  /// Undo the last change
  bool undo() {
    if (_undoStack.isEmpty) return false;

    // Push the current content onto the redo stack
    _addToRedoStack(content);

    // Restore the last state from undo stack
    setContent(_undoStack.removeLast());
    print("content after undo $content");
    return true;
  }

  /// Redo the last undone change
  bool redo() {
    if (_redoStack.isEmpty) return false;

    // Push the current content onto the undo stack
    _addToUndoStack(content);

    // Restore the next state from redo stack
    setContent(_redoStack.removeLast());
    return false;
  }

  /// Export the current state and history (e.g., for saving to a file)
  Map<String, dynamic> exportState() {
    return {
      "currentContent": content,
      "undoStack": List.of(_undoStack),
      "redoStack": List.of(_redoStack),
    };
  }

  /// Import state from saved data (e.g., on app reload)
  void importState(Map<String, dynamic> state) {
    content = state["currentContent"] ?? "";
    _undoStack.clear();
    _redoStack.clear();
    _undoStack.addAll(List<String>.from(state["undoStack"] ?? []));
    _redoStack.addAll(List<String>.from(state["redoStack"] ?? []));
  }

  /// Utility to print the current state for debugging
  void printState() {
    print('Current Content: $content');
    print('Undo Stack (${_undoStack.length}): $_undoStack');
    print('Redo Stack (${_redoStack.length}): $_redoStack');
  }

  // Add an item to the undo stack and respect history size limit
  void _addToUndoStack(String content) {
    if (_undoStack.length >= _maxHistorySize) {
      _undoStack.removeAt(0); // Remove oldest item
    }
    _undoStack.add(content);
  }

  // Add an item to the redo stack and respect history size limit
  void _addToRedoStack(String content) {
    if (_redoStack.length >= _maxHistorySize) {
      _redoStack.removeAt(0); // Remove oldest item
    }
    _redoStack.add(content);
  }
}
