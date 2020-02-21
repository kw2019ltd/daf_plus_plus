class GematriaConverter {
// this converter can convert numbers under 400.

  List<List<String>> _alphabet = [
    ['', 'א', 'ב', 'ג', 'ד', 'ה', 'ו', 'ז', 'ח', 'ט'],
    ['', 'י', 'כ', 'ל', 'מ', 'נ', 'ס', 'ע', 'פ', 'צ'],
    ['', 'ק', 'ר', 'ש', 'ת'],
  ];

  Map<String, String> _exceptions = {"יה": "טו", "יו": "טז"};

  String _solveExceptions(String letter) {
    if (_exceptions.containsKey(letter)) return _exceptions[letter];
    return letter;
  }

  String toGematria(int number) {
    List<String> numbers = (number + 1).toString().split('').reversed.toList();
    List<String> letters = numbers
        .asMap()
        .map((int index, String number) {
          return MapEntry(index, _alphabet[index][(int.parse(number)) % 10]);
        })
        .values
        .toList()
        .reversed
        .toList();
    return _solveExceptions(letters.join());
  }
}

final GematriaConverter gematriaConverter = GematriaConverter();
