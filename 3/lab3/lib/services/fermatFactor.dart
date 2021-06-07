import 'dart:math';

class FermatFactor {
  double n;
  FermatFactor(this.n);

  calculate() {
    final stopwatch = Stopwatch()..start();

    int foundIn = 1;

    if (n <= 0) {
      return [
        [n, null],
        foundIn
      ];
    }

    if (!(n % 2 == 1)) {
      return [
        [n / 2, 2],
        foundIn
      ];
    }

    var a = sqrt(n).ceil();
    var b = 0;
    for (; foundIn > 0; foundIn++) {
      var c = a * a - n;
      b = sqrt(c).floor();

      if (b * b == c)
        break;
      else
        a += 1;
    }

    return [
      [a - b, a + b],
      foundIn,
      stopwatch.elapsed
    ];
  }
}
