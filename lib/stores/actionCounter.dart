// TODO: this class is temperary, we neede to have proper state management.

class ActionCounterStore {
  int _numberOfActions = 0;

  void increment([int by = 1]) {
    _numberOfActions += by;
  }

  void clear() {
    _numberOfActions = 0;
  }

  get numberOfActions => _numberOfActions;

}

final ActionCounterStore actionCounterStore = ActionCounterStore();