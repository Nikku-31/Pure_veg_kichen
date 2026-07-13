import 'package:flutter/material.dart';
import '../../AppManager/Model/LocationM/address_model.dart';

class AddressProvider extends ChangeNotifier {
  final List<AddressModel> _addresses = [];

  List<AddressModel> get addresses => _addresses;

  /// Add Address
  void addAddress(AddressModel address) {
    _addresses.add(address);
    notifyListeners();
  }

  /// Update Address
  void updateAddress(int index, AddressModel address) {
    if (index >= 0 && index < _addresses.length) {
      _addresses[index] = address;
      notifyListeners();
    }
  }

  /// Delete Address
  void deleteAddress(int index) {
    if (index >= 0 && index < _addresses.length) {
      _addresses.removeAt(index);
      notifyListeners();
    }
  }

  /// Get Single Address
  AddressModel getAddress(int index) {
    return _addresses[index];
  }

  /// Total Saved Addresses
  int get totalAddress => _addresses.length;

  /// Remove All Addresses
  void clearAddresses() {
    _addresses.clear();
    notifyListeners();
  }
}