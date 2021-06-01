class Perception {
  int p;
  double r;
  Perception(this.p, this.r);

  double w1 = 0;
  double w2 = 0;

  calculateSignal(point) {
    double x1 = point[0].toDouble();
    double x2 = point[1].toDouble();
    return this.w1 * x1 + w2 * x2;
  }

  getDelta(y) {
    double delta = this.p - y;
    if (delta > 0) {
      return delta;
    }
    return 0;
  }

  weightAdjustment(point, delta) {
    double x1 = point[0].toDouble();
    double x2 = point[1].toDouble();
    this.w1 += delta * x1 * this.r;
    this.w2 += delta * x2 * this.r;
  }

  learn(input, maxIterations, maxTime) {
    double time = 0;
    int iterations = 0;

    while (maxIterations > iterations && maxTime > time) {
      var startDate = DateTime.now().microsecondsSinceEpoch;
      for (final value in input) {
        var y = this.calculateSignal(value);
        var delta = this.getDelta(y);

        this.weightAdjustment(value, delta);
      }
      var endDate = DateTime.now().microsecondsSinceEpoch;
      time += (endDate - startDate) / 1000;
      iterations++;
    }
    return [w1, w2, time, iterations];
  }
}
