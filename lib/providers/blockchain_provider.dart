// lib/providers/blockchain_provider.dart

import 'package:flutter/material.dart';
import '../modals/IntegrityResult.dart';
import '../services/api_service.dart';
import '../services/api_service.dart' show IntegrityResult;

class BlockchainProvider extends ChangeNotifier {
  bool isVerifying = false;
  IntegrityResult? result;
  String? errorMessage;

  /// Returns true if integrity check passed, false otherwise.
  Future<bool> verifyIntegrity(int consultationId) async {
    isVerifying = true;
    errorMessage = null;
    notifyListeners();

    try {
      final res = await ApiService().verifyConsultationIntegrity(consultationId);
      result = res;
      return res.isValid;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isVerifying = false;
      notifyListeners();
    }
  }
}
