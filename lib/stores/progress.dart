import 'package:daf_plus_plus/models/progress.dart';
import 'package:mobx/mobx.dart';

// flutter packages pub run build_runner build

// Include generated file
part 'progress.g.dart';

// This is the class used by rest of your codebase
class ProgressStore = _ProgressStore with _$ProgressStore;

// The store-class
abstract class _ProgressStore with Store {
  @observable
  ObservableMap<String, ProgressModel> _progressMap =
      ObservableMap<String, ProgressModel>.of({});

  @action
  void setProgress(String masechetId, ProgressModel progress) {
    _progressMap[masechetId] = progress;
  }

  @action
  ProgressModel getProgress(String masechetId) =>
      _progressMap[masechetId] ?? ProgressModel.fromString(null, masechetId);

  @action
  void setProgressMap(Map<String, ProgressModel> progressMap) {
    _progressMap = ObservableMap<String, ProgressModel>.linkedHashMapFrom(progressMap);
  }

  @action
  Map<String, ProgressModel> getProgressMap() => _progressMap;
}
