import 'package:flutter/material.dart';
import '../../Model/OrderM/add_ons_model.dart';
import '../../Service/OrderS/add_ons_service.dart';

class AddonVM extends ChangeNotifier {
  final AddonService _service = AddonService();

  bool isLoading = false;

  List<AddonData> addons = [];

  List<AddonData> selectedAddons = [];

  Map<int, bool> addonAvailable = {};

  Future<void> checkAddonAvailable(int itemId) async {
    try {
      final data = await _service.getAddons(itemId);

      addonAvailable[itemId] = data.isNotEmpty;
      notifyListeners();
    } catch (e) {
      addonAvailable[itemId] = false;
      notifyListeners();
    }
  }

  Future<void> getAddons(int itemId) async {
    try {
      isLoading = true;
      notifyListeners();

      addons = await _service.getAddons(itemId);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      addons = [];
      notifyListeners();

      debugPrint("Addon Error : $e");
    }
  }

  /// Select / Unselect Addon
  void toggleAddon(AddonData addon) {
    addon.isSelected = !addon.isSelected;

    if (addon.isSelected) {
      if (!selectedAddons.any((e) => e.addonId == addon.addonId)) {
        selectedAddons.add(addon);
      }
    } else {
      selectedAddons.removeWhere((e) => e.addonId == addon.addonId);
    }

    notifyListeners();
  }

  /// Clear Selection
  void clearSelection() {
    for (final addon in addons) {
      addon.isSelected = false;
    }

    selectedAddons.clear();
    notifyListeners();
  }
}