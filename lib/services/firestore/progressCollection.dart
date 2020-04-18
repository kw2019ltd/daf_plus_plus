import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:daf_plus_plus/consts/firestore.dart';
import 'package:daf_plus_plus/consts/responses.dart';
import 'package:daf_plus_plus/models/Response.dart';
import 'package:daf_plus_plus/models/progress.dart';
import 'package:daf_plus_plus/services/auth.dart';

class ProgressCollection {
  final Firestore _db = Firestore.instance;

  Future<ResponseModel> getProgressMap() async {
    String userId = await authService.getUserId();
    if (userId == null) return ResponsesConst.NOT_AUTHED;
    DocumentSnapshot progressDoc = await _db
        .collection(FirestoreConsts.PROGRESS_COLLECTION)
        .document(userId)
        .get();
    if (!progressDoc.exists) return ResponsesConst.DOCUMENT_NOT_FOUND;
    return ResponsesConst.GENERAL_SUCCESS.withData(progressDoc.data);
  }

  Future<ResponseModel> setProgressMap(
      Map<String, ProgressModel> progressMap) async {
    String userId = await authService.getUserId();
    if (userId == null) return ResponsesConst.NOT_AUTHED;
    Map<String, String> progressData = progressMap.map(
        (String masechetId, ProgressModel progress) =>
            MapEntry(masechetId, progress.toString()));
    await _db
        .collection(FirestoreConsts.PROGRESS_COLLECTION)
        .document(userId)
        .setData(progressData);
    // TODO: handel error
    return ResponsesConst.GENERAL_SUCCESS;
  }
}

final ProgressCollection progressCollection = ProgressCollection();
