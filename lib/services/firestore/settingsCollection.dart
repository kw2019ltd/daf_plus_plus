import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daf_plus_plus/consts/firestore.dart';
import 'package:daf_plus_plus/consts/responses.dart';
import 'package:daf_plus_plus/models/Response.dart';
import 'package:daf_plus_plus/services/auth.dart';

class SettingsCollection {
  final Firestore _db = Firestore.instance;

  Future<ResponseModel> getSettings() async {
    String userId = await authService.getUserId();
    if (userId == null) return ResponsesConst.NOT_AUTHED;
    DocumentSnapshot settingsDoc =
        await _db.collection(FirestoreConsts.SETTINGS_COLLECTION).document(userId).get();
    if (!settingsDoc.exists) return ResponsesConst.DOCUMENT_NOT_FOUND;
    return ResponsesConst.GENERAL_SUCCESS.withData(settingsDoc.data);
  }

  Future<ResponseModel> updateSettings(Map<String, dynamic> settings) async {
    String userId = await authService.getUserId();
    if (userId == null) return ResponsesConst.NOT_AUTHED;
    await _db.collection(FirestoreConsts.SETTINGS_COLLECTION).document(userId).setData(settings, merge: true);
    // TODO: handel error
    return ResponsesConst.GENERAL_SUCCESS;
  }
  
}

final SettingsCollection settingsCollection = SettingsCollection();
