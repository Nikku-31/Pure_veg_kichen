import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../AppManager/Model/LocationM/address_model.dart';

class AddressProvider extends ChangeNotifier {
  List<AddressModel> _addresses = [];

  List<AddressModel> get addresses => _addresses;

  int _userId = 0;

  /// Load User Addresses
  Future<void> loadAddresses(int userId) async {
    _userId = userId;

    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString("address_$userId");

    if (data != null) {
      final List decoded = jsonDecode(data);

      _addresses =
          decoded.map((e) => AddressModel.fromJson(e)).toList();
    } else {
      _addresses = [];
    }

    notifyListeners();
  }

  /// Save Addresses in SharedPreferences
  Future<void> _saveAddresses() async {
    final prefs = await SharedPreferences.getInstance();

    final data =
    jsonEncode(_addresses.map((e) => e.toJson()).toList());

    await prefs.setString(
      "address_$_userId",
      data,
    );
  }

  /// Add Address
  Future<void> addAddress(AddressModel address) async {
    _addresses.add(address);

    await _saveAddresses();

    notifyListeners();
  }

  /// Update Address
  Future<void> updateAddress(
      int index,
      AddressModel address,
      ) async {
    if (index >= 0 && index < _addresses.length) {
      _addresses[index] = address;

      await _saveAddresses();

      notifyListeners();
    }
  }

  /// Delete Address
  Future<void> deleteAddress(int index) async {
    if (index >= 0 && index < _addresses.length) {
      _addresses.removeAt(index);

      await _saveAddresses();

      notifyListeners();
    }
  }

  /// Get Single Address
  AddressModel getAddress(int index) {
    return _addresses[index];
  }

  /// Total Address
  int get totalAddress => _addresses.length;

  /// Clear All
  Future<void> clearAddresses() async {
    _addresses.clear();

    await _saveAddresses();

    notifyListeners();
  }
}