import 'package:get/get.dart';

class SidebarController extends GetxController {
  static const double minWidth = 180.0;
  static const double defaultWidth = 250.0;
  static const double maxWidth = 450.0;
  static const double collapseThreshold = 160.0;
  static const double collapsedWidth = 64.0;

  final sidebarWidth = defaultWidth.obs;
  final isCollapsed = false.obs;
  final isDragging = false.obs;
  final isHoveringHandle = false.obs;

  double _savedExpandedWidth = defaultWidth;

  void addDelta(double deltaX) {
    if (isCollapsed.value) {
      if (deltaX > 15) {
        // Dragging right while collapsed expands it back
        isCollapsed.value = false;
        sidebarWidth.value = (minWidth + deltaX).clamp(minWidth, maxWidth);
        _savedExpandedWidth = sidebarWidth.value;
      }
      return;
    }

    final newWidth = sidebarWidth.value + deltaX;
    if (newWidth < collapseThreshold) {
      // Snap to collapsed icon-only mode
      isCollapsed.value = true;
      sidebarWidth.value = collapsedWidth;
    } else {
      isCollapsed.value = false;
      sidebarWidth.value = newWidth.clamp(minWidth, maxWidth);
      _savedExpandedWidth = sidebarWidth.value;
    }
  }

  void toggle() {
    if (isCollapsed.value) {
      isCollapsed.value = false;
      sidebarWidth.value = _savedExpandedWidth >= minWidth ? _savedExpandedWidth : defaultWidth;
    } else {
      _savedExpandedWidth = sidebarWidth.value;
      isCollapsed.value = true;
      sidebarWidth.value = collapsedWidth;
    }
  }

  void resetToDefault() {
    isCollapsed.value = false;
    sidebarWidth.value = defaultWidth;
    _savedExpandedWidth = defaultWidth;
  }
}
