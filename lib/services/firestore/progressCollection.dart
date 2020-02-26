import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daf_counter/consts/firestore.dart';
import 'package:daf_counter/consts/responses.dart';
import 'package:daf_counter/models/Response.dart';
import 'package:daf_counter/services/auth.dart';

class ProgressCollection {
  final Firestore _db = Firestore.instance;

  Future<ResponseModel> getProgress() async {
    String userId = await authService.getUserId();
    if (userId == null) return ResponsesConst.NOT_AUTHED;
    DocumentSnapshot progressDoc =
        await _db.collection(FirestoreConsts.PROGRESS_COLLECTION).document(userId).get();
    if (!progressDoc.exists) return ResponsesConst.DOCUMENT_NOT_FOUND;
    return ResponsesConst.GENERAL_SUCCESS.withData(progressDoc.data);
  }

  Future<ResponseModel> setProgress(Map<int, String> progress) async {
    String userId = await authService.getUserId();
    if (userId == null) return ResponsesConst.NOT_AUTHED;
    await _db.collection(FirestoreConsts.PROGRESS_COLLECTION).document(userId).setData(progress
        .map((int id, String progress) => MapEntry(id.toString(), progress)));
    // TODO: handel error
    return ResponsesConst.GENERAL_SUCCESS;
  }
}

final ProgressCollection progressCollection = ProgressCollection();
