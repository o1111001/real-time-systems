import 'dart:math';

class Genetics {
  getRandomInt(int max) {
    Random random = new Random();
    return random.nextInt(max);
  }

  getStartPopulation(int pSize, int gSize, int maxGene) {
    return new List<int>.filled(pSize, 0).map((e) =>
        new List<int>.filled(gSize, 0).map((_) => this.getRandomInt(maxGene)));
  }

  int fitnes(var genes, var d, int y) {
    int index = 0;
    var value = 0;
    genes.forEach((element) {
      value += (element * d[index]);
      index++;
      return value;
    });
    return (y - value).abs();
  }

  calculateProbability(var deltas) {
    var invSumDeltas =
        deltas.fold(0, (value, element) => value + (1 / element));
    return deltas.map((e) => (1 / e) / invSumDeltas);
  }

  weightedRandom(var participants) {
    Random randomIns = new Random();
    var random = randomIns.nextDouble();
    var result = participants.map((e) {
      var gene = e['gene'];
      var probability = e['probability'];
      random -= probability;
      if (random < 0) {
        return gene;
      }
      return null;
    }).where((e) => e != null);
    return result.length != 0 ? result.toList()[0] : null;
  }

  roulette(participants, numWins) {
    return new List.filled(numWins, null)
        .map((e) => this.weightedRandom(participants));
  }

  mixGene(List<dynamic> nodes) {
    var parentA = nodes[0];
    var parentB = nodes[1];
    var mid = (parentA.toList().length / 2).floor();
    return [
      [...parentA.toList().sublist(0, mid), ...parentB.toList().sublist(mid)],
      [...parentB.toList().sublist(0, mid), ...parentA.toList().sublist(mid)]
    ];
  }

  mutation(var gene, value, double probability) {
    Random randomIns = new Random();
    var r = randomIns.nextDouble();
    var index = this.getRandomInt(gene.length);

    if (probability >= r) {
      int i = -1;
      return gene.map((element) {
        i++;
        return i == index ? value : element;
      });
    }
    return gene;
  }

  diophantineEquation(
      {List<int> equation, populationSize, maxIterations = 20}) {
    var y = equation.removeLast();
    var maxGene = (y / 2).ceil();
    print('Mx Gene: $maxGene');
    var population =
        this.getStartPopulation(populationSize, equation.length, maxGene);
    while (maxIterations > 0) {
      maxIterations--;
      var deltas = population.map((gene) => this.fitnes(gene, equation, y));
      var result = deltas.where((d) => d == 0).toList();
      if (result.length != 0) {
        return population.toList()[result[0]];
      }
      var probabilities = this.calculateProbability(deltas).toList();
      var pi = -1;
      var rouletteParticipants = new List();
      population.forEach((e) {
        var map = new Map();
        pi++;
        map['gene'] = e;
        map['probability'] = probabilities[pi];
        rouletteParticipants.add(map);
      });

      population = [];
      for (var i = 0; i < populationSize / 2; i++) {
        var bestGenes = this.roulette(rouletteParticipants, 2);
        var mixedGenes = this.mixGene(bestGenes.toList());
        var mutatedGenes = mixedGenes.map(
            (gene) => this.mutation(gene, this.getRandomInt(maxGene), 0.1));
        population..addAll(mutatedGenes);
      }
    }
    return population;
  }
}
