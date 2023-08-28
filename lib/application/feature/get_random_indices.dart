import 'dart:math';

List<int> getRandomIndices(int length) {
  var randomIndices = <int>[];
  var rng = Random();
  int maxLength = 5;
  if (length <= 5) {
    maxLength = length;
  }

  while (randomIndices.length < maxLength) {
    var index = rng.nextInt(length);
    if (!randomIndices.contains(index)) {
      randomIndices.add(index);
    }
  }

  return randomIndices;
}
