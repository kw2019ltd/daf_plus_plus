import 'package:daf_counter/services/firestore/progressCollection.dart';
import 'package:daf_counter/services/firestore/settingsCollection.dart';

class FirestoreService {
  ProgressCollection progress = progressCollection;
  SettingsCollection settings = settingsCollection;
}

final FirestoreService firestoreService = FirestoreService();
