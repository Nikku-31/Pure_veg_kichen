import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/DashboardM/menu_item_model.dart';
import '../../Model/DashboardM/wishlist_model.dart';

class WishlistVM extends ChangeNotifier {
  String _wishlistKey(String userId) => "wishlist_items_$userId";

  Future<String> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();

    return (prefs.getInt("userId") ?? 0).toString();
  }

  final List<WishlistModel> _wishlist = [];

  List<WishlistModel> get wishlist => _wishlist;

  /// Load Wishlist
  Future<void> loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = await _getUserId();

    final List<String> data =
        prefs.getStringList(_wishlistKey(userId)) ?? [];

    _wishlist.clear();

    for (var item in data) {
      _wishlist.add(
        WishlistModel.fromJson(jsonDecode(item)),
      );
    }

    notifyListeners();
  }
  /// Save Wishlist
  Future<void> _saveWishlist() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = await _getUserId();

    final List<String> data =
    _wishlist.map((e) => jsonEncode(e.toJson())).toList();

    await prefs.setStringList(
      _wishlistKey(userId),
      data,
    );
  }

  /// Check Item Exists
  bool isWishlisted(String itemId) {
    return _wishlist.any((e) => e.id == itemId);
  }

  /// Add Item
  Future<void> addToWishlist(MenuItemModel item) async {
    if (isWishlisted(item.id)) return;

    _wishlist.add(
      WishlistModel.fromMenuItem(item),
    );

    await _saveWishlist();

    notifyListeners();
  }
  /// Remove Item
  Future<void> removeFromWishlist(String itemId) async {
    _wishlist.removeWhere((e) => e.id == itemId);

    await _saveWishlist();

    notifyListeners();
  }

  /// Toggle Wishlist
  Future<void> toggleWishlist(MenuItemModel item) async {
    if (isWishlisted(item.id)) {
      await removeFromWishlist(item.id);
    } else {
      await addToWishlist(item);
    }
  }

  /// Clear Wishlist
  Future<void> clearWishlist() async {
    _wishlist.clear();

    final prefs = await SharedPreferences.getInstance();

    final userId = await _getUserId();

    await prefs.remove(
      _wishlistKey(userId),
    );

    notifyListeners();
  }
}