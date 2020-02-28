import 'package:daf_plus_plus/services/firestore/progressCollection.dart';
import 'package:daf_plus_plus/services/firestore/settingsCollection.dart';

class FirestoreService {
  ProgressCollection progress = progressCollection;
  SettingsCollection settings = settingsCollection;
}

final FirestoreService firestoreService = FirestoreService();
